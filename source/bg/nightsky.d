module bg.nightsky;

import parin : Vec2, DrawOptions, TextureId, drawTexture;
import managers : TextureManager;
import constants : ETFApplication;

struct BGNightSky {
    @disable this();
    static:

    float scrollSpeed;
    Vec2 position, clonePosition;
    DrawOptions drawOptions;
    TextureId texture;

    void start() {
        position = Vec2.zero;
        clonePosition = Vec2(ETFApplication.width, 0);
        scrollSpeed = 450.0f;
        
        // 1280x960 lmao
        drawOptions.scale = Vec2(2);
        texture = TextureManager.getInstance().get("NightSkyBackground");
    }

    void update(float dt) {
        position.x -= scrollSpeed * dt;

        if (position.x <= -ETFApplication.width)
            position.x = 0.0f;
            
        clonePosition.x = position.x + ETFApplication.width;
    }

    void draw() {
        // First copy
        drawTexture(texture, position, drawOptions);
        // Second copy
        drawTexture(texture, clonePosition, drawOptions);
    }
}