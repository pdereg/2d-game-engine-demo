local informed_about_goblins = false


local function show_hint_about_goblins()
    Game.player:stop()
    Interface:show_message("talk-to-the-goblins")
end


local function on_night_began()
    if not informed_about_goblins then
        informed_about_goblins = true
        show_hint_about_goblins()
    end
end


function initialize_story_helper()
    Event:subscribe(event.NIGHT_BEGAN, on_night_began)
end
