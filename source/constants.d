module constants;
import parin : Vec2, Rect;

struct ETFResolution {
    @disable this();

    enum width = 1280;
    enum height = 920;
}

struct ETFUi {
    @disable this();
    enum buttonSize = Vec2(512, 128);
    enum charSize = 15;
}

struct ETFSprite {
    @disable this();
    
    enum size = 256;

    static Vec2 getOffset(const Vec2 rectSize) {
        return (Vec2(size) - rectSize) / Vec2(2);
    }
}