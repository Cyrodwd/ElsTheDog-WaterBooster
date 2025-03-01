module data.attempts;

import parin;

import std.file;
import std.stdio;

enum path = "assets/data/attempts.bin";

struct AttemptsData {
    @disable this();
    static:

    ushort deaths = 0;
    ushort surrenders = 0;

    void load() {
        if (exists(path)) {
            File file = File(path, "rb");
            auto data = file.rawRead(new ushort[2]);
            file.close();

            if (data.length == 2) {
                deaths = data[0];
                surrenders = data[1];
            }
        }
    }

    void save() {
        File file = File(path, "wb");
        if (!file.isOpen()) return;
        
        file.rawWrite([deaths, surrenders]);
        file.close();
    }

    void add(bool isDeath) {
        if (isDeath && deaths < 9999) deaths++;
        else if (surrenders < 9999) surrenders++;
    }

    bool canClean() {
        return deaths != 0 || surrenders != 0;
    }
}