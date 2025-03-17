module scenes.rejected;

import managers.text;
import managers.texture;

import parin;
import scenes.iscene;
import managers.transition;

import data.user;
import data.constants;
import data.attempts;
import managers.scene;
import managers.music;

struct TextString {
    @disable this();

    static:

    immutable IStr retry = "{} to retry";
    immutable IStr accept = "{} to accept";
}

final class RejectedScene : IScene
{
    static immutable Vec2 rejectedTextOrigin = Vec2( ETFApplication.resolution.x / 2.0f, ETFSprite.size);

    static immutable Vec2 ysOrigin = Vec2(40, ETFApplication.resolution.y / 2.0f);
    static immutable Vec2 bsOrigin = Vec2(65, ysOrigin.y - 60);
    
    static immutable Vec2 retryTextOrigin = Vec2(-ysOrigin.x, ysOrigin.y);
    static immutable Vec2 acceptTextOrigin = Vec2(-bsOrigin.x, bsOrigin.y);

    static immutable float textAmplitude = 30.0f;

    private WaveText retryText;
    private WaveText acceptText;
    private WaveText yourScoreText;
    private WaveText bestScoreText;

    private WaveTexture rejectedText;
    private TransitionManager transition;

    // TODO: Add background

    public void onStart() {
        transition = TransitionManager(1.8f);
        transition.playTransition(Transition.fadeIn);

        rejectedText = WaveTexture("WBRejectedText", rejectedTextOrigin, textAmplitude);

        retryText = WaveText(format(TextString.retry, ETFKeys.confirmStr()), retryTextOrigin, 
            white, textAmplitude, Alignment.right);
        acceptText = WaveText(format(TextString.accept, ETFKeys.denyStr()), acceptTextOrigin, white,
            textAmplitude, Alignment.right);

        yourScoreText = WaveText(format("Your score: {}", UserData.currScore), ysOrigin, white, textAmplitude);
        bestScoreText = WaveText(format("Best score: {}", UserData.bestScore), bsOrigin, white, textAmplitude);
        MusicManager.play("GameOverBGM");
    }

    public void onUpdate(float dt) {
        MusicManager.update("GameOverBGM");
        transition.update(dt);

        retryText.update(dt);
        acceptText.update(dt);
        yourScoreText.update(dt);
        bestScoreText.update(dt);

        rejectedText.update(dt);

        // Controls lol
        if (transition.canTransition())
            updateUi();
    }

    public void onDraw() {
        acceptText.draw();
        retryText.draw();

        rejectedText.draw();
        yourScoreText.draw();
        bestScoreText.draw();

        transition.draw();
    }

    private void updateUi() {
        if (isPressed(ETFKeys.confirm)) {
            MusicManager.stop("GameOverBGM"); 
            SceneManager.get().set(ETFScenesNames.play);
        }
        if (isPressed(ETFKeys.deny)) {
            MusicManager.stop("GameOverBGM");
            SceneManager.get().set(ETFScenesNames.menu);
        }    
    }
}
