module managers.resources;

import parin;
import scenes;
import managers;
import data.constants : ETFScenesNames;
struct ResourceManager
{
    @disable this();

    static:

    void loadSentities() {
        const IStr mainPath = "sentity/{}";

        TextureManager.getInstance().add("FireTear", format(mainPath, "FireTear.png"));
        TextureManager.getInstance().add("MarsMeteorite", format(mainPath, "MarsMeteorite.png"));

        // Texture for Advantage Flasks (all share the same, but with different colors)
        TextureManager.getInstance().add("FlaskAtlas", format(mainPath, "AdvantageFlask.png"));
        TextureManager.getInstance().add("ElsAtlas", format(mainPath, "Els.png")); // Not a sky entity, just entity lmao
        TextureManager.getInstance().add("SAWarning", format(mainPath, "Warning.png"));
    }

    void loadUiResources() {
        const IStr mainPath = "ui/{}"; // Folder where ui-based textures are stored
        const IStr iconsPath = format(mainPath, "introIcons/{}");
        const IStr textPath = format(mainPath, "text/{}");
        // UI bar (base) to display Health, Points/Name of Advantage Flask obtained and Fuel.
        TextureManager.getInstance().add("uiBar", format(mainPath, "uiBar.png"));
        
        TextureManager.getInstance().add("TitleTexture", format(textPath, "title.png"));
        TextureManager.getInstance().add("PauseTexture", format(textPath, "pause.png"));
        TextureManager.getInstance().add("WBNotSafeTexture", format(textPath, "testFailed.png"));
        TextureManager.getInstance().add("WBRejectedText", format(textPath, "rejected.png"));
        TextureManager.getInstance().add("ApprovedText", format(textPath, "approved.png"));

        // Intro icons
        TextureManager.getInstance().add("ParinLogo", format(iconsPath, "parin.png"));
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

        SceneManager.get().add(ETFScenesNames.approved, new ApprovedScene());

        SceneManager.get().add(ETFScenesNames.rejected, new RejectedScene());
    }
}