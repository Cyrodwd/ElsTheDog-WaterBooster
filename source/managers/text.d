module managers.text;

import parin;
import data.constants;

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
    TextOptions textOptions;

    this(IStr text, Vec2 position, Color color, Alignment alignment = Alignment.left) {
        this.text = text;
        this.position = position;

        drawOptions.color = color;
        textOptions.alignment = alignment;
        textOptions.alignmentWidth = ETFApplication.resolution.x;
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

    void setAlpha(float alpha) {
        drawOptions.color.a = cast(ubyte)(alpha * 255);
    }

    void draw() const {
        drawText(FontManager.get(), text, position, drawOptions, textOptions);
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

    void setAmplitude(float amplitude) {
        this.amplitude = amplitude;
    }

    void setPosition(Vec2 position) {
        text.setPosition(position);
    }

    void setColor(Color color) {
        text.setColor(color);
    }

    void setText(IStr text) {
        this.text.setText(text);
    }

    void setAlpha(float alpha) {
        text.setAlpha(alpha);
    }
}