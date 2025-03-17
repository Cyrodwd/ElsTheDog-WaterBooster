# Els The Dog: Water Booster.

Avoid the sky anomalies and keep flying. Use the advantage flasks to gain advantages (obviously) on your journey, and keep and get the water in your booster so you don't fall.

## Controls

### Gameplay
- Arrow keys (Left & Right): Side movement
- Z key: Boost
- X key: Down boost

### Menus
- Space key: Confirm
- Esc key: Deny

## Features
- Health
- Water booster
- Score system
- Advantage Flasks with callbacks and their own rarity
- Dynamic and static anomalies (Thunders, fire tears, etc.)
- Minimalistic menus
- Music (from Cave Story)
- A "prize" on winning.

## Missing
- Background for Water Booster Rejected.
- Sounds.

This game was created with [Parin](https://github.com/Kapendev/parin).

## Compilation

First you have to clone the fork of parin (from me), inside the include/cparin directory (assuming you are in the root of the project).
```sh
git clone https://github.com/Cyrodwd/parin include/cparin
```

Run this command in your terminal/cmd (Parin installed via dub).
```sh
dub run parin:setup
```

Now, run this other command to build it.
```sh
dub build --build=release --compiler=ldc2 # Any compiler
```

# The music used in the video game is not original. It is from Cave Story, made by Pixel (afaik).
