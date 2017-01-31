local ARENA_MUSIC_PATH = "music/arena.ogg"

local is_initialized = false


local function prepare_location()
    Display:clear_transitions():add_transition(Transition.FadeIn)
    Interface:show_notification("location-arena", Position.Bottom, true)
    Audio:play_music(ARENA_MUSIC_PATH, true)
end


local function on_night_ended()
    World.hour = 23
end


local function on_player_location_changed(player_location)
    if player_location ~= location.ARENA then
        return
    end

    prepare_location()

    Event:subscribe(event.NIGHT_ENDED, on_night_ended)
end


local function set_event_callbacks()
    Event:subscribe(event.PLAYER_LOCATION_CHANGED, on_player_location_changed)
end


function initialize_arena()
    if is_initialized then
        return
    end

    is_initialized = true
    set_event_callbacks()
end
