module game;

import managers;
import backgrounds.nightsky;

import data.user;
import data.attempts;
import data.constants : ETFScenesNames, ETFKeys;

import joka.io : printfln;
import parin : isPressed, toggleIsFullscreen, Keyboard;

struct Game
{
    void start() {
        // Probably in future projects I won't load all the resources at once :|
        FontManager.setup();

        ResourceManager.loadSentities();
        ResourceManager.loadBackgrounds();

        ResourceManager.loadMusic();
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
        MusicManager.clear();
        TextureManager.getInstance().clear();
    }
}
