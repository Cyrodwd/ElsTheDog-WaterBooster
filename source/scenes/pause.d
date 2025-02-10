module scenes.pause;

import parin;
import data.play.misc;
import data.constants;
import scenes.iscene;

import managers.text;
import managers.scene;
import managers.texture;
import data.attempts;

private struct TextStrings {
    @disable this();

    enum cnt = "Press {} to continue";
    enum abort = "Press {} to abort"; // Abort Water Booster Test
}

final class PauseScene : IScene
{
    private static textAmplitude = 40.2f;

    WaveTexture pauseTexture;
    WaveText continueText;
    WaveText abortText;

    public override void onStart() {
        pauseTexture = WaveTexture("PauseTexture", Vec2(ETFSprite.size + 80.0f, ETFSprite.size), textAmplitude);
        continueText = WaveText(format(TextStrings.cnt, ETFKeys.confirmStr()), Vec2(35, ETFSprite.size + 256), 
            white, textAmplitude);
        abortText = WaveText(format(TextStrings.abort, ETFKeys.denyStr()), Vec2(110, ETFSprite.size + 320), white,
            textAmplitude);
    }

    public override void onUpdate(float dt) {
        pauseTexture.update(dt);
        continueText.update(dt);
        abortText.update(dt);

        if (isPressed(ETFKeys.confirm)){
            PlayTimer.start();
            SceneManager.get().set(ETFScenesNames.play, refresh: false);
        }

        else if (isPressed(ETFKeys.deny)) {
            AttemptsData.add(isDeath: false); // Add surrender
            AttemptsData.save();
            SceneManager.get().set(ETFScenesNames.rejected);
        }
    }

    public override void onDraw() {
        pauseTexture.draw();
        continueText.draw();
        abortText.draw();
    }
}