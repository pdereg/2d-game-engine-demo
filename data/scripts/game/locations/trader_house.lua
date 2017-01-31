local TRADER_HOUSE_MUSIC_PATH = "music/trader_house.ogg"

local is_initialized = false


function house_exit()
    local player = Game.player

    if player.direction ~= Direction.South then
        return
    end

    player.x = 2322
    player.y = 2510

    Audio:stop_music()
    Event:raise(event.PLAYER_LOCATION_CHANGED, location.VILLAGE)
end


local function prepare_location()
    Display:clear_transitions():add_transition(Transition.FadeIn)
    Interface:show_notification("location-trader-house", Position.Bottom, true)
    Audio:play_music(TRADER_HOUSE_MUSIC_PATH, true)
end


local function on_player_location_changed(player_location)
    if player_location ~= location.TRADER_HOUSE then
        return
    end

    prepare_location()
end


local function set_event_callbacks()
    Event:subscribe(event.PLAYER_LOCATION_CHANGED, on_player_location_changed)
end


function initialize_trader_house()
    if is_initialized then
        return
    end

    is_initialized = true
    set_event_callbacks()
end
