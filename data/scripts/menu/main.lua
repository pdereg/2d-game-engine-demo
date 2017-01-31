local camera
local dragon
local fireplace

local goblins_created = false


local function prepare_dragon()
    dragon = Character.new("Dragon")
    dragon.x = 500
    dragon.y = 200

    dragon.on_primary_idle = function()
        dragon:move(2100, dragon.y):move(500, dragon.y)
    end
end


local function prepare_camera()
    camera = Camera.new("Camera")
    camera.x = 1300
    camera.y = 300
    camera.acceleration = 1
    camera.max_velocity = 1

    camera.on_primary_idle = function()
        camera:move(1350, camera.y):move(1250, camera.y)
    end
end


local function prepare_fireplace()
    fireplace = Character.new("flame")
    fireplace.x = 1060
    fireplace.y = 520

    local color = { math.random(155, 255), math.random(155, 255), math.random(155, 255) }
    fireplace.color_red = color[1]
    fireplace.color_blue = color[2]
    fireplace.color_green = color[3]

    fireplace.light_color_red = color[1]
    fireplace.light_color_blue = color[2]
    fireplace.light_color_green = color[3]
end


local function create_goblins()
    local goblins = {}

    for i = 1, 3 do
        local goblin = Character.new("Goblin")

        local color = { math.random(155, 255), math.random(155, 255), math.random(155, 255) }
        goblin.color_red = color[1]
        goblin.color_blue = color[2]
        goblin.color_green = color[3]

        goblin.on_primary_idle = function()
            goblin:move(math.random(goblin.x - 50, goblin.x + 50), goblin.y):wait(math.random(1000, 3000))
        end

        goblin.on_collided = function(_)
            goblin:stop()
        end

        goblins[i] = goblin
    end

    goblins[1].x = 900
    goblins[1].y = 600
    goblins[2].x = 1300
    goblins[2].y = 600
    goblins[3].x = 1700
    goblins[3].y = 600

    goblins_created = true
end


function main()
    Game.is_interactive = false

    prepare_dragon()
    prepare_camera()
    prepare_fireplace()

    Game.player = dragon

    World.hour = 0
    World.on_time_changed = function(hour)
        if hour == 5 and not goblins_created then
            create_goblins()
        end
    end

    Audio:play_music("music/menu_main.ogg")
    Display.post_processing = PostProcessing.Greyscale

    camera:record()
end
