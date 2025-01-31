module data.play.anomaly;

import sentity.data;
import sentity.anomaly : AnomalyConfig;

struct AnomaliesBaseConfig
{
    @disable this();
    static:

    SEConfig fireTear = SEConfig(SEDirection.horizontal, 441.2f, "FireTear");
    SEConfig umoonRock = SEConfig(SEDirection.vertical, 547.45f, "UnknownMoonRock");
}

struct AnomaliesConfig
{
    @disable this();
    static:

    /// Fire Tear (Blue)
    AnomalyConfig fireTear = AnomalyConfig(12U, 4U, 3.7f);
    /// Unknown Moon Rock
    AnomalyConfig umoonRock = AnomalyConfig(23U, 12U, 6.13f);
}