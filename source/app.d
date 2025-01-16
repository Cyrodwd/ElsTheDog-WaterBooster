import game;
import parin;
import constants : ETFApplication;

// Ok?
Game etfMbGame = {};

void ready() {
    lockResolution(ETFApplication.width, ETFApplication.height);
    setBackgroundColor(black);
    etfMbGame.start();
}

bool update(float dt) {
    if (etfMbGame.update(dt)) return true;
    etfMbGame.draw();
    return false;
}

void finish() {
    etfMbGame.free();
}

mixin runGame!(ready, update, finish, ETFApplication.width, ETFApplication.height, ETFApplication.title);