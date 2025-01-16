module player;

import parin;
import constants;

import managers.texture;
import player.magmabooster;
 
/// Els State -> Player State
enum ElsState : ubyte {
    normal = 0x0,
    hurt = 0x1,
    dead = 0x2,
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
    static enum boosterFuelDownward = 0.15f;
    /// Player's Magma booster boosting force
    static enum boosterImpulseForce = 280.0f;
}

/// Hitbox size and offset
struct ElsHitbox {
    @disable this();
    static immutable Vec2 size = Vec2(90, 228);
    static immutable Vec2 offset = Vec2(
        ETFApplication.width - size.x,
        ETFApplication.height - size.y,
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

    MagmaBooster booster;

    void start() {
        previousHealthPoints = ElsNumbers.maxHealth;
        healthPoints = previousHealthPoints;
        direction = 0.0f;

        texture = TextureManager.getInstance().get("ElsAtlas");
        state = ElsState.normal;

        offset = ETFSprite.getOffset(ElsHitbox.size);
        velocity = Vec2.zero;
        position = Vec2.zero;
        
        sprite = Sprite(ETFSprite.size, ETFSprite.size, 0, 0);
        hitbox = Rect(position, ElsHitbox.size);
        hurtTimer = Timer(0.6f);

        animations[ElsState.normal] = SpriteAnimation(0, 4, 6);
        animations[ElsState.hurt] = SpriteAnimation(1, 4, 8);
        animations[ElsState.dead] = SpriteAnimation(2, 2, 2);

        booster = MagmaBooster(ElsNumbers.boosterImpulseForce);
    }

    void update(float dt) {
        sprite.update(dt);
        sprite.play(animations[state]);

        // Update states
        final switch (state) {
            case ElsState.normal: updateNormalState(dt); break;
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
        if (position.y < ETFApplication.height)
            drawSprite(texture, sprite);
    }

    // ----------------------------------

    byte inputAxis() const {
        return isDown(Keyboard.right) - isDown(Keyboard.left);
    }

    void updateAcceleration(float dt) {
        if (direction != 0) {
            velocity.x = moveTo(velocity.x, direction, ElsPhysics.acceleration * dt);
            velocity.x = clamp(velocity.x, -ElsSpeed.maximum, ElsSpeed.maximum);
        }
        else
            velocity.x = moveTo(velocity.x, 0.0f, dt);
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
        position.y = clamp(position.y, 0, ETFApplication.height);
    }

    void updateInput() {
        if (isDown(Keyboard.z)) {
            booster.subtractFuel(ElsNumbers.boosterFuel);
            velocity.y = booster.getImpulse();
        }

        if (isPressed(Keyboard.x)) {
            booster.subtractFuel(0.15f);
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
        if (state == ElsState.dead) return;

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

    // ----------------

    void takeDamage(ubyte amount) {
        if (state != ElsState.normal || healthPoints == 0)
            return;
        
        if (amount == 0) return;

        ubyte damage = amount > ElsNumbers.maxHealth ? ElsNumbers.maxHealth : amount;
        healthPoints = (healthPoints > damage) ? cast(ubyte)(healthPoints - damage) : 0u;
    }

    void addHealth(ubyte amount) {
        if (state == ElsState.dead) return;
        healthPoints += clamp(amount, 1, ElsNumbers.maxHealth);
        if (healthPoints > ElsNumbers.maxHealth) healthPoints = ElsNumbers.maxHealth;
    }

    bool isAlive() const {
        return healthPoints > 0;
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

    ref MagmaBooster getBooster() {
        return booster;
    }
}