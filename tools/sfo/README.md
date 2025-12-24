<h1 align="center">zSFOTool</h1>
<p align="center">A cross-platform multi-tool for reading and writing PSP SFO files.</p>

## Why zSFOTool?
This tool is meant to ship with the [Zig-PSP Toolchain](https://github.com/zPSP-Dev/Zig-PSP).

zSFOTool replaces PSPSDK's `mksfo` tool. In addition to this - it also can be used to read an SFO and display technical data!

## Usage
zSFOTool is used internally by Zig-PSP's build process to create an SFO. It also can be used standalone.

To use it standalone, you can use `sfotool read` and `sfotool write`.

To use write, you'll want to supply it: `sfotool write TITLE <output.SFO>`

To use read, you'll need to supply: `sfotool read <input.SFO>`

To use the JSON layout, you'll need to supply: `sfotool parse <input.json> <output.SFO>`
The JSON file must have a title, and properties. Every property has a key and a val.
```json
{
    "title": "Hello World",
    "properties": [
        {
            "key": "PARENTAL_LEVEL",
            "val": 0
        },
        {
            "key": "TITLE_0",
            "val": "MyTitle"
        }
    ]
}
```
The parser also will stop you from entering invalid properties!
