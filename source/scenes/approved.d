module scenes.approved;

import parin;

import scenes.iscene;
import data.constants;
import data.score;

import managers.text;
import managers.scene;
import managers.transition;
import managers.texture : WaveTexture;

final class ApprovedScene : IScene {
    private static toMenuPosition = Vec2(-20, ETFSprite.size * 2.0f);
    private static approvedPosition = Vec2(ETFApplication.resolution.x - (ETFSprite.size + 80), ETFSprite.size);

    private bool switching;
    private WaveText toMenu;
    private WaveTexture approvedTexture;
    private TransitionManager transitions;

    public void onStart() {
        switching = false;
        transitions = TransitionManager(1.5f);
        transitions.playTransition(Transition.fadeIn);

        approvedTexture = WaveTexture("ApprovedText", approvedPosition, 45.3f);
        toMenu = WaveText(format("Press {} to confirm", ETFKeys.confirmStr()), toMenuPosition, white,
            41.3f, Alignment.right);
    }

    public void onUpdate(float dt) {
        transitions.update(dt);

        approvedTexture.update(dt);
        toMenu.update(dt);

        if (transitions.canTransition() && isPressed(ETFKeys.confirm)) {
            transitions.playTransition(Transition.fadeOut);
            switching = true;
        }

        if (switching) {
            if (transitions.canTransition()) { 
                ScoreData.applyBestScore();
                SceneManager.get().set(ETFScenesNames.menu);
            }
        }
    }

    public void onDraw() {
        approvedTexture.draw();
        toMenu.draw();

        transitions.draw();
    }
}
