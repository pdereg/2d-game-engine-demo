# Save
Save is a globally accessible singleton game saving mechanism. Its main purpose is to provide a convenient way for
storing and retrieving data to/from game's save file.

Anything stored in save is immediately available to anyone, **however the actual file with current save data is only
created upon calling the `commit` method**. This is in order to minimize the amount of IO operations and to encourage a wide
use of the mechanism throughout the codebase without worrying about the performance.

**Currently, only simple data types can be stored in save data, such as strings, numbers and booleans.**


### Methods

```
Save:read_character(key: string, character: Character) -> nil
```
Deserializes `character` stored at provided `key` from save data.

```
Save:write_character(key: string, character: Character) -> nil
```
Serializes provided `character` to save data. **Note that this function doesn't actually write anything to disk.**

```
Save:register_character(key: string, character: Character) -> nil
```
Registers provided `character` for automatic save, such that no explicit calls to `write_character` will be necessary.

```
Save:unregister_character(key: string) -> boolean
```
Unregisters previously registered character at provided `key`, so that it will not be automatically saved.

```
Save:get(key: string, default: [string, number, boolean]) -> [string, number, boolean, nil]
```
Retrieves value associated with provided `key` from save data. If key is not found, `nil` or optional `default` value is
returned.

```
Save:put(key: string, value: [string, number, boolean]) -> nil
```
Adds provided `key`-`value` pair to save data. **Note that this function doesn't actually write anything to disk.**

```
Save:put_if_nil(key: string, value: [string, number, boolean]) -> boolean
```
Adds provided `key`-`value` pair to save data only if there is no value stored for provided `key`. **Note that this function
doesn't actually write anything to disk.**

```
Save:remove(key: string) -> boolean
```
Removes value associated with provided `key` from save data. **Note that this function doesn't actually write anything to
disk.**

```
Save:contains(key: string) -> boolean
```
Returns whether provided `key` can be found within save data.

```
Save:commit() -> nil
```
Creates a new save file on a disk and saves all currently stored key-value pairs. **Note that this will destroy any
previously created save files.**
