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
            assert(0, format("{}.png is not loaded."));

        return textures[name];
    }

    /// Loads a PNG image file inside 'images' folder.
    public void add(IStr name, IStr filename) {
        if (name.length == 0 || filename.length == 0)
            assert(0, "Name or filename are empty.");
        
        if (name in textures) return;

        textures[name] = loadTexture(format("sprites/{}", filename));
    }

    public void remove(IStr name) {
        if (name !in textures)
            assert(0, format("{} is not a texture."));

        if (!textures[name].isValid())
            assert(0, format("{}.png is not stored."));

        textures[name].free();
        textures.remove(name);
    }

    public void clear() {
        foreach (IStr id ; textures.byKey)
            remove(id);
    }
}
