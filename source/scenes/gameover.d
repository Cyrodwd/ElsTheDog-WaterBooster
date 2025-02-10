module scenes.gameover;

import parin;
import scenes.iscene;

import data.score;
import data.constants;

import bg;
import managers.texture;
import managers.scene;
import managers.text;
import managers.transition;
import data.attempts;

final class GameOverScene : IScene
{
    private static Alignment textAlignment = Alignment.center;
    private static float textAmplitude = 40.0f;

    private Background background;

    private WaveTexture testFailedTexture;
    private WaveText restartText;
    private WaveText giveUpText;

    private TransitionManager transitions;

    public override void onStart() {
        const Vec2 rsOrigin = Vec2(0, ETFApplication.resolution.y / 2.0f);
        const Vec2 guOrigin = Vec2(0, rsOrigin.y - 60);

        printfln("Current score: {}", ScoreData.currScore);

        background = Background("ElsDeadBackground");
        restartText = WaveText(format("Press {} to restart", ETFKeys.confirmStr()), rsOrigin, white, textAmplitude,
            textAlignment);
        giveUpText = WaveText(format("Press {} to give up", ETFKeys.denyStr()), guOrigin, white, textAmplitude,
            textAlignment);

        testFailedTexture = WaveTexture("WBNotSafeTexture",
            Vec2(ETFApplication.resolution.x / 2.0f, ETFSprite.size), 40.0f);

        transitions = TransitionManager(1.3f);
        transitions.playTransition(Transition.fadeIn);
    }

    public override void onUpdate(float dt) {
        transitions.update(dt);
        testFailedTexture.update(dt);
        restartText.update(dt);
        giveUpText.update(dt);


        if (transitions.canTransition()) {
            if (isDown(ETFKeys.confirm)) SceneManager.get().set(ETFScenesNames.play);
            else if (isDown(ETFKeys.deny)) SceneManager.get().set(ETFScenesNames.menu);
        }
    }

    public override void onDraw() {
        background.draw();

        giveUpText.draw();
        restartText.draw();
        testFailedTexture.draw();

        transitions.draw();
    }
}