module managers.text;

import parin.engine;
import joka.io : println;

struct FontManager
{
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

struct Text
{
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

    void draw() {
        drawText(FontManager.get(), text, position, drawOptions);
    }
}