module scenes.menuscene;

import parin;
import scenes.iscene;

import managers.text;
import managers.scene;
import constants : ETFResolution, ETFUi;
import managers.texture;

import bg.nightsky;

private struct StartTextConstants {
    @disable this();

    enum str = "Press SPACE to start";
    // TODO: Center (Position X) next to the title.
    enum origin = Vec2(
        (ETFResolution.width / 2.0f ) - (ETFUi.charSize * str.length), ETFResolution.height - 150
    );
}

class MenuScene : IScene {

    WaveText startText;
    WaveTexture titleTexture;

    public override void onStart() {
        /* Empty */
        startText = WaveText(StartTextConstants.str, StartTextConstants.origin, pink, 30.0f);
        titleTexture = WaveTexture("Title",
            Vec2(ETFResolution.width / 2.0f - 512 / 2.0f, 0));
    }

    public override void onUpdate(float dt) {
        startText.update(dt);
        titleTexture.update(dt);

        BGNightSky.update(dt);

        if (isDown(Keyboard.space)) SceneManager.get().set("PlayScene");
    }

    public override void onDraw() {
        BGNightSky.draw();
        startText.draw();
        titleTexture.draw();
    }
}
