module data.play.misc;

import parin;

struct PlayTimer {
    @disable this();

    static:

    private Timer timer = Timer(3.0f);

    void start() {
        timer.start(3.0f);
    }

    void update(float dt) {
        timer.update(dt);
    }

    bool done() {
        return timer.hasStopped();
    }

    ubyte count() {
        return cast (ubyte) (timer.duration - timer.time + 1U);
    }
}

enum PlayState : ubyte {
    Ready = 0,
    Active,
    Pause,
    GameOver,
    Victory,
}