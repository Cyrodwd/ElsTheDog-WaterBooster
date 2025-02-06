module sentity.sanomaly;

import parin;
import sentity.data;

struct SAnomalyConfig {
    SEDirection direction;
    float spawnTime;
    Color color;
}

/// Unlike standard anomalies, these one are just a bar.
struct SAnomaly {
    SEDirection direction;
    SEState state;

    Rect rect;
    Timer spawnTimer;
    DrawOptions drawOptions;

    this(SEDirection direction, float spawnTime, Color color) {
        this.direction = direction;
        spawnTimer = Timer(spawnTime);

        state = SEState.respawn;
        spawnTimer.start();
    }

    void update(float dt) {
        final switch(state) {
            case SEState.respawn: updateRespawn(dt); break;
            case SEState.enabled: updateActive(dt); break;
            case SEState.collide: break; // No.
        }
    }

    void draw() const {
        drawRect(rect, drawOptions.color);
    }
    
    private void updateActive(float dt) {
        // TODO
    }

    private void updateRespawn(float dt) {
        // TODO
    }

    private void reset() {
        // TODO
    }
}