module player.magmabooster;

import joka.math : clamp;

struct MagmaBoosterConst {
    @disable this();
    static immutable float maxFuel = 60.0f;
    static immutable float startingFuel = 50.0f;
}

struct MagmaBooster {
    float impulseForce;
    float fuel;

    /// Set an impulse force
    this(float force) {
        this.impulseForce = -force;
        fuel = MagmaBoosterConst.startingFuel;
    }

    void addFuel(float value) {
        fuel += clamp(value, 0.0f, MagmaBoosterConst.maxFuel);
        if (fuel > MagmaBoosterConst.maxFuel) fuel = MagmaBoosterConst.maxFuel;
    }

    float getFuel() {
        return fuel;
    }

    float getImpulse() const {
        return impulseForce;
    }

    bool hasFuel() const {
        return fuel > 0.0f;
    }

    void subtractFuel(float value) {
        fuel -= value;
        if (fuel <= 0.0f) fuel = 0.0f;
    }
}