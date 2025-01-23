module sentity.anomaly;

import parin;
import player;

import sentity.data;
import sentity.skyentity;
import constants : ETFSprite;

final class Anomaly : SkyEntity
{
    private ubyte damageAmount;
    private SpriteAnimation[2] animations;

    Timer respawnTimer;
    private Sprite sprite;

    public this(SEConfig baseConfig, ubyte damageAmount, float respawnDelay) {
        super(baseConfig);

        respawnTimer = Timer(respawnDelay);
        this.damageAmount = damageAmount;
        
        // Sprites configuration
        animations[SEState.enabled] = SpriteAnimation(0, 4, 6);
        animations[SEState.collide] = SpriteAnimation(1, 4, 12);

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