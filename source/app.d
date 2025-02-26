import game;
import parin;
import std.conv : to;
import data.user;
import data.constants : ETFApplication;
import data.attempts;

// Ok?
Game etfWbGame = {};
DrawOptions debugTextOptions;
Color bgColor = Color(13, 13, 13);

void ready() {
    // Testing window icon
    setWindowMinSize(320, 240);
    setWindowIconFromFiles("icon.png");
    lockResolution(ETFApplication.resolution.x, ETFApplication.resolution.y);
    setBackgroundColor(bgColor);

    AttemptsData.load();
    UserData.load();

    debugTextOptions.scale = Vec2(2.0f);

    etfWbGame.start();
}

bool update(float dt) {
    if (etfWbGame.update(dt)) return true;
    etfWbGame.draw();

    debug drawDebugText(format("{} fps.", fps()), Vec2.zero, debugTextOptions);
    return false;
}

void finish() {
    etfWbGame.free();
}

mixin runGame!(ready, update, finish, 800, 600, ETFApplication.title);