module managers.music;

import parin;

struct MusicManager {
    @disable this();

    static:

    private SoundId[IStr] sounds;

    void add(IStr name, IStr filename) {
        if (name.length == 0 || filename.length == 0)
            assert(0, "Name or filename is empty");
        
        if (name in sounds) return;

        sounds[name] = loadSound(format("audio/msx/{}", filename), 1.0f, 1.0f);
        
        if (!sounds[name].isValid())
            assert(0, format("{} is not a valid music.", name));
    }

    void remove(IStr name) {
        if (name !in sounds)
            assert(0, format("{} is not a stored.", name));

        if (!sounds[name].isValid())
            assert(0, format("{} is not a valid music.", name));

        sounds[name].free();
        sounds.remove(name);
    }

    SoundId get(IStr name) {
        if (name !in sounds)
            assert(0, format("{} is not a valid image.", name));
        
        return sounds[name];
    }

    void clear() {
        foreach (IStr id ; sounds.byKey)
            remove(id);
    }

    void play(IStr name) {
        if (name !in sounds)
            assert(0, format("{} does not exist.", name));

        playSound(sounds[name]);
    }

    void update(IStr name) {
        if (name !in sounds)
            assert(0, format("{} does not exist.", name));

        updateSound(sounds[name]);
    }

    void stop(IStr name) {
        if (name !in sounds)
            assert(0, format("{} does not exist.", name));

        stopSound(sounds[name]);
    }

    void setVolume(IStr name, float volume) {
        if (name !in sounds)
            assert(0, format("{} does not exist.", name));

        sounds[name].getOr().setVolume(volume);
    }
}