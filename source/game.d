module game;

import managers;
import bg.nightsky;

struct Game
{
    void start() {
        FontManager.setup();

        ResourceManager.loadAnomalyResources();
        ResourceManager.loadAtlases();

        ResourceManager.loadBackgrounds();
        ResourceManager.loadUiResources();
        
        ResourceManager.setupScenes();

        // This is weird
        BGNightSky.start();

        SceneManager.get().set("MenuScene");
    }

    bool update(float dt) {
        SceneManager.get().update(dt);
        return false;
    }

    void draw() {
        SceneManager.get().draw();
    }

    void free() {
        FontManager.free();
        SceneManager.get().clear();
        TextureManager.getInstance().clear();
    }
}
