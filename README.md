# Parkour Rush

A parkour (obby) game for Roblox, written in Luau and synced with [Rojo](https://rojo.space).

## Features

- Numbered checkpoints with stage leaderboard
- Progress saved with DataStore
- Kill parts via the `KillPart` tag
- 4 themed levels generated from code: Rooftops, Sky Islands, Lava Factory and Neon Void
- Platform types: jumps, beams, trusses, conveyors, fading, bounce pads, moving platforms and spinners
- Themed scenery and lighting for each level
- HUD with level name and progress

## Setup

1. Install [Rokit](https://github.com/rojo-rbx/rokit) and run `rokit install`
2. Install the Rojo plugin in Roblox Studio
3. Run `rojo serve` and connect from the plugin
4. To build a place file: `rojo build -o ParkourRush.rbxl`

Enable **Studio Access to API Services** in Game Settings to test saving in Studio.

## Structure

```
src/
├── client/       StarterPlayerScripts.Client
├── server/       ServerScriptService.Server
└── shared/       ReplicatedStorage.Shared
```

## Editing levels

Levels live in `src/shared/Levels.luau`. Each level has a theme and a list of stages, and each stage is a list of segments:

| Type | Fields |
| --- | --- |
| `Jumps` | `Count`, `Gap`, `Rise`, `Zigzag`, `Size` |
| `Narrow` | `Length`, `Gap` |
| `Truss` | `Height` (even number) |
| `Conveyor` | `Length`, `Speed` |
| `Fade` | `Count`, `Gap` |
| `Bounce` | `Height`, `Power` |
| `Moving` | `Count`, `Range`, `Speed` |
| `Spinner` | `Speed` |

A checkpoint is added automatically at the end of every stage. The course is built when the server starts.

## License

MIT
