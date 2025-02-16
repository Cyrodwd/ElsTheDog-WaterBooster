module scenes.intro;

import parin;
import data.constants;
import data.intro;

import scenes.iscene;
import managers.text, managers.scene, managers.texture;
import managers.transition;

final class IntroScene : IScene
{
    private bool transitioningToMenu;

    private Timer toMenuTimer;
    private TextureId parinLogo;
    private Vec2 parinPosition;

    private Text devText;
    private WaveText splashText;
    private TransitionManager transitions = TransitionManager(transitionTime: 3.0f);

    public void onStart() {
        parinLogo = TextureManager.getInstance().get("ParinLogo");
        parinPosition = IntroPosition.parin;

        devText = Text("Made with parin", IntroPosition.devText, white, Alignment.center);
        splashText = WaveText(IntroSplash.text, IntroPosition.splashText, pink, IntroSplash.amplitude,
            Alignment.center);

        // In reality, it will be 3 seconds
        toMenuTimer = Timer(6.0f);
        toMenuTimer.start();

        transitions.playTransition(Transition.fadeIn);
        transitioningToMenu = false;
    }

    public void onUpdate(float dt) {
        transitions.update(dt);
        splashText.update(dt);

        if (!transitioningToMenu) {
            toMenuTimer.update(dt);

            if (transitions.canTransition() && (toMenuTimer.hasStopped() || isPressed(ETFKeys.confirm))) {
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
        splashText.draw();

        transitions.draw();
    }
}