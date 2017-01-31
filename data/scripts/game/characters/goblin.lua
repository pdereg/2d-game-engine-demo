local CHARACTER_KEY = "goblin"
local TAG_MONSTER = "monster"

local DISTANCE_OFFSET = 50
local MIN_WAIT_TIME = 2000
local MAX_WAIT_TIME = 4000

local id_pool = 0


local function initialize_new_instance(x, y, direction)
    id_pool = id_pool + 1

    local instance = Character.new("Goblin")
    instance.x = x
    instance.y = y
    instance.direction = direction

    Save:read_character(CHARACTER_KEY .. id_pool, instance)
    Save:register_character(CHARACTER_KEY .. id_pool, instance)

    return instance
end


local function get_random_between(n, offset)
    offset = offset or 0
    return math.random(n - offset , n + offset)
end


local function get_random_x_position(instance, multiplier)
    multiplier = multiplier or 1
    local distance = DISTANCE_OFFSET * multiplier

    return get_random_between(instance.x, distance)
end


local function get_random_y_position(instance, multiplier)
    multiplier = multiplier or 1
    local distance = DISTANCE_OFFSET * multiplier

    return get_random_between(instance.y, distance)
end


local function get_random_wait_time()
    return math.random(MIN_WAIT_TIME, MAX_WAIT_TIME)
end


local function new_on_primary_idle_callback(instance)
    return function()
        local x = get_random_x_position(instance)
        local y = get_random_y_position(instance)
        local wait_time = get_random_wait_time()

        local direction = math.random(1, 2)
        if direction == 1 then
            instance:move(instance.x, y):wait(wait_time)
        else
            instance:move(x, instance.y):wait(wait_time)
        end
    end
end


local function new_on_collided_callback(instance)
    return function(_)
        instance:stop()
    end
end


local function is_day()
    return World.hour > 4 and World.hour < 23
end


local function get_goblin_sound_filepath()
    local filepath = "sounds/"

    local type = math.random(1, 2)
    if type == 1 then
        filepath = filepath .. "goblin_1.ogg"
    else
        filepath = filepath .. "goblin_2.ogg"
    end

    return filepath
end


local function run_away(instance)
    instance:stop()

    local x = get_random_x_position(instance, 2)
    local y = get_random_y_position(instance, 2)

    local sound_filepath = get_goblin_sound_filepath()
    instance:play_sound(sound_filepath)

    local direction = math.random(1, 2)
    if direction == 1 then
        instance:move(instance.x, y):move(x, y)
    else
        instance:move(x, instance.y):move(x, y)
    end
end


local function play_cutscene_1(instance)
    instance.tag = TAG_MONSTER

    local camera = Camera.new("Camera")

    Cutscene:play(
        function()
            Game.player:stop()

            camera.x = Game.player.x
            camera.y = Game.player.y
            camera:record()

            instance.speech_offset_y = 32
            instance.is_elevated = true

            instance.color_red = 0
            instance.color_green = 255
            instance.color_blue = 0
        end,
        { Action.Move, camera, instance.x, instance.y },
        { Action.Resize, instance, instance.width * 2, instance.height * 2 },
        { Action.Talk, instance, "goblin-transformation-g1" },
        { Action.Move, camera, Game.player.x, Game.player.y },
        function()
            instance.collision_width = 32
            instance.collision_height = 20
            instance.collision_offset_y = -24

            instance.max_velocity = 1
            instance.is_elevated = false

            Event:raise(event.PLAYER_RECORDING_REQUESTED)
            Event:raise(event.GOBLIN_OVERSIZED, instance)
        end
    )
end


local function new_on_player_collided_with_entity(instance)
    return function(entity_id)
        if entity_id ~= instance.id then
            return
        end

        Game.player:stop()

        if is_day() and instance.tag ~= TAG_MONSTER then
            run_away(instance)
        elseif instance.tag ~= TAG_MONSTER then
            play_cutscene_1(instance)
        end
    end
end


local function play_cutscene_2(instance)
    instance.tag = ""

    instance:stop()
    instance:resize(instance.width / 2, instance.height / 2):talk("goblin-what-the")

    instance.collision_width = 24
    instance.collision_height = 8
    instance.collision_offset_y = -14

    instance.color_red = 255
    instance.color_green = 255
    instance.color_blue = 255

    instance.speech_offset_y = 0
    instance.max_velocity = 96

    Event:raise(event.GOBLIN_SHRINKED, instance)
end


local function new_on_night_ended(instance)
    return function()
        if instance.tag == TAG_MONSTER then
            play_cutscene_2(instance)
        end
    end
end


local function set_event_callbacks(instance)
    instance.on_primary_idle = new_on_primary_idle_callback(instance)
    instance.on_collided = new_on_collided_callback(instance)

    Event:subscribe(event.PLAYER_COLLIDED_WITH_ENTITY, new_on_player_collided_with_entity(instance))
    Event:subscribe(event.NIGHT_ENDED, new_on_night_ended(instance))
end


function prepare_new_goblin(x, y, direction)
    local instance = initialize_new_instance(x, y, direction)
    set_event_callbacks(instance)

    return instance
end
