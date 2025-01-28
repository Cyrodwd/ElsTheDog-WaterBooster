module sentity.aflask;

import parin;
import player;

import sentity.data;
import sentity.skyentity;
import constants : ETFSprite;

// Advantage Flask Effect alias. It is more auto-explicative
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

    private IStr name;

    public this(SEConfig baseConfig, float respawnTime, ubyte rarityRate, Color color, AFlaskEffect effect) {
        const SEConfig cfg = SEConfig(baseConfig.direction, baseConfig.speed, atlasName);
        super(cfg);

        animations[SEState.enabled] = SpriteAnimation(0, framesCount, 8);
        animations[SEState.collide] = SpriteAnimation(1, framesCount, 12);

        sprite = Sprite(ETFSprite.size, ETFSprite.size, 0, 0);
        this.effect = effect;
        
        // Still works
        drawOptions.scale = Vec2(0.8f);
        drawOptions.color = color;

        this.rarityRate = cast (ubyte) clamp(rarityRate, 0, 100);
        name = baseConfig.name;

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
        if (hasCollisionWithPlayer(pl)) {
            if (effect is null) assert(0, "Effect is null");
            /* Applying the effect */
            effect();
            sprite.reset();
            state = SEState.collide;
        }
    }

    private bool hasCollisionWithPlayer(Player pl) {
        return state == SEState.enabled && hasCollide(pl.hitbox);
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

    public IStr getName() const {
        return name;
    }

    public Color getColor() const {
        return drawOptions.color;
    }
    
    public SEState getState() const {
        return state;
    }
}
