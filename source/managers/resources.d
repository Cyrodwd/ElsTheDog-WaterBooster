module managers.resources;

import parin;
import managers;

import scenes.menuscene;
import scenes.pausescene;
import scenes.playscene;
import scenes.gameoverscene;

struct ResourceManager
{
    @disable this();

    static:

    void loadAnomalyResources() {
        TextureManager.getInstance().add("FireTear", "FireTear.png");
    }

    void loadAtlases() {
        // Texture Atlas of Els (Player)
        TextureManager.getInstance().add("ElsAtlas", "Els.png"); 

        // Texture for Advantage Flasks (all share the same, but with different colors)
        TextureManager.getInstance().add("FlaskAtlas", "AdvantageFlask.png");
    }

    void loadUiResources() {
        const IStr folderPath = "ui/{}"; // Folder where ui-based textures are stored
        // UI bar (base) to display Health, Points/Name of Advantage Flask obtained and Fuel.
        TextureManager.getInstance().add("uiBar", format(folderPath, "uiBar.png"));
    }

    void loadBackgrounds() {
        // Backgrounds size: 640x480 (Half of 1280x960).
        const IStr folderPath = "bg/{}"; // Folder where backgrounds are stored
        // Background for PlayScene
        TextureManager.getInstance().add("NightSkyBackground", format(folderPath, "bgNightSky.png"));
        // Background for GameOverScene
        TextureManager.getInstance().add("ElsDeadBackground", format(folderPath, "bgGameOver.png"));
    }

    void setupScenes() {
        SceneManager.get().add("PlayScene", new PlayScene());

        SceneManager.get().add("MenuScene", new MenuScene());

        SceneManager.get().add("PauseScene", new PauseScene());

        SceneManager.get().add("GameOverScene", new GameOverScene());
    }
}