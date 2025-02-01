module scenes.play;

import parin;
import data.play;
import data.constants;

import player;
import player.booster : WBoosterConst;

import sentity.data;
import sentity.anomaly;
import sentity.aflask;

import managers;
import scenes.iscene;

import bg.nightsky;
import data.play;

import std.format : format; // score with 5 digits

private:

enum GhostState {
    none,
    appearing,
    disappearing
}

struct UiBar {
    static enum ubyte maxAlpha = 180;
    static enum ubyte rectHeight = 112;
    static enum float alphaDuration = 1.5f;

    GhostState state;
    float alpha;
    Vec2 position;

    Rect baseRect;
    Timer alphaTimer;
    TextureId texture;
    DrawOptions drawOptions;

    void start() {
        texture = TextureManager.getInstance().get("uiBar");
        position = Vec2(0, ETFApplication.resolution.y - texture.size().y);
        state = GhostState.none;
        alphaTimer = Timer(alphaDuration);
        alpha = 0.0f;

        drawOptions.color = Color(255, 255, 255, 0);
    }

    void update(float dt) {
        alphaTimer.update(dt);

        if (state == GhostState.appearing)
            alpha = (alphaTimer.time / alphaTimer.duration);
        else if (state == GhostState.disappearing)
            alpha = 1.0f - (alphaTimer.time / alphaTimer.duration);

        drawOptions.color.a = cast(ubyte)(alpha * maxAlpha);
        if (alphaTimer.hasStopped()) state = GhostState.none;
    }

    void setState(GhostState state) {
        if (this.state != GhostState.none || state == GhostState.none)
            return;
        
        this.state = state;
        alphaTimer.start();
    }

    void draw() const {
        drawTexture(texture, position, drawOptions);
    }

    float getAlpha() const {
        return alpha;
    }
}

struct UiText {
    WaveText counter;

    Text healthText;
    Text fuelText;

    void start() {
        healthText = Text("Health: --/--", Vec2(45, ETFUi.vTextOffset), ETFUi.defaultTextColor, Alignment.left);
        fuelText = Text("Water: ----", Vec2(-58, ETFUi.vTextOffset), ETFUi.defaultTextColor, Alignment.right);

        healthText.setAlpha(0.0f);
        fuelText.setAlpha(0.0f);
    }

    void setColor(Color color) {
        healthText.setColor(color);
        fuelText.setColor(color);
    }

    void setHealth(ubyte currentHp, ubyte maxHp) {
        healthText.setText(format("Health: %02u/%02u", currentHp, maxHp));
    }

    void setFuel(float currentFuel, float maxFuel) {
        fuelText.setText(format("Water: %.2f", currentFuel));
    }

    void setAlpha(float alpha) {
        healthText.setAlpha(alpha);
        fuelText.setAlpha(alpha);
    }

    void draw() const {
        healthText.draw();
        fuelText.draw();
    }

}

struct UiCenterText {
    static enum tempAmplitude = 13.6f;
    static enum textDefaultPosition = Vec2(0.0f, ETFUi.vTextOffset);

    bool tempText;
    Timer tempTimer;
    WaveText text;

    void start() {
        text = WaveText("-", textDefaultPosition, ETFUi.defaultTextColor, 0.0f, Alignment.center);
        tempTimer = Timer(3.0f); 
        tempText = false;

        text.setAlpha(0.0f);
    }

    void update(float dt) {
        if (tempText) {
            tempTimer.update(dt);
            text.update(dt);
            
            if (tempTimer.hasStopped()) {
                reset();
                tempText = false;
            }
        }   
    }

    void draw() {
        text.draw();
    }

    void reset() {
        text.setAmplitude(0.0f);
        text.setColor(ETFUi.defaultTextColor);
        text.setPosition(textDefaultPosition);
    }

    void setAlpha(float alpha) {
        text.setAlpha(alpha);
    }

    void setText(IStr str) {
        text.setText(str);
    }

    void setTempText(IStr str, Color color) {
        text.setText(str);

        text.setColor(color);
        text.setAmplitude(tempAmplitude);

        if (!tempText) tempText = true;
        tempTimer.start();
    }

    void setColor(Color color) {
        text.setColor(color);
    }

