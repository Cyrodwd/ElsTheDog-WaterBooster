module scenes.menuscene;

import parin;
import scenes.scene;
import managers.scene;
import managers.text;

class MenuScene : IScene {
    private Vec2 mButtonOffset;
    private IStr mLabel;
    private UiOptions mOptions;

    public override void onStart() {
        mButtonOffset = Vec2(512, 128);
        mLabel = "Start test";
        mOptions.font = FontManager.get();
    }

    public override void onUpdate(float dt) {
        prepareUi();
        useUiLayout(Layout.h);
        setUiFocus(0);
        /* Ay xD*/
    }

    public override void onDraw() {
        setUiStartPoint(Vec2(8, 0));

        if (uiButton(mButtonOffset, mLabel, mOptions)) {
            SceneManager.get().set("PlayScene");
        }

        setUiStartPoint(Vec2(8, 256));

        if (uiButton(mButtonOffset, "Parin URL test", mOptions)) {
            openUrl();
        }
    }

    public override void onFree() {
        /* DAMN */
    }
}