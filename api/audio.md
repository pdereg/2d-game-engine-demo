# Audio
Audio is a globally accessible singleton that provides a convenient way to communicate with the audio device.


### Attributes

```
Audio.volume -> number
```

Defines global volume level for the audio device.


### Methods

```
Audio:play_music(file_path: string, fade_in: boolean) -> nil
```
Plays music at provided `file_path`. Optionally, `fade_in` can be set in order to specify whether a "fade in" effect should
be applied. If music is already playing, it will be automatically stopped first.

```
Audio:stop_music(fade_out: boolean) -> nil
```
Stops currently played music. Optionally, `fade_out` can be set in order to specify whether a "fade out" effect should be
applied.

```
Audio:pause_music() -> nil
```
Pauses currently played music.

```
Audio:resume_music() -> nil
```
Resumes previously paused music.