    bool hasTempText() {
        return tempText;
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

public final class PlayScene : IScene
{
    private static enum Vec2 counterPosition = Vec2(0, ETFApplication.resolution.y / 2.0f - 40);

    // Attributes/Methods

    private static PlayState state;
    private Player playerEls;
    private ScoreManager scoreManager;

    private Timer deadTimer; // Time to switch to GameOver Scene

    private Anomaly[3] anomalies;
    private AdvantageFlask[3] advantageFlasks;

    private SEConfig fireTearConfig;
    private ScreenLimit screenLimit;

    private UiBar uiBar;
    private UiText uiText;
    private WaveText counter;
    private UiCenterText centerText;

    private Color uiTextColor = ETFUi.defaultTextColor;

    private void fillBooster() {
        playerEls.getBooster.addFuel(5U);
    }

    public override void onStart() {
        playerEls.start();
        deadTimer = Timer(3.0f);

        scoreManager = ScoreManager(1.0f);
        FlasksEffects.setup(&scoreManager, &playerEls);
        screenLimit.start();

        addAnomalies();
        addAdvantageFlasks();

        state = PlayState.Ready;
        PlayTimer.start();

        uiBar.start();
        uiText.start();
        centerText.start();
        counter = WaveText("-", counterPosition, ETFUi.cherryColor, 20.0f, Alignment.center);
        uiBar.setState(GhostState.appearing);
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

        foreach (Anomaly anomaly ; anomalies)
            anomaly.draw();
        
        foreach (AdvantageFlask flask ; advantageFlasks)
            flask.draw();

        drawUi();
    }

    private void addAnomalies() {
        anomalies[0] = new Anomaly(AnomaliesBaseConfig.fireTear, AnomaliesConfig.fireTear);
        anomalies[1] = new Anomaly(AnomaliesBaseConfig.fastTear, AnomaliesConfig.fastTear);
        anomalies[2] = new Anomaly(AnomaliesBaseConfig.meteorite, AnomaliesConfig.meteorite);
    }

    private void addAdvantageFlasks() {
        advantageFlasks[0] = new AdvantageFlask(FlasksBaseConfig.waterFlask, FlasksConfig.waterFlask);
        advantageFlasks[1] = new AdvantageFlask(FlasksBaseConfig.healthFlask, FlasksConfig.healthFlask);
        advantageFlasks[2] = new AdvantageFlask(FlasksBaseConfig.scoreFlask, FlasksConfig.scoreFlask);
    }

    private void updateUi(float dt) {
        if (state == PlayState.Active) centerText.update(dt);

        uiText.setHealth(playerEls.getHealth(), ElsNumbers.maxHealth);

        if (!centerText.hasTempText())
            centerText.setText(format("%05d", scoreManager.points));

        if (playerEls.isHurt()) uiText.setColor(ETFUi.cherryColor);

        uiText.setFuel(playerEls.getBooster().getFuel(), WBoosterConst.maxFuel);
    }

    private void drawUi() {
        uiBar.draw();
        uiText.draw();
        centerText.draw();

        if (onCounting()) counter.draw();
    }

    private bool onCounting() {
        return (state == PlayState.Ready || state == PlayState.Pause);
    }

    private void updateReady(float dt) {
        uiBar.update(dt);
        if (state != PlayState.Pause) playerEls.updateSprite(dt);

        PlayTimer.update(dt);
        counter.update(dt);
        counter.setText(toStr(PlayTimer.count()));

        centerText.setAlpha(uiBar.getAlpha());
        uiText.setAlpha(uiBar.getAlpha());

        if (PlayTimer.done()) {
            state = PlayState.Active;
        }
    }

    private void updateActive(float dt) {
        if (isPressed(ETFUi.denyKey)) {
            state = PlayState.Pause;
            SceneManager.get().set(ETFScenesNames.pause);
        }

        playerEls.update(dt);
        uiTextColor = playerEls.isHurt() ? ETFUi.cherryColor : ETFUi.defaultTextColor;

        uiText.setColor(uiTextColor);
        if (!centerText.hasTempText()) centerText.setColor(uiTextColor);

        scoreManager.update(dt);

        foreach (ref Anomaly anomaly ; anomalies) {
            anomaly.update(dt);
            anomaly.updateCollision(playerEls);
        }
        
        foreach (ref AdvantageFlask flask ; advantageFlasks) {
            flask.update(dt);
            flask.updateCollision(playerEls);
            if (flask.getState() == SEState.collide) centerText.setTempText(flask.getName(), flask.getColor());
        }

        screenLimit.update(playerEls);

        if (!playerEls.isAlive()) {
            centerText.reset();
            centerText.setColor(ETFUi.cherryColor);
            centerText.setText(format("%05d", scoreManager.points));

            deadTimer.start();
            state = PlayState.GameOver;
            uiBar.setState(GhostState.disappearing);
        }
    }

    private void updateGameover(float dt) {
        uiBar.update(dt);
        playerEls.update(dt);
        deadTimer.update(dt);

        centerText.setAlpha(uiBar.getAlpha());
        uiText.setAlpha(uiBar.getAlpha());

        // DO NOT UPDATE COLLISIONS
        foreach(ref Anomaly anomaly ; anomalies) anomaly.update(dt);
        foreach (ref AdvantageFlask flask ; advantageFlasks) flask.update(dt);

        if (deadTimer.hasStopped()) {
            SceneManager.get().set(ETFScenesNames.gameOver);
        }
    }
}
