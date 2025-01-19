module bg;

import parin;
import managers.texture;

struct Background
{
    DrawOptions options;

    Vec2 position;
    TextureId texture;
    /// Background texture should be the half of resolution (640x480)
    this(IStr name) {
        texture = TextureManager.getInstance().get(name);

        position = Vec2.zero;
        options = Vec2(2.0f);
    }

    void draw() const {
        drawTexture(texture, position, options);
    }
}