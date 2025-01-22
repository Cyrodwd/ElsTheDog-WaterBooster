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

private:
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

struct UiText {
    static enum vOffset = ETFApplication.resolution.y - 85.0f;
    static enum defaultColor = white;

    WaveText counter;

    Text healthText;
    Text scoreText; // It also display advantage flask names
    Text fuelText;

    void start() {
        scoreText = Text("-", Vec2(0, vOffset), defaultColor, Alignment.center);
        healthText = Text("Health: --/--", Vec2(45, vOffset), defaultColor, Alignment.left);
        fuelText = Text("Fuel: ----/--", Vec2(-35, vOffset), defaultColor, Alignment.right);
    }

    void setColor(Color color) {
        healthText.setColor(color);
        scoreText.setColor(color);
        fuelText.setColor(color);
    }

    void setHealth(ubyte currentHp, ubyte maxHp) {
        healthText.setText(format("Health: %02u/%02u", currentHp, maxHp));
    }

    void setFuel(float currentFuel, float maxFuel) {
        fuelText.setText(format("Fuel: %.2f/%.0f", currentFuel, maxFuel));
    }

    void setScore(ushort currentScore) {
        scoreText.setText(format("%05d", currentScore));
    }

    void draw() const {
        healthText.draw();
        scoreText.draw();
        fuelText.draw();
    }

}
struct ScreenLimit {
    static enum size = Vec2(ETFApplication.resolution.x, 1);
    static enum position = Vec2(0, ETFApplication.resolution.y - size.y);
    Rect rect;
    ubyte damage;
    void start() {
        rect = Rect(position, size);
        damage = 10;
    }
    void update(ref Player pl) {
        if (rect.hasIntersection(pl.hitbox)) {
            pl.takeDamage(amount: damage);
            pl.startHurtState();
        }
    }
}


public:

struct PlayTimer {
    @disable this();

    static:

    private Timer timer = Timer(3.0f);

    void start() {
        timer.start();
    }

    void update(float dt) {
        timer.update(dt);
    }

    bool done() {
        return timer.hasStopped();
    }

    ubyte count() {
        return cast (ubyte) (timer.time + 1U);
    }
}

enum PlayState : ubyte {
    Ready = 0,
    Active,
    Pause,
    GameOver
}

final class PlayScene : IScene
{
    private static enum Vec2 counterPosition = Vec2(0, ETFApplication.resolution.y / 2.0f - 40);

    // Attributes/Methods

    private static PlayState state;
    private Player playerEls;
    private ScoreManager scoreManager;

    private Timer deadTimer; // Time to switch to GameOver Scene

    private Anomaly[3] anomalies; // Test
    private AdvantageFlask healthFlask;

    private SEConfig fireTearConfig;
    private ScreenLimit screenLimit;

    private UiBar uiBar;
    private UiText uiText;
    private WaveText counter;

    private Color uiTextColor = UiText.defaultColor;

    private void fillBooster() {
        playerEls.getBooster.addFuel(5.0f);
    }

    public override void onStart() {
        // Scrolling background have been already started
        fireTearConfig = SEConfig(SEDirection.vertical, 354.2f);
        playerEls.start();

        scoreManager = ScoreManager(1.0f);
        screenLimit.start();

        healthFlask = new AdvantageFlask(SEConfig(SEDirection.horizontal, 554.2f, "+FUEL"), 5.3f, 30,
            pink, &fillBooster);
        deadTimer = Timer(3.0f);

        // Testing multiple anomalies
        anomalies = [
            new Anomaly(SEConfig(SEDirection.horizontal, 244.3f, "FireTear"), 15, 2.6f),
            new Anomaly(SEConfig(SEDirection.vertical, 644.2f, "FireTear"), 12, 1.56f),
            new Anomaly(SEConfig(SEDirection.vertical, 965.12f, "FireTear"), 1, 6.2f),
        ];

        uiBar.start();

        state = PlayState.Ready;
        PlayTimer.start();

        uiText.start();
        counter = WaveText("-", counterPosition, ETFUi.cherryColor, 20.0f, Alignment.center);
    }

    public override void onUpdate(float dt) {
        if (state != PlayState.Ready) updateUi(dt);
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

        drawUi();
    }

    private void updateUi(float dt) {
        uiText.setHealth(playerEls.getHealth(), ElsNumbers.maxHealth);
        if (playerEls.isHurt()) uiText.setColor(ETFUi.cherryColor);

        uiText.setFuel(playerEls.getBooster().getFuel(), MagmaBoosterConst.maxFuel);
        uiText.setScore(scoreManager.points);
    }

    private void drawUi() {
        uiBar.draw();
        uiText.draw();

        if (onCounting()) counter.draw();
    }

    // 
    private bool onCounting() {
        return (state == PlayState.Ready || state == PlayState.Pause);
    }

    private void updateReady(float dt) {
        if (state != PlayState.Pause) playerEls.updateSprite(dt);

        PlayTimer.update(dt);
        counter.update(dt);
        counter.setText(toStr(PlayTimer.count()));

        if (PlayTimer.done()) {
            state = PlayState.Active;
        }
    }

    private void updateActive(float dt) {
        playerEls.update(dt);

        uiTextColor = playerEls.isHurt() ? ETFUi.cherryColor : UiText.defaultColor;
        uiText.setColor(uiTextColor);

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

        screenLimit.update(playerEls);

        if (!playerEls.isAlive()) {
            deadTimer.start();
            state = PlayState.GameOver;
        }
    }

    private void updateGameover(float dt) {
        playerEls.update(dt);
        deadTimer.update(dt);

        // DO NOT UPDATE COLLISIONS
        foreach(ref Anomaly anomaly ; anomalies) anomaly.update(dt);
        healthFlask.update(dt);

        if (deadTimer.hasStopped()) {
            SceneManager.get().set("GameOverScene");
        }
    }
}
