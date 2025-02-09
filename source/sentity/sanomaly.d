module sentity.sanomaly;

import parin;
import player;
import sentity.data;
import managers.texture;
import data.constants : ETFApplication, ETFSprite;

enum SAState : ubyte {
    enabled = 0,
    respawn,
    waiting,
}

struct SAConfig {
    SEDirection direction;
    Color color;
}

struct SANumbers {
    ubyte rarity;
    ubyte damage;
    float size;
}

struct SATimes {
    float spawn;
    float active;
    float wait;
}

/// Unlike standard anomalies, these one are just a bar. Like AF, it has a rarity
struct SAnomaly {
    ubyte rarity;
    ubyte damage;
    SEDirection direction;
    SAState state;

    Rect rect;
    Timer spawnTimer;
    Timer activeTimer;
    Timer waitTimer;
    
    DrawOptions drawOptions;
    TextureId warnTexture;

    Vec2 maxPosition;

    this(SAConfig config, SANumbers numbers, SATimes times) {
        direction = config.direction;

        spawnTimer = Timer(times.spawn);
        activeTimer = Timer(times.active);
        waitTimer = Timer(times.wait);

        drawOptions.color = config.color;
        drawOptions.color.a = 180;

        rarity = numbers.rarity;
        damage = numbers.damage;

        const Vec2 rectSize = config.direction == SEDirection.horizontal ?
            Vec2(ETFApplication.resolution.x, numbers.size) : Vec2(numbers.size, ETFApplication.resolution.y);

        rect = Rect(Vec2.zero, rectSize);

        maxPosition = Vec2(
            ETFApplication.resolution.x - rect.size.x,
            ETFApplication.resolution.y - rect.size.y,
        );

        reset();
    }

    void update(float dt) {
        final switch(state) {
            case SAState.respawn: updateRespawn(dt); break;
            case SAState.enabled: updateActive(dt); break;
            case SAState.waiting: updateWaiting(dt); break;
        }
    }

    void updateCollision(ref Player pl) {
        if (state == SAState.enabled && rect.hasIntersection(pl.hitbox)) {
            const float pushDirection = determineDirection(direction, pl, rect);

            pl.takeDamage(damage);
            pl.setVelocityX(pushDirection);
            pl.startHurtState();
        }
    }

    private float determineDirection(SEDirection dir, ref Player pl, Rect rec) {
        if (dir == SEDirection.horizontal && pl.hitbox.hasIntersection(rec.leftArea()))
            return -1.0f;

        if (dir == SEDirection.vertical && pl.hitbox.hasIntersection(rec.topArea()))
            return -1.0f;

        if (pl.hitbox.hasIntersection(rec.centerArea()))
            return 0.0f;

        return 1.0f;
    }

    void draw() const {
        if (state == SAState.enabled)
            drawRect(rect, drawOptions.color);
        else if (state == SAState.respawn)
            drawTexture(TextureManager.getInstance().get("SAWarning"), rect.position);
    }
    
    private void updateActive(float dt) {
        activeTimer.update(dt);

        if (activeTimer.hasStopped())
            reset();
    }

    private void updateRespawn(float dt) {
        spawnTimer.update(dt);

        if (spawnTimer.hasStopped())
            enable();
    }

    private void updateWaiting(float dt) {
        waitTimer.update(dt);

        if (waitTimer.hasStopped()) {
            ubyte number = cast (ubyte) randi() % 101;
            if (number <= rarity) waitToRespawn();
            else waitTimer.start();
        }
    }

    private void reset() {
        waitTimer.start();
        rect.position = setSpawnByDirection(direction);
        state = SAState.waiting;
    }

    private void waitToRespawn() {
        spawnTimer.start();
        state = SAState.respawn;
    }

    private void enable() {
        activeTimer.start();
        state = SAState.enabled;
    }

    private Vec2 setSpawnByDirection(const SEDirection direction) {
        Vec2 spawn = Vec2.zero;
        
        final switch (direction) {
            case SEDirection.horizontal:
                spawn = Vec2(0.0f, randi() % maxPosition.y);
                break;

            case SEDirection.vertical:
                spawn = Vec2(randi() % maxPosition.x, 0.0f);
                break;

            case SEDirection.none:
                // Nothing
                break;
        }
        
        return spawn;
    }
}