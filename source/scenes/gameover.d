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
    private static float textAmplitude = 20.0f;
    private static IStr newScoreStr = "[NEW RECORD!]";

    static immutable Vec2 ysOrigin = Vec2(40, ETFApplication.resolution.y / 2.0f);
    static immutable Vec2 bsOrigin = Vec2(65, ysOrigin.y - 60);

    static immutable Vec2 restartTextOrigin = Vec2(-ysOrigin.x, ysOrigin.y);
    static immutable Vec2 giveUpTextOrigin = Vec2(-bsOrigin.x, bsOrigin.y);

    private Background background;

    private WaveTexture wbUnsafeTexture;
    private WaveText restartText;
    private WaveText giveUpText;

    private WaveText yourScoreText;
    private WaveText bestScoreText;
    private WaveText newRecordText;

    private TransitionManager transitions;

    public override void onStart() {
        const nRecordOrigin = Vec2(0.0f, ysOrigin.y - 120);
        const wbUnsafeOrigin = Vec2((ETFApplication.resolution.x / 2.0f), ETFSprite.size);

        background = Background("ElsDeadBackground");

        restartText = WaveText(format("{} to restart", ETFKeys.confirmStr()), restartTextOrigin,
            white, textAmplitude, Alignment.right);

        giveUpText = WaveText(format("{} to give up", ETFKeys.denyStr()), giveUpTextOrigin,
            white, textAmplitude, Alignment.right);
        
        yourScoreText = WaveText(format("Your score: {}", ScoreData.currScore), ysOrigin, white, textAmplitude);
        bestScoreText = WaveText(format("Best score: {}", ScoreData.bestScore), bsOrigin, white, textAmplitude);
        
        newRecordText = WaveText(newScoreStr, nRecordOrigin, pink, textAmplitude, Alignment.center);

        wbUnsafeTexture = WaveTexture("WbUnsafeTexture", wbUnsafeOrigin, 40.0f);

        transitions = TransitionManager(1.3f);
        transitions.playTransition(Transition.fadeIn);
    }

    public override void onUpdate(float dt) {
        transitions.update(dt);
        wbUnsafeTexture.update(dt);

        updateText(dt);

        if (transitions.canTransition()) {
            if (isDown(ETFKeys.confirm)) { ScoreData.applyBestScore(); SceneManager.get().set(ETFScenesNames.play); }
            else if (isDown(ETFKeys.deny)) { ScoreData.applyBestScore(); SceneManager.get().set(ETFScenesNames.menu); }
        }
    }

    private void updateText(float dt) {
        yourScoreText.update(dt);
        bestScoreText.update(dt);
        if (ScoreData.hasNewRecord()) newRecordText.update(dt);

        restartText.update(dt);
        giveUpText.update(dt);
    }

    public override void onDraw() {
        background.draw();
        displayText();
        wbUnsafeTexture.draw();
        transitions.draw();
    }

    private void displayText() {
        yourScoreText.draw();
        bestScoreText.draw();
        if (ScoreData.hasNewRecord()) newRecordText.draw();

        giveUpText.draw();
        restartText.draw();
    }
}