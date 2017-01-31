local instance


local function initialize_instance()
    instance = Camera.new("Camera")

    local player = Game.player
    instance.x = player.x
    instance.y = player.y
end


local function on_primary_idle()
    local player = Game.player
    instance.x = player.x
    instance.y = player.y
    instance:stop()
end


local function on_player_recording_requested()
    instance:record()
end


local function set_event_callbacks()
    instance.on_primary_idle = on_primary_idle
    Event:subscribe(event.PLAYER_RECORDING_REQUESTED, on_player_recording_requested)
end


function prepare_player_camera()
    if instance ~= nil then
        return
    end

    initialize_instance()
    set_event_callbacks()

    return instance
end
