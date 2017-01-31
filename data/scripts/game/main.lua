require "scripts.game.events"
require "scripts.game.story_helper"
require "scripts.game.cameras.player"
require "scripts.game.characters.bear"
require "scripts.game.characters.goblin"
require "scripts.game.characters.player"
require "scripts.game.characters.statue"
require "scripts.game.characters.trader"
require "scripts.game.locations.locations"


local NEW_GAME_KEY = "new_game"

local NIGHT_START_HOUR = 23
local NIGHT_END_HOUR = 5

local cameras = {}
local characters = {}


local function prepare_display()
    Display.post_processing = PostProcessing.Sepia
end


local function prepare_world()
    initialize_locations()
end


local function prepare_story()
    initialize_story_helper()
end


local function prepare_characters()
    characters.player = prepare_player(1220, 2886, Direction.East)
    characters.trader = prepare_trader(570, 165, Direction.South)
    characters.statue = prepare_statue(1375, 2800, Direction.South)
    characters.bear = prepare_bear(3110, 752, Direction.East)

    characters.goblins = {}
    table.insert(characters.goblins, prepare_new_goblin(1352, 3234, Direction.South))
    table.insert(characters.goblins, prepare_new_goblin(2812, 2098, Direction.South))
    table.insert(characters.goblins, prepare_new_goblin(2382, 3374, Direction.South))
end


local function prepare_cameras()
    cameras.player = prepare_player_camera()
end


local function on_time_changed(hour)
    if hour == NIGHT_START_HOUR then
        Event:raise(event.NIGHT_BEGAN)
    elseif hour == NIGHT_END_HOUR then
        Event:raise(event.NIGHT_ENDED)
    end
end


local function on_save_game_requested()
    Interface:show_notification("game-saving", Position.TopLeft)
    Save:commit()
end


local function set_event_callbacks()
    World.on_time_changed = on_time_changed
    Event:subscribe(event.SAVE_GAME_REQUESTED, on_save_game_requested)
end


local function play_intro()
    World.hour = 14

    local camera = Camera.new("Camera")
    local height = camera.height

    Cutscene:play(function()
        camera.x = 2320
        camera.y = 2886
        camera.height = 0
        camera:record()
    end,
        function()
            Interface:show_notification("scripted-bytes", Position.Center, true)
        end,
        { Action.Wait, camera, 3000 },
        function()
            Display:clear_transitions():add_transition(Transition.FadeIn)
            camera.height = height
        end,
        { Action.Move, camera, characters.player.x, characters.player.y },
        function()
            Display:clear_transitions():add_transition(Transition.FadeIn)
            cameras.player:record()
        end,
        function()
            Interface:show_message("welcome")
        end)
end


function main()
    prepare_display()
    prepare_world()

    prepare_characters()
    Game.player = characters.player

    prepare_cameras()
    cameras.player:record()

    prepare_story()
    set_event_callbacks()

    local is_new_game = Save:get(NEW_GAME_KEY, true)
    if is_new_game then
        Save:put(NEW_GAME_KEY, false)
        play_intro()
    end
end
