module player.booster;

import joka.math : clamp;

struct WBoosterConst {
    @disable this();
    static immutable float maxFuel = 60.0f;
    static immutable float startingFuel = 50.0f;
}

struct WaterBooster {
    float fuel;
    float impulseForce;

    /// Set an impulse force
    this(float force) {
        this.impulseForce = -force;
        fuel = WBoosterConst.startingFuel;
    }

    void addWater(float value) {
        fuel += clamp(value, 0.0f, WBoosterConst.maxFuel);
        if (fuel > WBoosterConst.maxFuel) fuel = WBoosterConst.maxFuel;
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