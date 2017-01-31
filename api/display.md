#Display
Display is a globally accessible singleton that provides a convenient way to communicate with the display device.


###Attributes
```
Display.post_processing -> PostProcessing
```
Defines post processing to apply to the rendered content.


###Methods
```
Display:add_transition(transition: Transition) -> Display
```
Queues a new `transition` to be applied.

```
Display:skip_transition() -> Display
```
Skips current transition and moves on to the next one if available.

```
Display:clear_transitions() -> nil
```
Clears the transition queue.