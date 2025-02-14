module scenes.menu;

import parin;
import scenes.iscene;

import managers;

import data.score;
import data.attempts;
import data.constants;

import bg.nightsky;

private struct TextConstants {
    @disable this();
    static:

    enum startStr = "Press {} to start";
    // TODO: Center (Position X) next to the title.
    enum startOrigin = Vec2(16, ETFApplication.resolution.y - 150);

    enum Vec2 dataOrigin = Vec2(18, ETFApplication.resolution.y / 2.0f);
    enum float amplitude = 30.0f;

    enum bestScoreLabel = "Best Score: {}";
    enum deathsLabel = "Deaths: {}";
    enum surrendersLabel = "Surrenders: {}";
}

final class MenuScene : IScene {
    private static Vec2 titleOrigin = Vec2(ETFApplication.resolution.x / 2.0f + 16, ETFSprite.size);
    
    private WaveText startText;
    private WaveTexture titleTexture;
    private TransitionManager transitions;

    private WaveText deathsText;
    private WaveText bestScoreText;
    private WaveText surrendersText;

    public override void onStart() {
        transitions = TransitionManager(1.0f);
        transitions.playTransition(Transition.fadeIn);
        
        titleTexture = WaveTexture("TitleTexture", titleOrigin, 20.5f);
        startText = WaveText(format(TextConstants.startStr, ETFKeys.confirmStr()), TextConstants.startOrigin,
            white, TextConstants.amplitude, Alignment.center);

        bestScoreText = WaveText(format(TextConstants.bestScoreLabel, ScoreData.bestScore), TextConstants.dataOrigin,
            white, TextConstants.amplitude);

        deathsText = WaveText(format(TextConstants.deathsLabel, AttemptsData.deaths),
            Vec2(36.0f, TextConstants.dataOrigin.y), white, TextConstants.amplitude, Alignment.center);

        surrendersText = WaveText(format(TextConstants.surrendersLabel, AttemptsData.surrenders),
            Vec2(-TextConstants.dataOrigin.x, TextConstants.dataOrigin.y), white,
                TextConstants.amplitude, Alignment.right);
    }

    public override void onUpdate(float dt) {
        transitions.update(dt);
        startText.update(dt);
        titleTexture.update(dt);

        bestScoreText.update(dt);
        deathsText.update(dt);
        surrendersText.update(dt);

        updateUi();
        BGNightSky.update(dt);
    }

    public override void onDraw() {
        BGNightSky.draw();
        titleTexture.draw();

        bestScoreText.draw();
        deathsText.draw();
        surrendersText.draw();

        startText.draw();
        transitions.draw();
    }

    private bool canPress(Keyboard key) {
        return (transitions.canTransition() && isPressed(key));
    }

    private void updateUi() {
        // My Social
        if (canPress(ETFKeys.pBoost))
            openUrl();

        // Clear data
        if (canCleanData() && canPress(ETFKeys.pBoostDown))
            clearData();

        if (canPress(ETFKeys.confirm))
            SceneManager.get().set(ETFScenesNames.play);
    }

    private void clearData() {
        ScoreData.bestScore = 0;
        ScoreData.currScore = 0;
        AttemptsData.deaths = 0;
        AttemptsData.surrenders = 0;

        bestScoreText.setText(format(TextConstants.bestScoreLabel, ScoreData.bestScore));
        deathsText.setText(format(TextConstants.deathsLabel, AttemptsData.deaths));
        surrendersText.setText(format(TextConstants.surrendersLabel, AttemptsData.surrenders));

        ScoreData.save();
        AttemptsData.save();
    }

    private bool canCleanData() const {
        return ScoreData.canClean() && AttemptsData.canClean();
    }
}
