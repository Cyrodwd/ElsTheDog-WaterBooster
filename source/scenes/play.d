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
    enum offscreenRectSize = Vec2(ETFApplication.width, 1);
    enum offscreenRectPosition = Vec2(0, ETFApplication.height - offscreenRectSize.y);

    // Screen Limit
    struct OffscreenRect {
        Rect rect;

        void start() {
            rect = Rect(offscreenRectPosition, offscreenRectSize);
        }

        void update(ref Player pl) {
            if (rect.hasIntersection(pl.hitbox)) {
                pl.takeDamage(amount: 10);
                pl.startHurtState();
            }
        }
    }

    struct UiBar {
        DrawOptions drawOptions;
        Vec2 position;

        TextureId texture;

        void start() {
            texture = TextureManager.getInstance().get("uiBar");
            position = Vec2(0, ETFApplication.height - texture.size().y);

            // Slightly transparent
            drawOptions.color = Color(255, 255, 255, 180);
        }

        void draw() const {
            drawTexture(texture, position, drawOptions);
        }
    }
}

enum PlayState : ubyte {
    Normal = 0,
    GameOver
}

class PlayScene : IScene
{
    // Constants

    private struct TextConstants {
        @disable this();
        enum ushort vOffset = ETFApplication.height - 85;
        enum Vec2 centerPosition = Vec2((ETFApplication.width / 2) - (ETFUi.charSize * 5), vOffset);
    }

    // Attributes/Methods

    private PlayState state;
    private Player playerEls;
    private ScoreManager scoreManager;

    private Text healthText;
    private Text centerText;
    private Text fuelText;

    private Timer deadTimer; // Time to switch to GameOver Scene
    
    private void fillBooster() {
        playerEls.getBooster.addFuel(5.0f);
    }

    private Anomaly[3] anomalies; // Test
    private AdvantageFlask healthFlask;
    private OffscreenRect verticalLimit;

    private SEConfig fireTearConfig;
    private UiBar uiBar;

    public override void onStart() {
        // Scrolling background have been already started
        fireTearConfig = SEConfig(SEDirection.vertical, 354.2f);

        playerEls.start();

        scoreManager = ScoreManager(1.0f);
        verticalLimit.start();

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
        centerText = Text("-----", Vec2(0, TextConstants.vOffset), white, Alignment.center);
        healthText = Text("Health: -/-", Vec2(45, TextConstants.vOffset), white, Alignment.left);
        fuelText = Text("Fuel: --/--", Vec2(-35, TextConstants.vOffset), white, Alignment.right);

        uiBar.start();

        state = PlayState.Normal;
    }

    public override void onUpdate(float dt) {
        /* Input update */
        foreach (ref Anomaly anomaly ; anomalies)
            anomaly.update(dt);

        healthFlask.update(dt);

        playerEls.update(dt);

        if (state == PlayState.Normal) {
             if (isPressed(Keyboard.esc)) SceneManager.get().set("PauseScene");

            scoreManager.update(dt);
            BGNightSky.update(dt);

            if (!playerEls.isAlive()) {
                deadTimer.start();
                state = PlayState.GameOver;
            }

            foreach (ref Anomaly anomaly ; anomalies)
                anomaly.updateCollision(playerEls);

            healthFlask.updateCollision(playerEls);

            verticalLimit.update(playerEls);
        }
        else
        {
            deadTimer.update(dt);

            if (deadTimer.hasStopped()) {
                SceneManager.get().set("GameOverScene");
            }
        }
    }

    public override void onDraw() {
        BGNightSky.draw();

        playerEls.draw();

        foreach (Anomaly anomaly ; anomalies) {
            anomaly.draw();
        }

        healthFlask.draw();

        if (state != PlayState.GameOver)
            drawUI();
    }

    private void drawUI() {
        // ui bar
        uiBar.draw();

        centerText.setText(format("%05u", scoreManager.points));
        centerText.draw();

        // The text is red if player is hurt or dead
        const Color hpTextColor = playerEls.state == ElsState.hurt ? red : white;
        healthText.setColor(hpTextColor);

        healthText.setText(format("Health: %02u/%02d", playerEls.getHealth(), ElsNumbers.maxHealth));
        healthText.draw();

        fuelText.setText(format("Fuel: %.2f/%.0f", playerEls.getBooster().getFuel(), MagmaBoosterConst.maxFuel));
        fuelText.draw();
    }
}
