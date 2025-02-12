module data.score;

import parin;

import std.file;
import std.stdio;

enum path = "assets/data/best.bin";

struct ScoreData {
    @disable this();
    static:

    ushort bestScore = 0;
    ushort prevBestScore = 0;
    ushort currScore = 0;

    void load() {
        if (exists(path)) {
            File file = File(path, "rb");
            auto data = file.rawRead(new ushort[1]);
            file.close();

            if (data.length == 1)
               prevBestScore = bestScore = data[0];
        }
    }

    void save() {
        File file = File(path, "wb");
        if (!file.isOpen()) return;

        file.rawWrite([bestScore]);
        file.close();
    }

    void setBestScore(ushort nscore) {
        currScore = nscore;
        if (nscore > bestScore) {
            bestScore = nscore;
            save();
        }
    }

    void applyBestScore() {
        if (bestScore > prevBestScore) prevBestScore = bestScore;
    }

    bool hasNewRecord() {
        return prevBestScore > 0 && currScore > prevBestScore;
    }
}