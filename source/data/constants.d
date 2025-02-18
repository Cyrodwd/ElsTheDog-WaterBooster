module data.constants;

import joka;
import joka.colors : white;
import parin : Color, IVec2, Vec2, Rect, Keyboard;

struct ETFApplication {
    @disable this();

    enum resolution = IVec2(1280, 960);
    enum title = "Els The Fox: Water Booster ~ Cyrodwd";
}

struct ETFUi {
    @disable this();

    enum charSize = 15;
    enum cherryColor = Color(222, 49, 99, 255);

    static enum vTextOffset = ETFApplication.resolution.y - 85.0f;
    static enum defaultTextColor = white;
}

struct ETFKeys {
    @disable this();
    static:

    alias confirm = Keyboard.space;
    alias deny = Keyboard.esc;

    alias pLeft = Keyboard.left;
    alias pRight = Keyboard.right;

    alias pBoost = Keyboard.z;
    alias pBoostDown = Keyboard.x;
    alias pExtra = Keyboard.c;

    IStr confirmStr() {
        return toStr(confirm);
    }

    IStr denyStr() {
        return toStr(deny);
    }
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
    enum IStr rejected = "WBRejected";
    enum IStr approved = "ApprovedScene";
}