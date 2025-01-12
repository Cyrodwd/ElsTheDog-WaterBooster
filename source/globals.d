module globals;
import parin : Vec2, Rect;

public {
    struct ETFResolution {
        enum width = 1280;
        enum height = 920;
    }

    struct ETFUi {
        enum buttonSize = Vec2(512, 128);
    }

    enum spriteSize = 256;
    enum spriteSizeVec = Vec2(spriteSize);

    Vec2 getSpriteHitboxOffset(const Vec2 rectSize) {
        return ( spriteSizeVec - rectSize ) / Vec2(2);
    }
}