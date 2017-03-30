# Camera
Camera is a lightweight type of entity. It has a special ability to "record" a part of the screen according to its
position and size. Only one camera can "record" the screen at any given time. **Up to 8 cameras can exist simultaneously
in the game.**

Most attributes can be modified (changes take place immediately). By default, camera's attributes are populated from the
global JSON entity definition file.

Methods can be chained together in order to create a process queue. **Up to 8 processes can be queued at any given time.**

Additionally, hooks are provided for entity-related events sent from the engine. Only one callback per event type can be
set - if setting a callback for the second time, the previously set callback will be removed. Additionally, `nil` can be
set in order to remove any previously set callbacks.


### Constructors

```
Camera.new(name: string) -> Camera
```
Creates and returns a new camera built from an entity template of a given `name`.


### Attributes

```
.id -> number
```
Returns camera's unique ID (read-only).

```
.tag -> string
```
Defines camera's tag (useful for filtering).

```
.x -> number
```
Defines camera's X coordinate on the map.

```
.y -> number
```
Defines camera's Y coordinate on the map.

```
.direction -> Direction
```
Defines camera's direction (north, south, east, west).

```
.is_elevated -> boolean
```
Defines camera's elevation (if true, the camera is elevated).

```
.width -> number
```
Defines camera's width.

```
.height -> number
```
Defines camera's height.

```
.acceleration -> number
```
Defines camera's acceleration (by how much it accelerates until reaching its maximum velocity).

```
.max_velocity -> number
```
Defines camera's maximum velocity.

```
.is_moving -> boolean
```
Returns whether camera is currently moving (read-only).

```
.is_resizing -> boolean
```
Returns whether camera is currently resizing (read-only).

```
.is_waiting -> boolean
```
Returns whether camera is currently waiting (read-only).


### Methods

```
:remove() -> nil
```
Removes camera from the game.

```
:move(x: number, y: number) -> self
```
Adds a new movement process to the camera's process queue. The camera will move to given `x` and `y` coordinates.

```
:record() -> self
```
Adds a new record process to the camera's process queue.

```
:resize(width: number, y: number) -> self
```
Adds a new resize process to the camera's process queue. The camera will be resized to given `width` and `height`.

```
:wait(milliseconds: number) -> self
```
Adds a new wait process to the camera's process queue. The camera will wait a given amount of `milliseconds`.

```
:stop() -> nil
```
Stops camera's current processes and clears its entire process queue.


### Callbacks

```
.on_primary_idle -> function()
```
Called when the camera is not doing any primary activity (eg. just finished moving or waiting and has nothing else in its primary queue).

```
.on_secondary_idle -> function()
```
Called when the camera is not doing any secondary activity (eg. just finished resizing and has nothing else in its secondary queue).

```
.on_movement_started -> function(x: number, y: number)
```
Called when the camera started moving towards given `x` and `y` coordinates.

```
.on_movement_ended -> function(completed: boolean)
```
Called when the camera ended moving.

```
.on_resize_started -> function(width: number, height: number)
```
Called when the camera started resizing to given `width` and `height`.

```
.on_resize_ended -> function(completed: boolean)
```
Called when the camera ended resizing.

```
.on_wait_started -> function(milliseconds: number)
```
Called when the camera started waiting for a given amount of `milliseconds`.

```
.on_wait_ended -> function(completed: boolean)
```
Called when the camera ended waiting.
