module scenes.play;

import parin;
import constants;

import player;
import player.magmabooster : MagmaBoosterConst;

import sentity.data;
import sentity.anomaly;
import sentity.advantageflask;

import managers;
import scenes.iscene;
import bg.nightsky;

import std.format : format; // To display score with five digits

private {
    enum offscreenRectSize = Vec2(ETFApplication.resolution.x, 1);
    enum offscreenRectPosition = Vec2(0, ETFApplication.resolution.y - offscreenRectSize.y);

    struct UiBar {
        DrawOptions drawOptions;
        Vec2 position;

        TextureId texture;

        void start() {
            texture = TextureManager.getInstance().get("uiBar");
            position = Vec2(0, ETFApplication.resolution.y - texture.size().y);

            // Slightly transparent
            drawOptions.color = Color(255, 255, 255, 180);
        }

        void draw() const {
            drawTexture(texture, position, drawOptions);
        }
    }
}

enum PlayState : ubyte {
    Ready = 0,
    Active,
    Pause,
    GameOver
}

class PlayScene : IScene
{
    // Constants

    private static enum vOffset = ETFApplication.resolution.y - 85.0f;

    // Attributes/Methods

    private static PlayState state;
    private Player playerEls;
    private ScoreManager scoreManager;

    private Text healthText;
    private Text centerText;
    private Text fuelText;

    private Timer deadTimer; // Time to switch to GameOver Scene
    
    private static struct ScreenLimit {
        @disable this();

        static:
        
        Rect rect;
        ubyte damage;

        void start() {
            rect = Rect(offscreenRectPosition, offscreenRectSize);
            damage = 10;
        }

        void update(ref Player pl) {
            if (rect.hasIntersection(pl.hitbox)) {
                pl.takeDamage(amount: damage);
                pl.startHurtState();
            }
        }
    }

    private void fillBooster() {
        playerEls.getBooster.addFuel(5.0f);
    }

    private Anomaly[3] anomalies; // Test
    private AdvantageFlask healthFlask;

    private SEConfig fireTearConfig;
    private UiBar uiBar;
    
    public static Timer readyTimer = Timer(3.0f);
    private WaveText readyCounter;

    public override void onStart() {
        // Scrolling background have been already started
        fireTearConfig = SEConfig(SEDirection.vertical, 354.2f);
        playerEls.start();

        scoreManager = ScoreManager(1.0f);
        ScreenLimit.start();

        healthFlask = new AdvantageFlask(SEConfig(SEDirection.horizontal, 554.2f, "+FUEL"), 5.3f, 30,
            pink, &fillBooster);
        deadTimer = Timer(3.0f);

        // Testing multiple anomalies
        anomalies = [
            new Anomaly(SEConfig(SEDirection.horizontal, 244.3f, "FireTear"), 15, 2.6f),
            new Anomaly(SEConfig(SEDirection.vertical, 644.2f, "FireTear"), 12, 1.56f),
            new Anomaly(SEConfig(SEDirection.vertical, 965.12f, "FireTear"), 1, 6.2f),
        ];

        // Hard-coded positions lmao
        centerText = Text("-----", Vec2(0, vOffset), white, Alignment.center);
        healthText = Text("Health: -/-", Vec2(45, vOffset), white, Alignment.left);
        fuelText = Text("Fuel: --/--", Vec2(-35, vOffset), white, Alignment.right);

        uiBar.start();

        state = PlayState.Ready;
        readyTimer.start();

        const Vec2 readyCounterPos = Vec2(0, ETFApplication.resolution.y / 2.0f - 40);
        readyCounter = WaveText("-", readyCounterPos, ETFUi.cherryColor, 20.0f, Alignment.center);
    }

    public override void onUpdate(float dt) {
        if (state != PlayState.Pause) BGNightSky.update(dt);
        
        final switch ( state )
        {
            case PlayState.Ready:
            case PlayState.Pause:
                updateReady(dt); break;
            case PlayState.Active:
                updateActive(dt); break;
            case PlayState.GameOver:
                updateGameover(dt); break;
        }
    }

    public override void onDraw() {
        BGNightSky.draw();
        playerEls.draw();

        foreach (Anomaly anomaly ; anomalies) {
            anomaly.draw();
        }

        healthFlask.draw();
        drawUI();

        if (onCounting()) readyCounter.draw();
    }

    private void drawUI() {
        // ui bar
        uiBar.draw();

        centerText.setText(format("%05u", scoreManager.points));
        centerText.draw();

        // The text is red if player is hurt or dead
        const Color hpTextColor = playerEls.state == ElsState.hurt ? pink : white;
        healthText.setColor(hpTextColor);

        healthText.setText(format("Health: %02u/%02d", playerEls.getHealth(), ElsNumbers.maxHealth));
        healthText.draw();

        fuelText.setText(format("Fuel: %.2f/%.0f", playerEls.getBooster().getFuel(), MagmaBoosterConst.maxFuel));
        fuelText.draw();
    }

    // 
    private bool onCounting() {
        return (state == PlayState.Ready || state == PlayState.Pause);
    }

    private void updateReady(float dt) {
        if (state != PlayState.Pause) playerEls.updateSprite(dt);

        readyTimer.update(dt);
        readyCounter.update(dt);
        readyCounter.setText(toStr(cast(int)readyTimer.time + 1));

        if (readyTimer.hasStopped()) {
            state = PlayState.Active;
        }
    }

    private void updateActive(float dt) {
        playerEls.update(dt);

        if (isPressed(Keyboard.esc)) {
            state = PlayState.Pause;
            SceneManager.get().set("PauseScene");
        }

        scoreManager.update(dt);

        foreach (ref Anomaly anomaly ; anomalies) {
            anomaly.update(dt);
            anomaly.updateCollision(playerEls);
        }
        
        healthFlask.update(dt);
        healthFlask.updateCollision(playerEls);
        ScreenLimit.update(playerEls);

        if (!playerEls.isAlive()) {
            deadTimer.start();
            state = PlayState.GameOver;
        }
    }

    private void updateGameover(float dt) {
        playerEls.update(dt);
        deadTimer.update(dt);

        if (deadTimer.hasStopped()) {
            SceneManager.get().set("GameOverScene");
        }
    }
}
