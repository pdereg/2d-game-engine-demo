local CHARACTER_KEY = "bear"
local STORY_PROGRESS_KEY = "bear_story_progress"

local story_progress = {}
story_progress.NO_PROGRES = 0
story_progress.PLAYER_MET_BEAR = 1

local instance


local function initialize_instance(x, y, direction)
    if instance ~= nil then
        Save:unregister_character(CHARACTER_KEY)
        instance:remove()
    end

    instance = Character.new("Bear")
    instance.x = x
    instance.y = y
    instance.direction = direction

    Save:read_character(CHARACTER_KEY, instance)
    Save:register_character(CHARACTER_KEY, instance)
end


local function save_current_progress(progress)
    Save:put(STORY_PROGRESS_KEY, progress)
end


local function get_current_progress()
    return Save:get(STORY_PROGRESS_KEY, story_progress.NO_PROGRES)
end


local function play_intro_cutscene()
    Display.post_processing = PostProcessing.None
    Game.player:stop()

    Cutscene:play(
        { Action.Talk, instance, "no-boss-battle-b1" },
        { Action.Talk, instance, "no-boss-battle-b2" },
        { Action.Talk, instance, "no-boss-battle-b3" },
        { Action.Talk, instance, "no-boss-battle-b4" },
        { Action.Talk, instance, "no-boss-battle-b5" },
        function()
            save_current_progress(story_progress.PLAYER_MET_BEAR)
            Audio:stop_music(true)
        end
    )
end


local function on_triggered()
    local launch_intro = get_current_progress() == story_progress.NO_PROGRES

    if launch_intro then
        play_intro_cutscene()
    end
end


local function set_event_callbacks()
    instance.on_triggered = on_triggered
end


function prepare_bear(x, y, direction)
    initialize_instance(x, y, direction)
    set_event_callbacks()

    return instance
end
