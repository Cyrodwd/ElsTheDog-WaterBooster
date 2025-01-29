module scenes.menu;

import parin;
import scenes.iscene;

import managers;
import data.constants;

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
    WaveText startText;
    WaveTexture titleTexture;
    TransitionManager transitions;

    public override void onStart() {
        transitions = TransitionManager(1.0f);
        transitions.playTransition(Transition.fadeIn);
        
        titleTexture = WaveTexture("Title", Vec2(ETFApplication.resolution.x / 2.0f, ETFSprite.size), 20.5f);
        startText = WaveText(StartTextConstants.str, StartTextConstants.origin, white, 30.0f, Alignment.center);
    }

    public override void onUpdate(float dt) {
        transitions.update(dt);
        startText.update(dt);
        titleTexture.update(dt);

        BGNightSky.update(dt);

        if (transitions.canTransition() && isDown(ETFUi.confirmKey)) {
            SceneManager.get().set(ETFScenesNames.play);
        }
    }

    public override void onDraw() {
        BGNightSky.draw();
        titleTexture.draw();

        startText.draw();
        transitions.draw();
    }
}
