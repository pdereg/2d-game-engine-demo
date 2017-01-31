local NIGHT_MUSIC_PATH = "music/night_music.ogg"

local is_initialized = false
local player_is_busy = false


function house_entry()
    local player = Game.player

    if player.direction ~= Direction.North then
        return
    end

    player.x = 480
    player.y = 277

    Audio:stop_music()
    Event:raise(event.PLAYER_LOCATION_CHANGED, location.TRADER_HOUSE)
end


local function play_cave_blocked_cutscene(x, y)
    player_is_busy = true
    local player = Game.player

    Cutscene:play(
        { Action.Wait, player, 1000 },
        { Action.Talk, player, "player-cave-blocked" },
        { Action.Move, player, x, y },
        function() player_is_busy = false end
    )
end


function cave_entrance_west()
    if player_is_busy then
        return
    end

    local player = Game.player
    play_cave_blocked_cutscene(player.x + 50, player.y)
end


function cave_entrance_south()
    if player_is_busy then
        return
    end

    local player = Game.player
    play_cave_blocked_cutscene(player.x, player.y - 50)
end


local function is_night()
    return World.hour < 5 or World.hour > 22
end


local function prepare_location()
    Display:clear_transitions():add_transition(Transition.FadeIn)
    Interface:show_notification("location-village", Position.Bottom, true)

    if is_night() then
        Audio:play_music(NIGHT_MUSIC_PATH, true)
    end
end


local function on_player_location_changed(player_location)
    if player_location ~= location.VILLAGE then
        return
    end

    prepare_location()
end


local function on_night_began()
    local player_location = Save:get(PLAYER_LOCATION_KEY)

    if player_location == location.VILLAGE then
        Audio:play_music(NIGHT_MUSIC_PATH, true)
    end
end


local function on_night_ended()
    local player_location = Save:get(PLAYER_LOCATION_KEY)

    if player_location == location.VILLAGE then
        Audio:stop_music()
    end
end


local function set_event_callbacks()
    Event:subscribe(event.PLAYER_LOCATION_CHANGED, on_player_location_changed)
    Event:subscribe(event.NIGHT_BEGAN, on_night_began)
    Event:subscribe(event.NIGHT_ENDED, on_night_ended)
end


function initialize_village()
    if is_initialized then
        return
    end

    is_initialized = true
    set_event_callbacks()
end
