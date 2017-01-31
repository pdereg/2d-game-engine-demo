#Cutscene
Cutscene is a globally accessible singleton convenience object that allows for creating in-game cutscenes. Its main
purpose is to greatly ease the creation of complex cutscenes that would otherwise require writing a lot of boilerplate
code.

Cutscenes make use of "hidden" hooks provided by the engine and thus don't interfere with regular event callbacks.


###Methods

```
Cutscene:play(action: [array, function] ...) -> nil
```
Takes an arbitrary amount of actions and executes them in the exact order. An action can be either a Lua function or an
array which describes a specific action to apply to provided entity. **During a cutscene, player's controls are disabled
and a greyscale filter is applied to display.**

The difference between executing a regular function from an action array is that functions, upon execution, will always
immediately trigger the next action on the list. Action arrays, on the other hand, will only trigger the next action on
the list when the action they define themselves actually completes (i.e. entity moves to a specific position).

**Note that only one cutscene can be played at any given time. Any attempt to play a new cutscene while another is
currently playing will be discarded.**

Available action arrays:
```
{ Action.FadeIn, entity: Character, opacity: number },
{ Action.FadeOut, entity: Character, opacity: number }
{ Action.Talk, entity: [Camera, Character], text_id: string }
{ Action.Turn, entity: [Camera, Character], direction: Direction }
{ Action.Move, entity: [Camera, Character], x: number, y: number }
{ Action.Resize, entity: [Camera, Character], width: number, height: number }
{ Action.Wait, entity: [Camera, Character], milliseconds: number }
```

Example:
```lua
Cutscene:play(
    { Action.Move, Game.player, 128, 256 },         -- Moves player to coordinates 128:256
    function() some_procedure() end,                -- Calls some_procedure AFTER previous movement action actually completes
    { Action.Talk, other_character, "dialogue-1" }  -- Makes other_character talk specified dialogue IMMEDIATELY after previous function returns
)
```