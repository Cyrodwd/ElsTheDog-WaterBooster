module managers.texture;

import parin.engine;
import parin : format, println;

final class TextureManager {
    private static TextureManager instance;
    private TextureId[IStr] textures;

    private this() { }

    public static TextureManager getInstance() {
        if (instance is null)
            instance = new TextureManager();

        return instance;
    }

    public TextureId get(IStr name) {
        if (name !in textures)
            assert(0, format("{} does not exists in textures.", name));

        if (!textures[name].isValid())
            assert(0, format("{} is not loaded."));

        return textures[name];
    }

    /// Loads a PNG image file inside 'images' folder.
    public void add(IStr name, IStr filename) {
        if (name.length == 0 || filename.length == 0)
            assert(0, "Name or filename are empty.");
        
        if (name in textures) return;

        textures[name] = loadTexture(format("sprites/{}", filename));
        if (!textures[name].isValid())
            assert(0, format("{} is not a valid image."));
    }

    public void remove(IStr name) {
        if (name !in textures)
            assert(0, format("{} is not a texture."));

        if (!textures[name].isValid())
            assert(0, format("{} is not stored."));

        textures[name].free();
        textures.remove(name);
    }

    public void clear() {
        foreach (IStr id ; textures.byKey)
            remove(id);
    }
}

struct WaveTexture
{
    float time;
    DrawOptions drawOptions;

    Vec2 position;
    TextureId texture;

    this(IStr name, Vec2 origin) {
        drawOptions.scale = Vec2(2.0f);

        texture = TextureManager.getInstance().get(name);
        position = origin;
        time = 0.0f;
    }

    void update(float dt) {
        time += dt;
        time = fmod(time, 2 * pi);

        const float offset = sin(time * 2.0f) * 40.0f;
        position.y = offset;
    }

    void draw() {
        drawTexture(texture, position,  drawOptions);
    }
}