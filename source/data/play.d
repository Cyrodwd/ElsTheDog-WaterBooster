module data.play;

import player;
import joka.colors;
import managers.score;

import sentity.data;
import sentity.aflask;

struct FlaskColors {
    @disable this();
    static:

    enum Color water = Color(164, 244, 249);
    enum Color health = Color(255, 139, 139);
    enum Color score = Color(249, 244, 198);
}

struct FlasksEffects {
    @disable this();
    // Pointers lmao
    static:

    ScoreManager* scoreManager;
    Player* els;

    void setup(ScoreManager* scoreManager, Player* els) {
        this.scoreManager = scoreManager;
        this.els = els;
    }

    void water() { els.getBooster().addFuel(10.0f); }
    void health() { els.addHealth(15); }
    void score() { scoreManager.add(100); }
}

struct FlasksBaseConfig {
    @disable this();
    static:

    SEConfig waterFlask = SEConfig(SEDirection.vertical, 440.2f, "+WATER");
    SEConfig healthFlask = SEConfig(SEDirection.horizontal, 611.45f, "+HEALTH");
    SEConfig scoreFlask = SEConfig(SEDirection.vertical, 578.5f, "+SCORE");
}

struct FlasksConfig {
    @disable this();

    static:

    AFlaskConfig waterFlask = AFlaskConfig(FlaskColors.water, rarityRate: 56, 5.6f, &FlasksEffects.water);
    AFlaskConfig healthFlask = AFlaskConfig(FlaskColors.health, rarityRate: 61, 8.3f, &FlasksEffects.health);
    AFlaskConfig scoreFlask = AFlaskConfig(FlaskColors.score, rarityRate: 35, 12.7f, &FlasksEffects.score);
}