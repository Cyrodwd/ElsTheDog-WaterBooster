module data.play.aflask;

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
    static:

    // Pointers lmao
    ScoreManager* scoreManager;
    Player* els;

    void setup(ScoreManager* scoreManager, Player* els) {
        this.scoreManager = scoreManager;
        this.els = els;
    }

    void water() { if (els !is null) els.getBooster().addFuel(10U); }
    void health() { if (els !is null) els.addHealth(15); }
    void score() { if (scoreManager !is null) scoreManager.add(100); }
}

struct FlasksBaseConfig {
    @disable this();
    static:

    SEConfig waterFlask = SEConfig(SEDirection.vertical, speed: 440.2f, name: "+WATER");
    SEConfig healthFlask = SEConfig(SEDirection.horizontal, speed: 611.45f, name: "+HEALTH");
    SEConfig scoreFlask = SEConfig(SEDirection.vertical, speed: 578.5f, name: "+SCORE");
}

struct FlasksConfig {
    @disable this();

    static:

    AFlaskConfig waterFlask = AFlaskConfig(FlaskColors.water, rarityRate: 23, respawnTime: 5.6f,
        effect: &FlasksEffects.water);
        
    AFlaskConfig healthFlask = AFlaskConfig(FlaskColors.health, rarityRate: 14, respawnTime: 8.3f,
        effect: &FlasksEffects.health);

    AFlaskConfig scoreFlask = AFlaskConfig(FlaskColors.score, rarityRate: 35, respawnTime: 12.7f,
        effect: &FlasksEffects.score);
}