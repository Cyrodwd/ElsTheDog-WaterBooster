module data.intro;

import joka.math : Vec2;
import joka.types : IStr;
import data.constants : ETFApplication;

struct IntroSplash {
    @disable this();
    static:

    immutable IStr text = "If you read this, you have just read.";
    immutable float amplitude = 30.5f;
}

struct IntroPosition {
    @disable this();
    static:

    immutable Vec2 parin = Vec2(ETFApplication.resolution.x / 2.0f - 128.0f,  128.0f);
    immutable Vec2 devText = Vec2(0.0f, 64.0f);
    immutable Vec2 splashText = Vec2(0, ETFApplication.resolution.y / 2.0f + 20.0f);
}