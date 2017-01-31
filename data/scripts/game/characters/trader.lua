local CHARACTER_KEY = "trader"
local STORY_PROGRESS_KEY = "trader_story_progress"

local story_progress = {}
story_progress.NO_PROGRES = 0
story_progress.PLAYER_MET_TRADER = 1

local instance

local cutscene_2_played = false
local cutscene_3_played = false


local function initialize_instance(x, y, direction)
    if instance ~= nil then
        Save:unregister_character(CHARACTER_KEY)
        instance:remove()
    end

    instance = Character.new("Trader")
    instance.x = x
    instance.y = y
    instance.direction = direction

    Save:read_character(CHARACTER_KEY, instance)
    Save:register_character(CHARACTER_KEY, instance)
end


local function save_current_progress(progress)
    Save:put(STORY_PROGRESS_KEY, progress)
end


local function play_cutscene_1()
    Cutscene:play(
        { Action.Talk, instance, "trader-hello-t1" },
        { Action.Talk, instance, "trader-hello-t2" },
        function()
            save_current_progress(story_progress.PLAYER_MET_TRADER)
            Event:raise(event.SAVE_GAME_REQUESTED)
        end
    )
end


local function is_day()
    return World.hour > 4 and World.hour < 23
end


local function play_cutscene_2()
    Cutscene:play(
        { Action.Talk, instance, "trader-night-t1" },
        { Action.Talk, instance, "trader-night-t2" }
    )
end


local function play_cutscene_2_alt()
    if not instance.is_talking then
        instance:talk("trader-night-t1"):talk("trader-night-t2")
    end
end


local function play_cutscene_3()
    Cutscene:play(
        { Action.Talk, instance, "trader-nothing-to-see-here-t1" },
        { Action.Talk, Game.player, "trader-nothing-to-see-here-p1" }
    )
end


local function play_cutscene_3_alt()
    if not instance.is_talking then
        instance:talk("trader-nothing-to-see-here-t1")
    end
end


local function get_current_progress()
    return Save:get(STORY_PROGRESS_KEY, story_progress.NO_PROGRES)
end


local function on_triggered()
    local progress = get_current_progress()

    if progress == story_progress.NO_PROGRES then
        play_cutscene_1()
    elseif progress == story_progress.PLAYER_MET_TRADER then
        if not is_day() then
            if not cutscene_2_played then
                play_cutscene_2()
                cutscene_2_played = true
                cutscene_3_played = false
            else
                play_cutscene_2_alt()
            end
        else
            if not cutscene_3_played then
                play_cutscene_3()
                cutscene_3_played = true
                cutscene_2_played = false
            else
                play_cutscene_3_alt()
            end
        end
    end
end


local function set_event_callbacks()
    instance.on_triggered = on_triggered
end


function prepare_trader(x, y, direction)
    initialize_instance(x, y, direction)
    set_event_callbacks()

    return instance
end
