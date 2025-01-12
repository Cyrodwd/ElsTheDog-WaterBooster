module scenes.menuscene;

import parin;
import scenes.scene;
import managers.scene;
import managers.text;

class MenuScene : IScene {
    private Vec2 buttonSize;
    private UiOptions mOptions;

    public override void onStart() {
        buttonSize = Vec2(512, 128);
        mOptions.font = FontManager.get();
    }

    public override void onUpdate(float dt) {
        prepareUi();
        setUiFocus(0);
        /* Ay xD*/
    }

    public override void onDraw() {
        if (uiButton(Rect(Vec2.zero, buttonSize), "Start test", mOptions)) {
            SceneManager.get().set("PlayScene");
        }
        
        if (uiButton(Rect(Vec2(0, 256), buttonSize), "Parin URL test", mOptions)) {
            openUrl();
        }
    }
}
