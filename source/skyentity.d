module skyentity;

import parin;
import globals;
import player;
import managers.texture;

/// SEDirection -> Sky Entity Direction
enum SEDirection : ubyte {
    none = 0x0,
    horizontal,
    vertical,
}

/// SEState -> Sky Entity State
enum SEState : ubyte {
    enabled = 0x0,
    collide = 0x1,
    respawn = 0x2,
}

/// SEConfig -> Sky Entity Configuration (Standard)
struct SEConfig {
    SEDirection direction;
    float speed;
}

// ---------------------------------
// SkyEntities types (Anomaly and Advantage Flask)
// ---------------------------------

abstract class SkyEntity {
    private immutable Vec2 maxPosition = Vec2(
        ETFResolution.width - spriteSize,
        ETFResolution.height - spriteSize,
    );
    private immutable Vec2 hitboxDefaultSize = Vec2(128);

    protected SEState state;
    protected SEDirection direction;
    protected float speed;

    protected Vec2 offset, velocity, position;

    protected Rect hitbox;
    protected TextureId texture;

    public this (SEConfig config, IStr name) {
        direction = config.direction;
        speed = config.speed;

        state = SEState.respawn;
        hitbox = Rect(Vec2.zero, hitboxDefaultSize);

        offset = getSpriteHitboxOffset(hitbox.size);
        velocity = Vec2.zero;

        texture = TextureManager.getInstance().get(name);
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
        if (position.x < -spriteSize || position.y > ETFResolution.height) reset(); 
    }

    public final bool hasCollide(Rect other) {
        return hitbox.hasIntersection(other);
    }

    public void enable() {
        state = SEState.enabled;
        velocity.x = position.x >= ETFResolution.width ? -1 : 0;
        velocity.y = position.y < 0; // bool returns 1 or 0
    }

    public void reset() {
        state = SEState.respawn;
        velocity = Vec2.zero;
        position = setSpawnByDirection(direction);
    }

    protected final Vec2 setSpawnByDirection(const SEDirection direction) {
        Vec2 spawn = Vec2.zero;
        
        switch (direction) {
            case SEDirection.horizontal:
                spawn = Vec2(
                    ETFResolution.width,
                    randi() % maxPosition.y
                );
                break;
            case SEDirection.vertical:
                spawn = Vec2(
                    randi() % maxPosition.x,
                    -spriteSize
                );
                break;
            default:
            case SEDirection.none:
                /* Do nothing */
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

/* TODO: Create a separate module for Anomaly and AdvantageFlask class */

final class Anomaly : SkyEntity
{
    private ubyte damageAmount;
    private SpriteAnimation[2] animations;

    Timer respawnTimer;
    private Sprite sprite;

    public this(SEConfig baseConfig, IStr name, ubyte damageAmount, float respawnDelay) {
        super(baseConfig, name);

        respawnTimer = Timer(respawnDelay);
        this.damageAmount = damageAmount;
        
        // Sprites configuration
        animations[SEState.enabled] = SpriteAnimation(0, 4, 6);
        animations[SEState.collide] = SpriteAnimation(1, 4, 12);

        sprite = Sprite(spriteSize, spriteSize, 0, 0);
        reset();
    }

    public override void update(float dt) {
        super.update(dt);

        sprite.update(dt);
        if (state != SEState.respawn) sprite.play(animations[state]);
    }

    public override void updateCollision(ref Player pl) {
        if (state == SEState.enabled && hasCollide(pl.hitbox)) {
            const float pushDirection = ( hasCollide(pl.hitbox.leftArea()) ) ?
                -1.0f : 1.0f;

            sprite.reset();
            pl.takeDamage(damageAmount);
            pl.setVelocityX(pushDirection);
            pl.startHurtState();
            state = SEState.collide;
        }
    }

    public override void draw() {
        if (state != SEState.respawn)
            texture.isValid() ? drawSprite(texture, sprite) : drawRect(hitbox, red);
    }

    public override void reset() {
        super.reset();
        respawnTimer.start();
    }

    public override void updatePosition(float dt) {
        super.updatePosition(dt);
        sprite.position = position;
    }

    public override void updateEnabledState(float dt) {
        position += ( velocity * Vec2(speed) ) * Vec2(dt);
        checkPosLimits();
    }

    public override void updateCollideState(float dt) {
        if (sprite.hasLastFrame()) reset();
    }

    public override void updateRespawnState(float dt) {
        respawnTimer.update(dt);

        if (respawnTimer.hasStopped())
            enable();
    }
}

alias AFlaskEffect = void delegate();

final class AdvantageFlask : SkyEntity
{
    private static IStr atlasName = "FlaskAtlas";
    private static ubyte framesCount = 8;

    private ubyte rarityRate;
    private DrawOptions drawOptions; 

    private AFlaskEffect effect;
    private Timer respawnTimer;

    private SpriteAnimation[2] animations;
    private Sprite sprite;

    public this(SEConfig baseConfig, float respawnTime, ubyte rarityRate, Color color, AFlaskEffect effect) {
        super(baseConfig, atlasName);

        animations[SEState.enabled] = SpriteAnimation(0, framesCount, 8);
        animations[SEState.collide] = SpriteAnimation(1, framesCount, 12);

        sprite = Sprite(spriteSize, spriteSize, 0, 0);
        this.effect = effect;
        
        // Still works
        drawOptions.scale = Vec2(0.8f);
        drawOptions.color = color;

        this.rarityRate = cast (ubyte) clamp(rarityRate, 0, 100);

        respawnTimer = Timer(respawnTime);
        reset();
    }

    public override void update(float dt) {
        super.update(dt);

        sprite.update(dt);

        if (state != SEState.respawn) {
            sprite.play(animations[state]);
            position += ( velocity * Vec2(speed) ) * Vec2(dt);
        }
    }

    public override void draw() {
        if (state != SEState.respawn)
            drawSprite(texture, sprite, drawOptions);
    }

    public override void reset() {
        super.reset();
        respawnTimer.start();
    }

    public override void updateCollision(ref Player pl) {
        if (state == SEState.enabled && hasCollide(pl.hitbox)) {
            if (effect is null) assert(0, "Effect is null");
            /* Applying the effect */
            effect();
            sprite.reset();
            state = SEState.collide;
        }
    }

    public override void updatePosition(float dt) {
        super.updatePosition(dt);
        sprite.position = position;
    }

    public override void updateEnabledState(float dt) {
        checkPosLimits();
    }

    public override void updateCollideState(float dt) {
        if (sprite.hasLastFrame()) {
            reset();
        }
    }

    public override void updateRespawnState(float dt) {
        respawnTimer.update(dt);

        if (respawnTimer.hasStopped()) {
            immutable ubyte number = cast (ubyte) randi() % 100 + 1; // 0-100
            if (number <= rarityRate) enable();
            else reset();
        }
    }
}
