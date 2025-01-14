import game;
import parin;
import constants : ETFResolution;

// Ok?
Game etfMbGame = {};

void ready() {
    lockResolution(ETFResolution.width, ETFResolution.height);
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

mixin runGame!(ready, update, finish, ETFResolution.width, ETFResolution.height);