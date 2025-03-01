module data.user;

import parin;

import std.file;
import std.stdio;

enum path = "assets/data/user.bin";

struct UserData {
    @disable this();
    static:

    ushort bestScore = 0;
    ushort currScore = 0;
    bool haveLetter = false;

    void load() {
        
        if (exists(path)) {
            File file = File(path, "rb");
            
            file.rawRead((&bestScore)[0..1]);
            file.rawRead((&haveLetter)[0..1]);
            writeln((&bestScore)[0..1]);

            file.close();
        }
    }

    void save() {
        File file = File(path, "wb");
        if (!file.isOpen()) return;

        file.rawWrite((&bestScore)[0..1]);
        file.rawWrite((&haveLetter)[0..1]);
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

    void giveTrophy() {
        haveLetter = true;
    }

    bool hasNewRecord() {
        return currScore > bestScore;
    }

    bool canClean() {
        return bestScore != 0;
    }
}