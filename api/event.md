#Event
Event is a globally accessible singleton event dispatcher to be used exclusively by Lua scripts. The dispatcher itself
doesn't communicate with the engine and its main purpose is to provide an easy and clean way for various scripts to
communicate with each other without unnecessary coupling.

**Event dispatching takes place immediately** - that is, each call to 'raise' will immediately call all listeners subscribed
to the event type that is being raised. Because of that, it is recommended to limit the amount of events thrown from
inside the callbacks.


###Methods

```
Event:raise(type: string, payload: [string, number, boolean, array, function]) -> number
```
Immediately dispatches event with optional payload to all subscribers listening to events of specified type. Returned
number indicates the amount of subscribers called.

```
Event:subscribe(type: string, callback: function) -> number
```
Registers provided `callback` to be called every time an event of the specified `type` is raised. Returned number is an unique
ID that can be later used when calling the `unsubscribe` method.

```
Event:unsubscribe(id: number) -> boolean
```
Unregisters previously subscribed callback of provided `id`.