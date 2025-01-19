module scenes.gameover;

import parin;
import constants : ETFUi, ETFApplication;
import scenes.iscene;

import bg;
import managers.texture;
import managers.scene;
import managers.text;

class GameOverScene : IScene
{
    private static Alignment textAlignment = Alignment.center;
    private static float textAmplitude = 40.0f;

    private Background background;
    private WaveText restartText;
    private WaveText giveUpText;

    public override void onStart() {
        const Vec2 rsOrigin = Vec2(0, ETFApplication.resolution.y / 2.0f);
        const Vec2 guOrigin = Vec2(0, rsOrigin.y - 60);

        background = Background("ElsDeadBackground");
        restartText = WaveText("Press SPACE to restart", rsOrigin, white, textAmplitude, textAlignment);
        giveUpText = WaveText("Press ESC to give up", guOrigin, white, textAmplitude, textAlignment);
    }

    public override void onUpdate(float dt) {
        restartText.update(dt);
        giveUpText.update(dt);

        if (isDown(ETFUi.confirmKey)) SceneManager.get().set("PlayScene");
        else if (isDown(ETFUi.denyKey)) SceneManager.get().set("MenuScene");
    }

    public override void onDraw() {
        background.draw();
        restartText.draw();
        giveUpText.draw();
    }
}