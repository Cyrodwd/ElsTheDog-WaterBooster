module scenes.pausescene;

import parin;
import globals;
import scenes.scene;
import managers.text;
import managers.scene;

class PauseScene : IScene
{
    Text pauseText;
    UiOptions textOptions;

    Rect continueRect;
    Rect menuRect;

    public override void onStart() {
        pauseText = Text("Your journey has been paused.", Vec2.zero, red);
        continueRect = Rect(Vec2(0, 128), ETFUi.buttonSize);
        menuRect = Rect(Vec2(0, 256), ETFUi.buttonSize);

        textOptions.font = FontManager.get();
        textOptions.hotColor = pink;
    }

    public override void onUpdate(float dt) {
        prepareUi();
        setUiFocus(0);

        if (uiButton(continueRect, "Continue", textOptions)) {
            SceneManager.get().set("PlayScene", refresh: false);
        }

        if (uiButton(menuRect, "Give Up", textOptions)) {
            SceneManager.get().set("MenuScene");
        }
    }

    public override void onDraw() {
        pauseText.draw();
    }
}