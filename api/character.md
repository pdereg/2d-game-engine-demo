## Character
Character is the most complex type of entity in the game. It supports animated sprites, can play sounds, move around,
collide with environment, emit light, be triggered by player's entity and more. **Up to 256 characters can exist
simultaneously in the game.**

Most attributes can be modified (changes take place immediately). By default, character's attributes are populated from
the global JSON entity definition file.

Methods can be chained together in order to create a process queue. **Up to 8 processes can be queued at any given time.**

Additionally, hooks are provided for entity-related events sent from the engine. Only one callback per event type can be
set - if setting a callback for the second time, the previously set callback will be removed. Additionally, `nil` can be
set in order to remove any previously set callbacks.


### Constructors

```
Character.new(name: string) -> Character
```
Creates and returns a new character built from an entity template of a given `name`.


### Attributes

```
.id -> number
```
Returns character's unique ID (read-only).

```
.tag -> string
```
Defines character's tag (useful for filtering).

```
.x -> number
```
Defines character's X coordinate on the map.

```
.y -> number
```
Defines character's Y coordinate on the map.

```
.direction -> Direction
```
Defines character's direction (north, south, east, west).

```
.is_elevated -> boolean
```
Defines character's elevation (if true, the character is elevated).

```
.color_red -> number
```
Defines red color level for character's sprite.

```
.color_green -> number
```
Defines green color level for character's sprite.

```
.color_blue -> number
```
Defines blue color level for character's sprite.

```
.opacity -> number
```
Defines opacity level for character's sprite.

```
.light_color_red -> number
```
Defines red color level for character's light.

```
.light_color_green -> number
```
Defines green color level for character's light.

```
.light_color_blue -> number
```
Defines blue color level for character's light.

```
.light_flicker -> number
```
Defines character's light flicker.

```
.light_radius -> number
```
Defines character's light radius.

```
.light_offset_x -> number
```
Defines X offset for character's light.

```
.light_offset_y -> number
```
Defines Y offset for character's light.

```
.is_lit -> boolean
```
Defines whether character should emit light (if true, the character emits light).

```
.width -> number
```
Defines character's width.

```
.height -> number
```
Defines character's height.

```
.collision_width -> number
```
Defines width of character's collision box.

```
.collision_height -> number
```
Defines height of character's collision box.

```
.collision_offset_x -> number
```
Defines X offset of character's collision box.

```
.collision_offset_y -> number
```
Defines Y offset of character's collision box.

```
.speech_offset_x -> number
```
Defines X offset of character's speech bubble.

```
.speech_offset_y -> number
```
Defines Y offset of character's speech bubble.

```
.acceleration -> number
```
Defines character's acceleration (by how much it accelerates until reaching its maximum velocity).

```
.max_velocity -> number
```
Defines character's maximum velocity.

```
.is_fading_in -> boolean
```
Returns whether character is currently fading in (read-only).

```
.is_fading_out -> boolean
```
Returns whether character is currently fading out (read-only).

```
.is_moving -> boolean
```
Returns whether character is currently moving (read-only).

```
.is_resizing -> boolean
```
Returns whether character is currently resizing (read-only).

```
.is_playing_sound -> boolean
```
Returns whether character is currently playing sound (read-only).

```
.is_talking -> boolean
```
Returns whether character is currently talking (read-only).

```
.is_waiting -> boolean
```
Returns whether character is currently waiting (read-only).


### Methods

```
:remove() -> nil
```
Removes character from the game.

```
:fade_in(opacity: number) -> self
```
Adds a new fade in process to the character's process queue. The character will fade in to provided `opacity` level.

```
:fade_out(opacity: number) -> self
```
Adds a new fade out process to the character's process queue. The character will fade out to provided `opacity` level.

```
:move(x: number, y: number) -> self
```
Adds a new movement process to the character's process queue. The character will move to given `x` and `y` coordinates.

```
:play_sound(file_path: string) -> self
```
Adds a new play sound process to the character's process queue. The character will play a sound located at given `file_path`.

```
:resize(width: number, y: number) -> self
```
Adds a new resize process to the character's process queue. The character will be resized to given `width` and `height`.

```
:talk(text_id: string) -> self
```
Adds a new talk process to the character's process queue. The character will speak the text of provided `text_id`.

```
:wait(milliseconds: number) -> self
```
Adds a new wait process to the character's process queue. The character will wait a given amount of `milliseconds`.

```
:stop() -> nil
```
Stops character's current processes and clears its entire process queue.


### Callbacks

```
.on_collided -> function(id: number)
```
Called when the character collided with another entity of a given `id`.

```
.on_triggered -> function()
```
Called when the character was triggered by a player-controlled entity.

```
.on_primary_idle -> function()
```
Called when the character is not doing any primary activity (eg. just finished moving or waiting and has nothing else in its primary queue).

```
.on_secondary_idle -> function()
```
Called when the character is not doing any secondary activity (eg. just finished talking or resizing and has nothing else in its secondary queue).

```
.on_fading_in_started -> function(opacity: number)
```
Called when the character started fading in to given `opacity` level.

```
.on_fading_in_ended -> function(completed: boolean)
```
Called when the character ended fading in.

```
.on_fading_out_started -> function(opacity: number)
```
Called when the character started fading out to given `opacity` level.

```
.on_fading_out_ended -> function(completed: boolean)
```
Called when the character ended fading out.

```
.on_movement_started -> function(x: number, y: number)
```
Called when the character started moving towards given `x` and `y` coordinates.

```
.on_movement_ended -> function(completed: boolean)
```
Called when the character ended moving.

```
.on_play_sound_started -> function()
```
Called when the character started playing sound.

```
.on_play_sound_ended -> function(completed: boolean)
```
Called when the character ended playing sound.

```
.on_resize_started -> function(width: number, height: number)
```
Called when the character started resizing to given `width` and `height`.

```
.on_resize_ended -> function(completed: boolean)
```
Called when the character ended resizing.

```
.on_talk_started -> function()
```
Called when the character started talking.

```
.on_talk_ended -> function(completed: boolean)
```
Called when the character ended talking.

```
.on_wait_started -> function(milliseconds: number)
```
Called when the character started waiting for a given amount of `milliseconds`.

```
.on_wait_ended -> function(completed: boolean)
```
Called when the character ended waiting.
