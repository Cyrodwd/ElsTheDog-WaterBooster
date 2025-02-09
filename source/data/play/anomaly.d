module data.play.anomaly;

import joka.colors;
import sentity.data;
import sentity.anomaly : AnomalyConfig;

struct AnomaliesColors {
    @disable this();
    static const:

    Color fireTear = Color(164, 181, 254);
    Color fastTear = Color(230, 190, 138, 128); // alpha non-accidental
    Color acidFlask = Color(50, 205, 50);
}

struct AnomaliesBaseConfig
{
    @disable this();
    static const:

    SEConfig fireTear = SEConfig(SEDirection.horizontal, 441.2f, "FireTear",);
    SEConfig fastTear = SEConfig(SEDirection.horizontal, 633.5f, "FireTear");
    SEConfig meteorite = SEConfig(SEDirection.vertical, 547.45f, "MarsMeteorite");
    SEConfig acidFlask = SEConfig(SEDirection.vertical, 361.72f, "FlaskAtlas"); // Yeah
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
    AnomalyConfig acidFlask = AnomalyConfig(27U, 8U, 4.0f, AnomaliesColors.acidFlask);
}