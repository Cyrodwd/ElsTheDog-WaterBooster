module constants;

import parin : Color, IVec2, Vec2, Rect, Keyboard;
import joka.colors : white;
import joka.types : IStr;
import core.atomic;

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

    static enum vTextOffset = ETFApplication.resolution.y - 85.0f;
    static enum defaultTextColor = white;
}

struct ETFSprite {
    @disable this();
    
    enum size = 256;

    static Vec2 getOffset(const Vec2 rectSize) {
        return (Vec2(size) - rectSize) / Vec2(2);
    }
}

struct ETFScenesNames {
    @disable this();

    enum IStr intro = "IntroScene";
    enum IStr menu = "MenuScene";
    enum IStr play = "PlayScene";
    enum IStr pause = "PauseScene";
    enum IStr gameOver = "GameOverScene";
}