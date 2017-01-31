local CHARACTER_KEY = "player"

local instance


local function initialize_instance(x, y, direction)
    if instance ~= nil then
        Save:unregister_character(CHARACTER_KEY)
        instance:remove()
    end

    instance = Character.new("Player")
    instance.x = x
    instance.y = y
    instance.direction = direction

    Save:read_character(CHARACTER_KEY, instance)
    Save:register_character(CHARACTER_KEY, instance)
end


local function on_collided(entity_id)
    Event:raise(event.PLAYER_COLLIDED_WITH_ENTITY, entity_id)
end


local function set_event_callbacks()
    instance.on_collided = on_collided
end


function prepare_player(x, y, direction)
    initialize_instance(x, y, direction)
    set_event_callbacks()

    return instance
end

function test(_, millis, data)
    if not data.millis then
        data.millis = millis
    else
        data.millis = data.millis + millis
    end

    if data.millis < 2000 then
        if not data.first_moved then
            data.first_moved = true
            instance.x = Game.player.x - 30
        end
    elseif data.millis < 4000 then
        if not data.second_moved then
            data.second_moved = true
            instance.y = Game.player.y + 30
        end
    elseif data.millis >= 6000 then
        instance.x = Game.player.x + 30
        instance.y = Game.player.y - 30
        return nil
    end

    return data
end
