module player;

import parin;
import data.constants;

import player.booster;
import managers.texture;
 
/// Els State -> Player State
enum ElsState : ubyte {
    normal = 0x0,
    hurt = 0x1,
    dead = 0x2,
    invincible,
}

struct ElsControls
{
    @disable this();
    static:

    bool leftKey() { return isDown(ETFKeys.pLeft) || isDown(Keyboard.a); }
    bool rightKey() { return isDown(ETFKeys.pRight) || isDown(Keyboard.d); }
    bool boostKey() { return isDown(ETFKeys.pBoost) || isDown(Keyboard.j); }
    bool downBoostKey() { return isDown(ETFKeys.pBoostDown) || isDown(Keyboard.k); }
}

/// Gravity, acceleration, etc.
struct ElsPhysics {
     @disable this();
     static enum gravity = 420.0f;
     static enum acceleration = 400.0f;
}

/// Els Speed
struct ElsSpeed {
    @disable this();
    static enum maximum = 380.5f;
    static enum neutral = 300.0f;
}

/// Max health, Magma Booster Required Fuel
struct ElsNumbers {
    @disable this();
    /// Initial (and maximum) health
    static enum maxHealth = 80;
    /// The fuel that is subtracted from the Magma Booster when propelled
    static enum boosterFuel = 0.05f;
    /// Fuel subtracted when propelled downward
    static enum boosterFuelDownward = 0.10f;
    /// Player's Magma booster boosting force
    static enum boosterImpulseForce = 280.0f;
}

/// Hitbox size and offset
struct ElsHitbox {
    @disable this();
    static immutable Vec2 size = Vec2(90, 228);
    static immutable Vec2 offset = Vec2(
        ETFApplication.resolution.x - size.x,
        ETFApplication.resolution.y - size.y,
    );
}

struct Player {
    ubyte previousHealthPoints, healthPoints;

    ElsState state;
    float direction; // Lateral movement

    Vec2 offset, position, velocity;
    SpriteAnimation[3] animations;
    Timer hurtTimer;

    Rect hitbox;
    TextureId texture;
    Sprite sprite;

    WaterBooster booster;

    void start() {
        previousHealthPoints = ElsNumbers.maxHealth;
        healthPoints = previousHealthPoints;
        direction = 0.0f;

        texture = TextureManager.getInstance().get("ElsAtlas");
        state = ElsState.normal;

        offset = ETFSprite.getOffset(ElsHitbox.size);
        velocity = Vec2.zero;
        position = Vec2(
            ETFApplication.resolution.x / 2.0f - ETFSprite.size / 2.0f,
            ETFApplication.resolution.y / 2.0f - ETFSprite.size / 2.0f
        );
        
        sprite = Sprite(ETFSprite.size, ETFSprite.size, 0, 0);
        sprite.position = position;

        hitbox = Rect(position, ElsHitbox.size);
        hurtTimer = Timer(0.6f);

        animations[ElsState.normal] = SpriteAnimation(0, 4, 6);
        animations[ElsState.hurt] = SpriteAnimation(1, 4, 8);
        animations[ElsState.dead] = SpriteAnimation(2, 2, 2);

        booster = WaterBooster(ElsNumbers.boosterImpulseForce);
    }

    void update(float dt) {
        updateSprite(dt);

        // Update states
        final switch (state) {
            case ElsState.normal:
            case ElsState.invincible:
                updateNormalState(dt); break;
            case ElsState.hurt: updateHurtState(dt); break;
            case ElsState.dead: break;
        }

        if (state != ElsState.hurt) updateAcceleration(dt);
        updateGravity(dt);
        updatePosition(dt);
        clampPosition();
    }

    void draw() const {
        // It is drawn when it is on screen only
        if (position.y < ETFApplication.resolution.y)
            drawSprite(texture, sprite);
    }

    // ----------------------------------

    // The impact will be minimal but still
    pragma(inline, true) byte inputAxis() const {
        return ElsControls.rightKey() - ElsControls.leftKey();
    }

    void updateAcceleration(float dt) {
        if (direction != 0) {
            velocity.x = moveTo(velocity.x, direction, ElsPhysics.acceleration * dt);
            velocity.x = clamp(velocity.x, -ElsSpeed.maximum, ElsSpeed.maximum);
        }
        else
            velocity.x = moveTo(velocity.x, 0.0f, dt);
    }

    void updateSprite(float dt) {
        sprite.update(dt);
        sprite.play(animations[state]);
    }

    void updateGravity(float dt) {
        velocity.y += ElsPhysics.gravity * dt;
    }

    void updatePosition(float dt) {
        position.x += (velocity.x * ElsSpeed.neutral) * dt;
        position.y += velocity.y * dt;
        
        sprite.position = position;
        hitbox.position = position + offset;
    }

    void clampPosition() {
        position.x = clamp(position.x, -ElsHitbox.size.x, ElsHitbox.offset.x);
        position.y = clamp(position.y, 0, ETFApplication.resolution.y);
    }

    void updateInput() {
        if (ElsControls.boostKey()) {
            booster.subtractFuel(ElsNumbers.boosterFuel);
            velocity.y = booster.getImpulse();
        }

        if (ElsControls.downBoostKey()) {
            booster.subtractFuel(ElsNumbers.boosterFuelDownward);
            velocity.y = abs(booster.getImpulse());
        }
    }

    // States

    void updateNormalState(float dt) {
        direction = inputAxis();

        if (booster.hasFuel()) {
            updateInput();
        }
    }

    void startHurtState() {
        if (state == ElsState.dead || state == ElsState.invincible) return;

        direction = 0;
        velocity.y = booster.getImpulse();
        hurtTimer.start();
        state = ElsState.hurt;
    }

    void updateHurtState(float dt) {
        hurtTimer.update(dt);

        if (hurtTimer.hasStopped()) {
            state = healthPoints > 0 ? ElsState.normal : ElsState.dead;
            hurtTimer.time = 0.0f;
        }
    }

    void applyInvicibility() {
        if (state != ElsState.invincible)
            state = ElsState.invincible;
    }

    // ----------------

    void takeDamage(ubyte amount) {
        if (state != ElsState.normal || !isAlive())
            return;
        
        if (amount == 0) return;

        ubyte damage = amount > ElsNumbers.maxHealth ? ElsNumbers.maxHealth : amount;
        healthPoints = (healthPoints > damage) ? cast(ubyte)(healthPoints - damage) : 0u;
    }

    void addHealth(ubyte amount) {
        if (!isAlive()) return;
        healthPoints += clamp(amount, 1, ElsNumbers.maxHealth);
        if (healthPoints > ElsNumbers.maxHealth) healthPoints = ElsNumbers.maxHealth;
    }

    bool isAlive() const {
        return healthPoints > 0;
    }

    bool isHurt() const {
        return state == ElsState.hurt;
    }

    // ------------------------

    void setVelocityX(float x) {
        this.velocity.x = x;
    }

    void setVelocityY(float y) {
        this.velocity.y = y;
    }

    ubyte getHealth() const {
        return healthPoints;
    }

    ref WaterBooster getBooster() {
        return booster;
    }
}