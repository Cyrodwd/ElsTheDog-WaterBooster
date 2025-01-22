module scenes.pause;

import parin;
import constants;
import scenes.play : PlayScene, PlayTimer;
import scenes.iscene;

import managers.text;
import managers.scene;
import managers.texture;

private struct TextStrings {
    @disable this();

    enum pause = "PAUSE";
    enum cnt = "SPACE to continue";
    enum abort = "ESC to abort"; // Go to menu
}

final class PauseScene : IScene
{
    private static textAmplitude = 40.2f;

    WaveTexture pauseTexture;
    WaveText continueText;
    WaveText abortText;

    public override void onStart() {
        pauseTexture = WaveTexture("PauseTexture", Vec2(ETFSprite.size), textAmplitude);
        continueText = WaveText(TextStrings.cnt, Vec2(35, ETFSprite.size + 256), white, textAmplitude);
        abortText = WaveText(TextStrings.abort, Vec2(110, ETFSprite.size + 320), white, textAmplitude);
    }

    public override void onUpdate(float dt) {
        pauseTexture.update(dt);
        continueText.update(dt);
        abortText.update(dt);

        if (isPressed(ETFUi.confirmKey)){
            PlayTimer.start();
            SceneManager.get().set("PlayScene", refresh: false);
        }

        else if (isPressed(ETFUi.denyKey)) SceneManager.get().set("MenuScene");
    }

    public override void onDraw() {
        pauseTexture.draw();
        continueText.draw();
        abortText.draw();
    }
}