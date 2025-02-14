module scenes.rejected;

import managers.text;
import managers.texture;

import parin;
import scenes.iscene;
import managers.transition;

import data.constants;
import data.attempts;
import managers.scene;

struct TextString {
    @disable this();

    static:

    immutable IStr retry = "Press {} to retry";
    immutable IStr accept = "Press {} to accept";
}

final class RejectedScene : IScene
{
    static immutable Vec2 rejectedPosition = Vec2( ETFSprite.size + 80.0f, ETFSprite.size);
    static immutable Vec2 retryPosition = Vec2(20.0f, rejectedPosition.y + ETFSprite.size);
    static immutable float textAmplitude = 30.0f;

    private WaveText retryText;
    private WaveText acceptText;
    private WaveTexture rejectedText;
    private TransitionManager transition;

    // TODO: Add background

    public void onStart() {
        transition = TransitionManager(1.8f);
        transition.playTransition(Transition.fadeIn);

        rejectedText = WaveTexture("WBRejectedText", rejectedPosition, textAmplitude);
        retryText = WaveText(format(TextString.retry, ETFKeys.confirmStr()), Vec2(70, ETFSprite.size * 2.0f), 
            white, textAmplitude);
        acceptText = WaveText(format(TextString.accept, ETFKeys.denyStr()), Vec2(80, ETFSprite.size + 320), white,
            textAmplitude);
    }

    public void onUpdate(float dt) {
        transition.update(dt);

        retryText.update(dt);
        acceptText.update(dt);

        rejectedText.update(dt);

        // Controls lol
        if (transition.canTransition())
            updateUi();
    }

    public void onDraw() {

        acceptText.draw();
        retryText.draw();
        rejectedText.draw();

        transition.draw();
    }

    private void updateUi() {
        if (isPressed(ETFKeys.confirm)) SceneManager.get().set(ETFScenesNames.play);
        if (isPressed(ETFKeys.deny)) SceneManager.get().set(ETFScenesNames.menu);
    }
}
