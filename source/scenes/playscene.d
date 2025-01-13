module scenes.playscene;

import parin : Rect, Vec2, DrawOptions, drawTexture, isPressed, Keyboard, drawDebugText, drawText, Timer;
import joka.colors;
import globals : ETFResolution;

import player;
import globals;
import skyentity;

import scenes.scene;
import managers;
import std.format : format;

private
{
    enum offscreenRectSize = Vec2(ETFResolution.width, 1);
    enum offscreenRectPosition = Vec2(0, ETFResolution.height - offscreenRectSize.y);

    // Screen Limit
    struct OffscreenRect {
        Rect rect;

        void start() {
            rect = Rect(offscreenRectPosition, offscreenRectSize);
        }

        void update(ref Player pl) {
            if (rect.hasIntersection(pl.hitbox)) {
                pl.takeDamage(amount: 5);
                pl.startHurtState();
            }
        }
    }

    struct ScrollingBG {
        @disable this();

        static:

        float scrollSpeed;
        Vec2 position, clonePosition;
        DrawOptions drawOptions;

        void start() {
            position = Vec2.zero;
            clonePosition = Vec2(ETFResolution.width, 0);

            scrollSpeed = 450.0f;
            
            // 1280x960 lmao
            drawOptions.scale = Vec2(2);
        }

        void update(float dt) {
            position.x -= scrollSpeed * dt;
            if (position.x <= -ETFResolution.width)
                position.x = 0.0f;

            clonePosition.x = position.x + ETFResolution.width;
        }

        void draw() {
            // First copy
            drawTexture(TextureManager.getInstance().get("NightSkyBackground"), position, drawOptions);

            // Second copy
            drawTexture(TextureManager.getInstance().get("NightSkyBackground"), clonePosition, drawOptions);
        }
    }
}

enum PlayState : ubyte {
    Normal = 0,
    GameOver
}

class PlayScene : IScene
{
    private PlayState state;
    private Player playerEls;
    private ScoreManager scoreManager;

    private Text healthText;
    private Text scoreText;
    private Text fuelText;

    private Timer deadTimer; // Time to switch to GameOver Scene
    
    private void fillBooster() {
        playerEls.getBooster.addFuel(5.0f);
    }

    private Anomaly[3] anomalies; // Test
    private AdvantageFlask healthFlask;
    private OffscreenRect verticalLimit;

    private SEConfig fireTearConfig;

    public override void onStart() {
        ScrollingBG.start();
        fireTearConfig = SEConfig(SEDirection.vertical, 354.2f);

        playerEls.start();

        scoreManager = ScoreManager(1.0f);
        verticalLimit.start();

        healthFlask = new AdvantageFlask(SEConfig(SEDirection.horizontal, 554.2f), 5.3f, 30, pink, &fillBooster);
        deadTimer = Timer(3.0f);

        // Testing multiple anomalies
        anomalies = [
            new Anomaly(SEConfig(SEDirection.horizontal, 244.3f), "FireTear", 15, 2.6f),
            new Anomaly(SEConfig(SEDirection.vertical, 644.2f), "FireTear", 12, 1.56f),
            new Anomaly(SEConfig(SEDirection.vertical, 965.12f), "FireTear", 1, 6.2f),
        ];

        // Why... :<
        healthText = Text("Health: X/Y", Vec2(45, ETFResolution.height - 85), white);
        scoreText = Text("000000", Vec2(640 - 90, ETFResolution.height - 85), white);
        fuelText = Text("Fuel: X", Vec2(ETFResolution.width - 400, ETFResolution.height - 85), white);

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
            ScrollingBG.update(dt);

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
        ScrollingBG.draw();

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
        immutable Vec2 uiBarPosition = Vec2(0,
            ETFResolution.height - TextureManager.getInstance().get("uiBar").size().y);
        drawTexture(TextureManager.getInstance().get("uiBar"), uiBarPosition);

        scoreText.setText(format("%06u", scoreManager.points));
        scoreText.draw();

        healthText.setText(format("Health: %02u/%02d", playerEls.getHealth(), ElsMisc.maxHealth));
        healthText.draw();

        fuelText.setText(format("Fuel: %.2f/%.0f", playerEls.getBooster().getFuel(), MagmaBoosterExpr.maxFuel));
        fuelText.draw();
    }
}
