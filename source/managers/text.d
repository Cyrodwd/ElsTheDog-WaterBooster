module managers.text;

import parin.engine;
import joka.io : println;
import constants;

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

    this(IStr text, Vec2 position, Color color, Alignment alignment = Alignment.left) {
        this.text = text;
        this.position = position;

        drawOptions.color = color;
        drawOptions.alignment = alignment;
        drawOptions.alignmentWidth = ETFApplication.resolution.x;
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

    void setScale(Vec2 scale) {
        drawOptions.scale = scale;
    }

    void draw() const {
        drawText(FontManager.get(), text, position, drawOptions);
    }
}

struct WaveText {
    static immutable float maxTime = 2 * pi;

    float time;
    float baseY;
    float offset;
    float amplitude;

    Text text;
    Vec2 position;

    this(IStr str, Vec2 origin, Color color, float waveAmplitude, Alignment alignment = Alignment.left) {
        position = origin;
        text = Text(str, origin, color, alignment);

        time = 0.0f;
        offset = 0.0f;
        baseY = origin.y;
        amplitude = waveAmplitude;
    }

    void update(float dt) {
        time += dt;
        time = fmod(time, maxTime);

        offset = sin(time * 2.0f) * amplitude;
        position.y = baseY + offset;

        text.setPosition(position);
    }

    void draw() const {
        text.draw();
    }

    void setText(IStr text) {
        this.text.setText(text);
    }
}