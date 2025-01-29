module scenes.intro;

import parin;
import data.constants;

import scenes.iscene;
import managers.text, managers.scene, managers.texture;
import managers.transition;

final class IntroScene : IScene
{
    immutable Vec2 parinPosition = Vec2(ETFApplication.resolution.x / 2.0f - 128.0f,  128.0f);
    immutable Vec2 devTextPosition = Vec2(0.0f, 64.0f);
    immutable Vec2 authorTextPosition = Vec2(0, ETFApplication.resolution.y / 2.0f - 10);

    Timer toMenuTimer;

    TextureId parinLogo;

    Text devText;
    Text authorText;
    TransitionManager transitions;
    bool transitioningToMenu;

    public void onStart() {
        parinLogo = TextureManager.getInstance().get("ParinLogo");

        devText = Text("Made with parin", devTextPosition, white, Alignment.center);
        authorText = Text("@Cyrodwd: Programming", authorTextPosition, white, Alignment.center);

        transitions = TransitionManager(transitionTime: 3.0f);

        // Technically its real duration is 8.0 seconds lmto.
        toMenuTimer = Timer(11.0f);
        toMenuTimer.start();

        transitions.playTransition(Transition.fadeIn);
        transitioningToMenu = false;
    }

    public void onUpdate(float dt) {
        transitions.update(dt);
        if (!transitioningToMenu) {
            toMenuTimer.update(dt);

            if (transitions.canTransition() && (toMenuTimer.hasStopped() || isPressed(ETFUi.confirmKey))) {
                transitions.setDuration(time: 1.0f);
                transitions.playTransition(Transition.fadeOut);
                transitioningToMenu = true;
            }
        } else {
            if (transitions.canTransition()) {
                SceneManager.get().set(ETFScenesNames.menu);
            }
        }
    }

    public void onDraw() {
        drawTexture(parinLogo, parinPosition);

        devText.draw();
        authorText.draw();

        transitions.draw();
    }
}