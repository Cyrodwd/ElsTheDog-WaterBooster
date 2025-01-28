module managers.resources;

import parin;
import scenes;
import managers;
import constants : ETFScenesNames;

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
        const IStr mainPath = "ui/{}"; // Folder where ui-based textures are stored
        const IStr iconsPath = format(mainPath, "introIcons/{}");
        // UI bar (base) to display Health, Points/Name of Advantage Flask obtained and Fuel.
        TextureManager.getInstance().add("uiBar", format(mainPath, "uiBar.png"));
        
        TextureManager.getInstance().add("Title", format(mainPath, "title.png"));
        TextureManager.getInstance().add("PauseTexture", format(mainPath, "pause.png"));
        TextureManager.getInstance().add("TestFailedTexture", format(mainPath, "testFailed.png"));

        // Intro icons
        TextureManager.getInstance().add("ParinLogo", format(iconsPath, "parin.png"));
        TextureManager.getInstance().add("DlangLogo", format(iconsPath, "dlang.png"));
    }

    void loadBackgrounds() {
        // Backgrounds size: 640x480 (Half of 1280x960).
        const IStr mainPath = "bg/{}"; // Folder where backgrounds are stored
        // Background for PlayScene
        TextureManager.getInstance().add("NightSkyBackground", format(mainPath, "bgNightSky.png"));
        // Background for GameOverScene
        TextureManager.getInstance().add("ElsDeadBackground", format(mainPath, "bgGameOver.png"));
    }

    void setupScenes() {
        SceneManager.get().add(ETFScenesNames.intro, new IntroScene());

        SceneManager.get().add(ETFScenesNames.menu, new MenuScene());

        SceneManager.get().add(ETFScenesNames.play, new PlayScene());

        SceneManager.get().add(ETFScenesNames.pause, new PauseScene());

        SceneManager.get().add(ETFScenesNames.gameOver, new GameOverScene());
    }
}