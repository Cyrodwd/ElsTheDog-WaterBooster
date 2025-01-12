module managers.scene;

import parin;
import scenes.scene;

final class SceneManager
{
    private static SceneManager instance;
    private IScene[IStr] scenes;
    private IScene currentScene;

    private this() { currentScene = null; }

    public void clear() {
        scenes.clear();
        currentScene = null;
    }

    public static SceneManager get() {
        if (instance is null)
            instance = new SceneManager();
        return instance;
    }

    public void add(IStr name, IScene scene) {
        if (scene is null || name.length == 0)
            assert(0, "Scene is null or name is not valid.");

        scenes[name] = scene;
    }

    public void set(IStr name, bool refresh = true) {
        if (name !in scenes)
            assert(0, "Scene is not inside scenes map");

        currentScene = scenes[name];
        
        if (refresh) currentScene.onStart();
    }

    public void update(float dt) {
        currentScene.onUpdate(dt);
    }

    public void draw() {
        currentScene.onDraw();
    }
}