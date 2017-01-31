require "scripts.game.locations.arena"
require "scripts.game.locations.trader_house"
require "scripts.game.locations.village"


location = {}
location.ARENA = 1
location.TRADER_HOUSE = 2
location.VILLAGE = 3

PLAYER_LOCATION_KEY = "player_location"

local is_initialized = false


local function on_player_location_changed(player_location)
    Save:put(PLAYER_LOCATION_KEY, player_location)
end


local function set_event_callbacks()
    Event:subscribe(event.PLAYER_LOCATION_CHANGED, on_player_location_changed)
end


local function notify_player_current_location()
    local player_location = Save:get(PLAYER_LOCATION_KEY, nil)

    if player_location ~= nil then
        Event:raise(event.PLAYER_LOCATION_CHANGED, player_location)
    end
end


function initialize_locations()
    if is_initialized then
        return
    end

    is_initialized = true
    set_event_callbacks()

    initialize_arena()
    initialize_trader_house()
    initialize_village()

    notify_player_current_location()
end
