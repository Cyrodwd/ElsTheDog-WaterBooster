module sentity.data;

import joka : IStr;

/// SEDirection -> Sky Entity Direction
enum SEDirection : ubyte {
    none = 0x0,
    horizontal,
    vertical,
}

/// SEState -> Sky Entity State
enum SEState : ubyte {
    enabled = 0x0,
    collide = 0x1,
    respawn = 0x2,
}

/// SEConfig -> Sky Entity Configuration (Standard)
struct SEConfig {
    SEDirection direction;
    float speed;
    IStr name;
}