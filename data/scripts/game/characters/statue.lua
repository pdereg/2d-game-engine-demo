local CHARACTER_KEY = "statue"
local MONSTER_COUNT_KEY = "goblin_monster_count"

local instance
local event_callback_ids = {}


local function initialize_instance(x, y, direction)
    if instance ~= nil then
        for _, id in ipairs(event_callback_ids) do
            Event:unsubscribe(id)
        end

        Save:unregister_character(CHARACTER_KEY)
        instance:remove()
    end

    instance = Character.new("Statue")
    instance.x = x
    instance.y = y
    instance.direction = direction

    Save:read_character(CHARACTER_KEY, instance)
    Save:register_character(CHARACTER_KEY, instance)
end


local function is_day()
    return World.hour > 4 and World.hour < 23
end


local function on_enter_arena()
    if is_day() then
        return
    end

    Event:raise(event.SAVE_GAME_REQUESTED)

    Cutscene:play(
        function()
            Audio:stop_music(true)
        end,
        function()
            instance.color_red = 255
            instance.color_green = 0
            instance.color_blue = 0

            instance.light_color_red = 255
            instance.light_color_green = 0
            instance.light_color_blue = 0
        end,
        { Action.Talk, Game.player, "player-huh" },
        { Action.Wait, instance, 3000 },
        { Action.FadeOut, Game.player, 0 },
        function()
            Game.player.x = 1632
            Game.player.y = 700

            Display:clear_transitions():add_transition(Transition.FadeIn);
            Interface:show_notification("location-arena", Position.Bottom, true)

            Event:raise(event.PLAYER_LOCATION_CHANGED, location.ARENA)
        end,
        { Action.FadeIn, Game.player, 100 }
    )
end


local function show_entrance_prompt()
    Interface:show_prompt({
        enter_arena = on_enter_arena,
        walk_away = function() end
    })
end


local function on_triggered()
    local current_monster_count = Save:get(MONSTER_COUNT_KEY, 0)

    if current_monster_count >= 3 then
        Game.player:stop()
        show_entrance_prompt()
    end
end


local function light_up()
    Display:clear_transitions():add_transition(Transition.FadeIn)
    instance.is_lit = true

    local camera = Camera.new("Camera")
    camera.is_elevated = true
    camera.x = 1375
    camera.y = 2800
    camera:record()

    camera:wait(3000):move(camera.x, camera.y)
    camera.on_movement_ended = function()
        Event:raise(event.SAVE_GAME_REQUESTED)
        Event:raise(event.PLAYER_RECORDING_REQUESTED)
        camera.on_movement_ended = nil
    end
end


local function on_goblin_oversized()
    local current_monster_count = Save:get(MONSTER_COUNT_KEY, 0)
    local new_monster_count = current_monster_count + 1

    Save:put(MONSTER_COUNT_KEY, new_monster_count)

    if new_monster_count == 3 then
        World.hour = 0
        light_up()
    end
end


local function on_goblin_shrinked()
    local current_monster_count = Save:get(MONSTER_COUNT_KEY, 1)
    local new_monster_count = current_monster_count - 1

    Save:put(MONSTER_COUNT_KEY, new_monster_count)

    if new_monster_count == 0 then
        instance.is_lit = false
    end
end


local function set_event_callbacks()
    instance.on_triggered = on_triggered

    local on_goblin_oversided_id = Event:subscribe(event.GOBLIN_OVERSIZED, on_goblin_oversized)
    table.insert(event_callback_ids, on_goblin_oversided_id)

    local on_goblin_shrinked_id = Event:subscribe(event.GOBLIN_SHRINKED, on_goblin_shrinked)
    table.insert(event_callback_ids, on_goblin_shrinked_id)
end


function prepare_statue(x, y, direction)
    initialize_instance(x, y, direction)
    set_event_callbacks()

    return instance
end
