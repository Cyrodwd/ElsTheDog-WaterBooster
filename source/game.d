module game;

import parin;
import skyentity;

import scenes.playscene;
import scenes.menuscene;
import managers.scene;
import managers.texture;
import managers.text;

struct Game
{
    void start() {
        FontManager.setup();

        SceneManager.get().add("PlayScene", new PlayScene());
        SceneManager.get().add("MenuScene", new MenuScene());

        TextureManager.getInstance().add("uiBar", "ui/uiBar.png");
        TextureManager.getInstance().add("ElsAtlas", "Els.png"); 
        TextureManager.getInstance().add("FlaskAtlas", "AdvantageFlask.png");
        TextureManager.getInstance().add("FireTear", "FireTear.png");

        TextureManager.getInstance().add("NightBg", "NightBG.png");

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
        TextureManager.getInstance().clear();
        SceneManager.get().clear();
    }
}
