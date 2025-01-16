module sentity.skyentity;

import parin;
import sentity.data;
import managers.texture;

import player;
import constants : ETFApplication, ETFSprite;

abstract class SkyEntity {
    private immutable Vec2 maxPosition = Vec2(
        ETFApplication.width - ETFSprite.size,
        ETFApplication.height - ETFSprite.size,
    );

    private immutable Vec2 hitboxDefaultSize = Vec2(128);

    /* Protected and public attributes/methods */

    protected SEState state;
    protected SEDirection direction;
    protected float speed;

    protected Vec2 offset, velocity, position;

    protected Rect hitbox;
    protected TextureId texture;

    public this (SEConfig config) {
        direction = config.direction;
        speed = config.speed;

        state = SEState.respawn;
        hitbox = Rect(Vec2.zero, hitboxDefaultSize);

        velocity = Vec2.zero;
        offset = ETFSprite.getOffset(hitbox.size);

        texture = TextureManager.getInstance().get(config.name);
    }

    public void update(float dt) {
        updatePosition(dt);

        final switch (state) {
            case SEState.enabled: updateEnabledState(dt); break;
            case SEState.collide: updateCollideState(dt); break;
            case SEState.respawn: updateRespawnState(dt); break;
        }
    }

    public void updatePosition(float dt) {
        hitbox.position = position + offset;
    }

    public final void checkPosLimits() {
        if (position.x < -ETFSprite.size || position.y > ETFApplication.height) reset(); 
    }

    public final bool hasCollide(Rect other) {
        return hitbox.hasIntersection(other);
    }

    public void enable() {
        state = SEState.enabled;
        velocity.x = position.x >= ETFApplication.width ? -1 : 0;
        velocity.y = position.y < 0; // bool returns 1 or 0
    }

    public void reset() {
        state = SEState.respawn;
        velocity = Vec2.zero;
        position = setSpawnByDirection(direction);
    }

    protected final Vec2 setSpawnByDirection(const SEDirection direction) {
        Vec2 spawn = Vec2.zero;
        
        final switch (direction) {
            case SEDirection.horizontal:
                spawn = Vec2(ETFApplication.width, randi() % maxPosition.y);
                break;

            case SEDirection.vertical:
                spawn = Vec2(randi() % maxPosition.x, -ETFSprite.size);
                break;

            case SEDirection.none:
                // Nothing
                break;
        }
        
        return spawn;
    }

    public abstract void draw();
    public abstract void updateEnabledState(float dt);
    public abstract void updateCollideState(float dt);
    public abstract void updateRespawnState(float dt);
    public abstract void updateCollision(ref Player pl);
}


