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

Then, you can update the submodule
```sh
git submodule update --init --recursive include/cparin
```

> You can use the `install.sh` script, but inside the `include` directory.
> You can also clone the repository with `--recursive`.

Run this command in your terminal/cmd (Parin installed via dub).
```sh
dub run parin:setup
```

Or you can use the local parin setup (somewhat inconvenient, preferably install the official version of parin and use its setup).

```sh
# Go to the 'setup' directory of 'include/cparin'.
cd include/cparin/setup
# Build it
dub build
# Go to the root of the project
cd ../../../
# execute it (POSIX)
./include/cparin/setup/setup
```

Now, run this other command to build it.
```sh
dub build --build=release --compiler=ldc2 # Any compiler
```

# The music used in the video game is not original. It is from Cave Story, made by Pixel (afaik).
