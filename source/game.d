module game;

import managers;
import bg.nightsky;

import data.attempts;
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
        SceneManager.get().update(dt);
        return false;
    }

    void draw() {
        SceneManager.get().draw();
    }

    void free() {
        if (SceneManager.get().isOnScene(ETFScenesNames.play) || SceneManager.get().isOnScene(ETFScenesNames.pause)) {
            AttemptsData.add(isDeath: false);
            AttemptsData.save();
        }

        FontManager.free();
        SceneManager.get().clear();
        TextureManager.getInstance().clear();
    }
}
