module managers.score;

import parin;

private
{
    enum pointsDefaultAmount = 20;
    enum maxPoints = 10_000;
}

struct ScoreManager
{
    ubyte amount;
    ushort points;
    Timer timer;

    @safe @nogc nothrow:

    this(float time) {
        points = 0;
        amount = pointsDefaultAmount;

        timer = Timer(time, true);
        timer.start();
    }

    /// Adds 20 points by default
    void update(float dt) {
        timer.update(dt);
        if (timer.hasStopped() && !hasMaxPoints()) points += amount;
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

    void setAmount(ubyte amount) {
        this.amount = amount;
    }

    bool hasMaxPoints() const {
        return points >= maxPoints;
    }
}