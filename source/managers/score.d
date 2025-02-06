module managers.score;

import parin;

private
{
    enum pointsDefaultAmount = 1000;
    enum maxPoints = 10_000;
}

struct ScoreManager
{
    ushort points;
    ubyte multiplier;
    Timer timer;

    @safe @nogc nothrow:

    this(float time) {
        points = 0;

        timer = Timer(time, true);
        timer.start();
    }

    /// Adds 20 points by default
    void update(float dt) {
        timer.update(dt);
        if (timer.hasStopped() && !hasMaxPoints()) points += pointsDefaultAmount;
    }

    void add(ubyte newPoints) {
        if (!hasMaxPoints())
            points += clamp(newPoints, 1, 100);
        if (points > maxPoints) points = maxPoints;
    }

    void restart() {
        points = 0;
        timer.start();
    }

    void stop() {
        timer.stop();
    }

    bool hasMaxPoints() const {
        return points >= maxPoints;
    }
}