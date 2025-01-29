module managers.transition;

import parin;
import data.constants;

enum Transition {
    none,
    fadeIn,
    fadeOut
}

struct TransitionManager
{
    // A struct 'IRect' would not be a bad thing
    Color rectColor;
    float alpha;
    Rect rect;

    Timer timer;
    Transition transition;

    this(float transitionTime) {
        timer = Timer(transitionTime);

        // "resolution" is a constant of type IVec2
        rect = Rect(Vec2.zero, Vec2(ETFApplication.resolution.x, ETFApplication.resolution.y));
        rectColor = black;
        transition = Transition.none;
    }

    void update(float dt) {
        if (transition != Transition.none) {
            timer.update(dt);

            if (transition == Transition.fadeIn) updateFadeIn();
            else if (transition == Transition.fadeOut) updateFadeOut();

            rectColor.a = cast(ubyte)(alpha * 255);
            if (timer.hasStopped()) { transition = Transition.none; }
        }
    }

    void draw() const {
        drawRect(rect, rectColor);
    }

    void setDuration(float time) {
        if (time <= 0.0f) return;

        timer.duration = time;
    }

    void playTransition(Transition transition) {
        if (transition == Transition.none || this.transition != Transition.none) return;

        this.transition = transition;
        timer.start();
    }

    bool canTransition() const {
        return transition == Transition.none || rectColor.a == 255;
    }

    Transition getTransition() const {
        return transition;
    }

    private void updateFadeIn() {
        alpha = 1.0f - (timer.time / timer.duration);
    }

    private void updateFadeOut() {
        alpha = (timer.time / timer.duration);
    }
}