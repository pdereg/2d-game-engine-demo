#Interface
Interface is a globally accessible singleton which provides access to the in-game graphical user interface.


###Methods
```
Interface:show_message(text_id: string) -> nil
```
Displays a pop-up message of provided `text_id`.

```
Interface:show_notification(text_id: string, position: Position, fade_in: boolean) -> nil
```
Displays a time-based notification with a text of provided `text_id` at the specified `position` on the screen. Optionally, `fade_in` can be
set in order to specify whether a "fade-in" animation should be applied.

```
Interface:show_prompt(choices: table) -> nil
```
Displays a prompt with choices for user to select. Provided table needs to conform to the provided scheme:
`{text_id=callback_function}`, where `text_id` is the ID of the choice text and `callback_function` is a callable to execute
when the choice is selected