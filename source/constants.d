module constants;
import parin : Color, IVec2, Vec2, Rect, Keyboard;
struct ETFApplication {
    @disable this();

    enum resolution = IVec2(1280, 960);
    enum title = "Els The Fox: Magma Booster ~ Cyrodwd";
}

struct ETFUi {
    @disable this();

    enum charSize = 15;
    enum cherryColor = Color(222, 49, 99, 255);
    alias confirmKey = Keyboard.space;
    alias denyKey = Keyboard.esc;
}

struct ETFSprite {
    @disable this();
    
    enum size = 256;

    static Vec2 getOffset(const Vec2 rectSize) {
        return (Vec2(size) - rectSize) / Vec2(2);
    }
}