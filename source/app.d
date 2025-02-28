import game;
import parin;
import std.conv : to;
import data.user;
import data.constants : ETFApplication;
import data.attempts;

Game etfWbGame = {};
DrawOptions debugTextOptions;

enum Color bgColor = Color(13, 13, 13);
enum IVec2 windowResolution = IVec2(800, 600);
enum IVec2 minWindowResolution = IVec2(320, 240);

void ready() {
    // Testing window icon
    setWindowMinSize(minWindowResolution.x, minWindowResolution.y);
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

mixin runGame!(ready, update, finish, windowResolution.x, windowResolution.y, ETFApplication.title);