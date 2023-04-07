/**
 * Instantiates a player.
 * Tracks location in world coordinates and provides actions the player can take.
 * Also loops through sprites to animate itself while moving or idling.
 */
 enum state {
    IDLE,
    RUN,
    JUMP,
    SWIM,
    CLIMB
};

class Player {
    PImage sprite_sheet;
    PImage sprite;
    int x_location;
    int y_location;
    int direction;
    state current_state; 

    Player() {
        this.x_location = 0;
        this.y_location = 0;
        this.direction = 0;
        this.current_state = state.IDLE;
        loadPlayer();
    }

    void loadPlayer() {
        // load sprite sheet 
        this.sprite_sheet = loadImage("mystic_woods_free_2.1/sprites/characters/player.png");
    }

    void loadSprite() {
        switch(current_state) {
            case IDLE:
                break;
            case RUN:
                break;
            case JUMP:
                break;
            case SWIM:
                break;
            case CLIMB:
                break;
            default:
                break;
        }
    }

    void set_x(int x) {
        this.x_location = x;
    }

    void set_y(int y) {
        this.y_location = y;
    }

    void set_direction(int dir) {
        this.direction = dir;
    }

    void set_state(state current) {
        this.current_state = current;
    }

    void drawPlayer() {
        image(sprite, x_location, y_location);
    }
}