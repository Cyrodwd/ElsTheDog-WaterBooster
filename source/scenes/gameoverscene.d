module scenes.gameoverscene;

import parin;
import constants : ETFUi;
import scenes.iscene;

import managers.texture;
import managers.scene;
import managers.text;

class GameOverScene : IScene
{
    private DrawOptions bgOptions;
    private UiOptions bOptions;

    public override void onStart() {
        bgOptions.scale = Vec2(2); // 640x480 -> 1280x960
        bOptions.font = FontManager.get();

        println("Els has fallen from very high.");
    }

    public override void onUpdate(float dt) {
        prepareUi();
        setUiFocus(id: 0);
    }

    public override void onDraw() {
        drawTexture(TextureManager.getInstance().get("ElsDeadBackground"), Vec2.zero, bgOptions);

        if (uiButton(Rect(Vec2.zero, ETFUi.buttonSize), "Restart", bOptions)) {
            SceneManager.get().set("PlayScene");
        }

        if (uiButton(Rect(Vec2(0, ETFUi.buttonSize.y), ETFUi.buttonSize), "GiveUp", bOptions)) {
            SceneManager.get().set("MenuScene");
        }
    }
}