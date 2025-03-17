module data.play.anomaly;

import joka.math;
import sentity.data;
import sentity.anomaly : AnomalyConfig;

struct AnomaliesColors {
    @disable this();
    static const:

    Color fireTear = Color(164, 181, 254);
    Color fireTearAlt = Color(128, 0, 0);
    Color fastTear = Color(230, 190, 138, 128); // alpha non-accidental
    Color acidFlask = Color(50, 205, 50);
}

struct AnomaliesBaseConfig
{
    @disable this();
    static const:

    SEConfig fireTear = SEConfig(SEDirection.horizontal, 441.2f, "FireTear",);
    SEConfig fastTear = SEConfig(SEDirection.vertical, 633.5f, "FireTear");
    SEConfig meteorite = SEConfig(SEDirection.vertical, 547.45f, "MarsMeteorite");
    SEConfig acidFlask = SEConfig(SEDirection.horizontal, 361.72f, "FlaskAtlas"); // Yeah
}

struct AnomaliesConfig
{
    @disable this();
    static const:

    /// Fire Tear (Blue)
    AnomalyConfig fireTear = AnomalyConfig(11U, 4U, 3.7f, AnomaliesColors.fireTear);
    /// Fire Tear but faster lol
    AnomalyConfig fastTear = AnomalyConfig(15U, 4U, 5.3f, AnomaliesColors.fastTear);
    /// Unknown Moon Rock
    AnomalyConfig meteorite = AnomalyConfig(18U, 12U, 6.13f);
    /// Acid Flask
    AnomalyConfig acidFlask = AnomalyConfig(21U, 8U, 4.0f, AnomaliesColors.acidFlask);
}

struct AnomaliesBHConfig {
    @disable this();
    static const:

    SEConfig fireTear = SEConfig(SEDirection.horizontal, 500.1f, "FireTear");
    SEConfig fastTear = SEConfig(SEDirection.horizontal, 661.4f, "FireTear");
    SEConfig meteorite = SEConfig(SEDirection.vertical, 612.2f, "MarsMeteorite");
    SEConfig acidFlask = SEConfig(SEDirection.horizontal, 411.4f, "FlaskAtlas");
}

struct AnomaliesHardConfig {
    @disable this();
    static const:

    AnomalyConfig fireTear = AnomalyConfig(22U, 4U, 2.1f, AnomaliesColors.fireTearAlt);
    AnomalyConfig fastTear = AnomalyConfig(18U, 4U, 3.6f, AnomaliesColors.fastTear);
    AnomalyConfig meteorite = AnomalyConfig(24U, 12U, 3.66f);
    AnomalyConfig acidFlask = AnomalyConfig(27U, 8U, 2.6f, AnomaliesColors.acidFlask);
}