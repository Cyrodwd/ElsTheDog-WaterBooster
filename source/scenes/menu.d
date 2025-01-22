module scenes.menu;

import parin;
import scenes.iscene;

import constants;
import managers.text;
import managers.scene;
import managers.texture;

import bg.nightsky;

private struct StartTextConstants {
    @disable this();

    enum str = "Press SPACE to start";
    // TODO: Center (Position X) next to the title.
    enum origin = Vec2(
        0, ETFApplication.resolution.y - 150
    );
}

final class MenuScene : IScene {
    Text authorText;
    WaveText startText;
    WaveTexture titleTexture;

    public override void onStart() {
        /* Empty */
        titleTexture = WaveTexture("Title", Vec2(ETFApplication.resolution.x / 2.0f, ETFSprite.size), 20.5f);
        startText = WaveText(StartTextConstants.str, StartTextConstants.origin, white, 30.0f, Alignment.center);
        authorText = Text("@Cyrodwd", Vec2.zero, pink, Alignment.left);
    }

    public override void onUpdate(float dt) {
        startText.update(dt);
        titleTexture.update(dt);

        BGNightSky.update(dt);

        if (isDown(ETFUi.confirmKey)) SceneManager.get().set("PlayScene");
    }

    public override void onDraw() {
        BGNightSky.draw();
        titleTexture.draw();

        startText.draw();
        authorText.draw();
    }
}
