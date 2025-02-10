import game;
import parin;
import std.conv : to;
import data.score;
import data.constants : ETFApplication;
import data.attempts;

// Ok?
Game etfMbGame = {};
DrawOptions debugTextOptions;
Color bgColor = Color(13, 13, 13);

void ready() {
    // Testing window icon
    setWindowIconFromFiles("icon.png");
    lockResolution(ETFApplication.resolution.x, ETFApplication.resolution.y);
    setBackgroundColor(bgColor);

    AttemptsData.load();
    ScoreData.load();

    debugTextOptions.scale = Vec2(2.0f);

    etfMbGame.start();
    printfln("Best score: {}", ScoreData.bestScore);
    printfln("Deaths: {}\nSurrenders: {}", AttemptsData.deaths, AttemptsData.surrenders);
}

bool update(float dt) {
    if (etfMbGame.update(dt)) return true;
    etfMbGame.draw();

    debug drawDebugText(format("{} fps.", fps()), Vec2.zero, debugTextOptions);
    return false;
}

void finish() {
    etfMbGame.free();
}

mixin runGame!(ready, update, finish, 800, 600, ETFApplication.title);