module scenes.menu;

import parin;
import scenes.iscene;

import managers;

import data.user;
import data.attempts;
import data.constants;

import backgrounds.nightsky;

private struct TextConstants {
    @disable this();
    static:

    enum startStr = "Press {} to start";
    // TODO: Center (Position X) next to the title.
    enum startOrigin = Vec2(16, ETFApplication.resolution.y - 150);

    enum Vec2 dataOrigin = Vec2(18, ETFApplication.resolution.y / 2.0f);
    enum Vec2 miscOrigin = Vec2(0.0f, dataOrigin.y + 80.0f);
    enum float amplitude = 30.0f;

    enum bestScoreLabel = "Best Score: {}";
    enum deathsLabel = "Deaths: {}";
    enum surrendersLabel = "Surrenders: {}";
    enum miscLabel = "{}: Github. {}: Tumblr. {}: Clear Score.";
}

final class MenuScene : IScene {
    private static Vec2 titleOrigin = Vec2(ETFApplication.resolution.x / 2.0f + 16, ETFSprite.size);
    
    private WaveText startText;
    private WaveTexture titleTexture;
    private TextureId letterTexture;
    private TransitionManager transitions;

    private WaveText deathsText;
    private WaveText bestScoreText;
    private WaveText surrendersText;
    private Text miscText;

    private bool displayLetter;
    IStr musName;

    public override void onStart() {
        TextureManager.getInstance().add("LetterTexture", "ui/letter.png");
        letterTexture = TextureManager.getInstance().get("LetterTexture");

        transitions = TransitionManager(1.0f);
        transitions.playTransition(Transition.fadeIn);
        
        titleTexture = WaveTexture("TitleTexture", titleOrigin, 20.5f);
        startText = WaveText(format(TextConstants.startStr, ETFKeys.confirmStr()), TextConstants.startOrigin,
            white, TextConstants.amplitude, Alignment.center);

        bestScoreText = WaveText(format(TextConstants.bestScoreLabel, UserData.bestScore), TextConstants.dataOrigin,
            white, TextConstants.amplitude);

        deathsText = WaveText(format(TextConstants.deathsLabel, AttemptsData.deaths),
            Vec2(36.0f, TextConstants.dataOrigin.y), white, TextConstants.amplitude, Alignment.center);

        surrendersText = WaveText(format(TextConstants.surrendersLabel, AttemptsData.surrenders),
            Vec2(-TextConstants.dataOrigin.x, TextConstants.dataOrigin.y), white,
                TextConstants.amplitude, Alignment.right);

        miscText = Text(format(TextConstants.miscLabel,
            toStr(ETFKeys.pBoost), toStr(ETFKeys.pBoostDown),
                toStr(ETFKeys.pExtra)), TextConstants.miscOrigin, white, Alignment.center);

        musName = UserData.haveLetter ? "AltMenuBGM" : "MenuBGM";

        if (!MusicManager.isPlaying(musName)) MusicManager.play(musName);
        displayLetter = UserData.haveLetter;
    }

    public override void onUpdate(float dt) {
        MusicManager.update(musName);
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

        if (displayLetter)
            drawTexture(letterTexture, Vec2.zero);
            
        titleTexture.draw();

        bestScoreText.draw();
        deathsText.draw();
        surrendersText.draw();
        miscText.draw();

        startText.draw();
        
        transitions.draw();

    }

    private bool canPress(Keyboard key) {
        return (transitions.canTransition() && isPressed(key));
    }

    private void updateUi() {
        // Github (Z)
        if (canPress(ETFKeys.pBoost))
            openUrl("https://github.com/Cyrodwd");

        // Tumblr (I don't use X/Twitter anymore lol, X)
        if (canPress(ETFKeys.pBoostDown))
            openUrl("https://www.tumblr.com/cyrodwd");

        // Clear data (C)
        if (canCleanData() && canPress(ETFKeys.pExtra))
            clearData();

        // Play
        if (canPress(ETFKeys.confirm)) {
            TextureManager.getInstance().remove("LetterTexture"); // Literally it will not be used in any other place
            MusicManager.stop(musName);
            SceneManager.get().set(ETFScenesNames.play);
        }
    }

    private void clearData() {
        UserData.bestScore = 0;
        UserData.currScore = 0;
        
        /* Letter will stay */
        
        AttemptsData.deaths = 0;
        AttemptsData.surrenders = 0;

        bestScoreText.setText(format(TextConstants.bestScoreLabel, UserData.bestScore));
        deathsText.setText(format(TextConstants.deathsLabel, AttemptsData.deaths));
        surrendersText.setText(format(TextConstants.surrendersLabel, AttemptsData.surrenders));

        UserData.save();
        AttemptsData.save();
    }

    private bool canCleanData() const {
        return UserData.canClean() && AttemptsData.canClean();
    }
}
