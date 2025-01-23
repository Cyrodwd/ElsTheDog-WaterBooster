import game;
import parin;
import std.conv : to;
import constants : ETFApplication;

// Ok?
Game etfMbGame = {};

void ready() {
    // Testing window icon
    setWindowIconFromFiles("icon.png");
    lockResolution(ETFApplication.resolution.x, ETFApplication.resolution.y);
    setBackgroundColor(black);

    etfMbGame.start();
}

bool update(float dt) {
    if (etfMbGame.update(dt)) return true;
    etfMbGame.draw();

    debug drawDebugText(format("{} fps.", fps()), Vec2.zero);
    return false;
}

void finish() {
    etfMbGame.free();
}

mixin runGame!(ready, update, finish, 800, 600, ETFApplication.title);