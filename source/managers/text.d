module managers.text;

import parin.engine;
import joka.io : println;

struct FontManager {
    @disable this();
    
    static:

    private FontId font;

    void setup() {
        font = loadFont("fonts/ToonAround.otf", 70, 3, 5);
    }

    /// Get the font (Toon Around)
    FontId get() {
        return font;
    }

    uint size() {
        return font.size();
    }

    void free() {
        font.free();
    }
}

struct Text {
    IStr text;
    Vec2 position;
    DrawOptions drawOptions;

    this(IStr text, Vec2 position, Color color) {
        this.text = text;
        this.position = position;
        drawOptions.color = color;
    }

    void setText(IStr newText) {
        if (text != newText)
            text = newText;
    }

    void setColor(Color color) {
        drawOptions.color = color;
    }

    void setPosition(Vec2 position) {
        this.position = position;
    }

    void draw() {
        drawText(FontManager.get(), text, position, drawOptions);
    }
}

struct WaveText {
    static immutable float maxTime = 2 * pi;

    float time;
    float baseY;
    float offset;
    float amplitude;

    Vec2 position;
    Text text;

    this(IStr str, Vec2 origin, Color color, float amplitude) {
        position = origin;
        text = Text(str, origin, color);

        baseY = origin.y;
        offset = 0.0f;
        time = 0.0f;
        this.amplitude = amplitude;
    }

    void update(float dt) {
        time += dt;
        time = fmod(time, maxTime);

        offset = sin(time * 2.0f) * amplitude;
        position.y = baseY + offset;

        text.setPosition(position);
    }

    void draw() {
        text.draw();
    }
}