#!/bin/bash

# I didn't know if Kapendev would agree with changing “loadSound”, so I better make a game-specific modification.
# Literally “loadSound” has only one boolean field “loop” lmao.

# Clone submodule
git clone https://github.com/Cyrodwd/parin cparin

# Init and update submodule
git submodule update --init --recursive cparin
