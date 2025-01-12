module managers.resources;

import parin;
import managers;

import scenes.menuscene;
import scenes.pausescene;
import scenes.playscene;

struct ResourceManager
{
    @disable this();

    static:

    void loadAnomalyResources() {
        TextureManager.getInstance().add("FireTear", "FireTear.png");
    }

    void loadAtlases() {
        TextureManager.getInstance().add("ElsAtlas", "Els.png"); 
        TextureManager.getInstance().add("FlaskAtlas", "AdvantageFlask.png");
    }

    void loadUiResources(IStr folderName) {
        TextureManager.getInstance().add("uiBar", format("{}/uiBar.png", folderName));
    }

    void loadBackgrounds() {
        // Gameplay
        TextureManager.getInstance().add("NightBg", "NightBG.png");
    }

    void setupScenes() {
        SceneManager.get().add("PlayScene", new PlayScene());
        SceneManager.get().add("MenuScene", new MenuScene());
        SceneManager.get().add("PauseScene", new PauseScene());
    }
}