module game;

import managers;
import bg.nightsky;
import data.constants : ETFScenesNames;
import parin : isPressed, toggleIsFullscreen, Keyboard;

struct Game
{
    void start() {
        FontManager.setup();

        ResourceManager.loadSentities();

        ResourceManager.loadBackgrounds();
        ResourceManager.loadUiResources();
        
        ResourceManager.setupScenes();

        // This is weird
        BGNightSky.start();

        SceneManager.get().set(ETFScenesNames.intro);
    }

    bool update(float dt) {
        if (isPressed(Keyboard.f)) toggleIsFullscreen();
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
