#World
World is a globally accessible singleton which provides access to the in-game world.


###Attributes

```
.hour -> number
```
Defines hour of the day.


###Callbacks

```
.on_time_changed -> function(hour: number)
```
Called when `hour` of the day was changed.