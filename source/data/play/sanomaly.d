module data.play.sanomaly;

import joka.colors;
import sentity.data;
import sentity.sanomaly;

/** 
 * Static Anomalies:
 *   - Thunder (30, 38, 15.0, 1.2, 0.5, 5.8, V)
 *   - RL (48, 24, 3.5, 2.3, 1.5, 3.11, H)
 *   - 
 */

struct PSAValues {
    @disable this();
    static immutable:

    SANumbers thunder = SANumbers(rarity: 30, damage: 38, size: 15.0f);
    SANumbers randomLaser = SANumbers(rarity: 48, 24, 3.5f);
}

struct PSATimes {
    @disable this();
    static immutable:

    SATimes thunder = SATimes(spawn: 1.2f, active: 0.5f, wait: 5.8f);
    SATimes randomLaser = SATimes(spawn: 2.3f, active: 1.5f, wait: 3.11f);
}

private struct PSAColors {
    @disable this();
    static immutable:

    Color thunder = yellow;
    Color randomLaser = red;
}

struct PSAConfigs {
    @disable this();
    static immutable:

    SAConfig thunder = SAConfig(SEDirection.vertical, PSAColors.thunder);
    SAConfig randomLaser = SAConfig(SEDirection.horizontal, PSAColors.randomLaser);
}