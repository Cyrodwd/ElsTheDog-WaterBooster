module scenes.pause;

import parin;
import data.play.misc;
import data.constants;
import scenes.iscene;

import managers.text;
import managers.scene;
import managers.texture;
import managers.music;

import data.attempts;
import bg.nightsky;

private struct TextStrings {
    @disable this();

    enum cnt = "Press {} to continue";
    enum abort = "Press {} to abort"; // Abort Water Booster Test
}

final class PauseScene : IScene
{
    private static warnOffset = 150;
    private static textAmplitude = 40.2f;
    private static rectColor = Color(0, 0, 0, 128);
    private static texturePosition = Vec2(ETFApplication.resolution.x / 2.0f, ETFSprite.size);

    private Rect backgroundRect;
    private WaveTexture pauseTexture;
    private WaveText continueText;
    private WaveText abortText;

    private WaveText scoreText;
    private WaveText warningText;

    public override void onStart() {
        backgroundRect = Rect(Vec2.zero, toVec(ETFApplication.resolution));

        pauseTexture = WaveTexture("PauseTexture", texturePosition, textAmplitude);
        continueText = WaveText(format(TextStrings.cnt, ETFKeys.confirmStr()), Vec2(0, ETFSprite.size + 256), 
            white, textAmplitude, Alignment.center);
        abortText = WaveText(format(TextStrings.abort, ETFKeys.denyStr()), Vec2(0, ETFSprite.size + 320), white,
            textAmplitude, Alignment.center);

        import data.user;
        scoreText = WaveText(format("Current Score: {}", UserData.currScore),
            Vec2(0.0f, ETFApplication.resolution.y - warnOffset * 1.5f), white, textAmplitude, Alignment.center);

        warningText = WaveText("If you abort, your score will be lost.",
            Vec2(0.0f, ETFApplication.resolution.y - warnOffset), red, textAmplitude, Alignment.center);

        MusicManager.setVolume("PlayBGM", 0.5f);
    }

    public override void onUpdate(float dt) {
        MusicManager.update("PlayBGM");

        BGNightSky.update(dt);
        pauseTexture.update(dt);
        continueText.update(dt);
        abortText.update(dt);

        scoreText.update(dt);
        warningText.update(dt);

        if (isPressed(ETFKeys.confirm)) {
            PlayTimer.start();
            MusicManager.setVolume("PlayBGM", 1.0f);
            SceneManager.get().set(ETFScenesNames.play, refresh: false);
        }

        else if (isPressed(ETFKeys.deny)) {
            MusicManager.stop("PlayBGM");
            AttemptsData.add(isDeath: false); // Add surrender
            AttemptsData.save();
            
            SceneManager.get().set(ETFScenesNames.rejected);
        }
    }

    public override void onDraw() {
        BGNightSky.draw();
        drawRect(backgroundRect, rectColor);

        pauseTexture.draw();
        continueText.draw();
        abortText.draw();

        scoreText.draw();
        warningText.draw();
    }
}