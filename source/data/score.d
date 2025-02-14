module data.score;

import parin;

import std.file;
import std.stdio;

enum path = "assets/data/best.bin";

struct ScoreData {
    @disable this();
    static:

    ushort bestScore = 0;
    ushort currScore = 0;

    void load() {
        if (exists(path)) {
            File file = File(path, "rb");
            auto data = file.rawRead(new ushort[1]);
            file.close();

            if (data.length == 1)
               bestScore = data[0];
        }
    }

    void save() {
        File file = File(path, "wb");
        if (!file.isOpen()) return;

        file.rawWrite([bestScore]);
        file.close();
    }

    void setScore(ushort nscore) {
        currScore = nscore;
    }

    void applyBestScore() {
        if (hasNewRecord()) {
            bestScore = currScore;
            save();
        }
    }

    bool hasNewRecord() {
        return currScore > bestScore;
    }

    bool canClean() {
        return bestScore != 0;
    }
}