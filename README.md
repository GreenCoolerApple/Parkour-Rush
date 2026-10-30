# Parkour Rush

A parkour (obby) game for Roblox, written in Luau and synced with [Rojo](https://rojo.space).

## Features

- Numbered checkpoints with stage leaderboard
- Progress saved with DataStore
- Kill parts via the `KillPart` tag
- Stage HUD
- Starter course included in the project file

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

## Adding stages

Add parts named `4`, `5`, `6`... inside `Workspace.Checkpoints`. Players can only advance one stage at a time.

## License

MIT
