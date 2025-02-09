module sentity.anomaly;

import parin;
import player;

import sentity;
import sentity.data;
import data.constants : ETFSprite;

struct AnomalyConfig {
    ubyte damageAmount;
    ubyte frameCount;
    float respawnDelay;
    Color color = white;
}

final class Anomaly : SkyEntity
{
    private ubyte damageAmount;
    private DrawOptions drawOptions;
    private SpriteAnimation[2] animations;

    Timer respawnTimer;
    private Sprite sprite;

    public this(SEConfig baseConfig, AnomalyConfig config) {
        super(baseConfig);

        respawnTimer = Timer(config.respawnDelay);
        this.damageAmount = config.damageAmount;
        drawOptions.color = config.color;
        
        // Sprites configuration
        animations[SEState.enabled] = SpriteAnimation(0, config.frameCount, 6);
        animations[SEState.collide] = SpriteAnimation(1, config.frameCount, 12);

        sprite = Sprite(ETFSprite.size, ETFSprite.size, 0, 0);
        reset();
    }

    public override void update(float dt) {
        super.update(dt);

        sprite.update(dt);
        if (state != SEState.respawn) sprite.play(animations[state]);
    }

    public override void updateCollision(ref Player pl) {
        if (hasCollisionWithPlayer(pl)) {
            const float pushDirection = ( hasCollide(pl.hitbox.leftArea()) ) ?
                -1.0f : 1.0f;

            sprite.reset();
            pl.takeDamage(damageAmount);
            pl.setVelocityX(pushDirection);
            pl.startHurtState();
            state = SEState.collide;
        }
    }

    private bool hasCollisionWithPlayer(Player pl) {
        return state == SEState.enabled && hasCollide(pl.hitbox);
    }

    public override void draw() {
        if (state != SEState.respawn)
            texture.isValid() ? drawSprite(texture, sprite, drawOptions) : drawRect(hitbox, drawOptions.color);
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