/**
 * Instantiates a player.
 * Tracks location in world coordinates and provides actions the player can take.
 * Also loops through sprites to animate itself while moving or idling.
 */


 enum State {
    IDLE,
    RUN,
    JUMP,
    SWIM,
    CLIMB
};

enum Direction {
    UP,
    DOWN,
    LEFT,
    RIGHT
};

class Player {
    PImage spriteSheet;
    PImage flippedSheet;
    Animation animation;

    Animation idleLeft, idleRight, idleUp, idleDown;
    Animation runLeft, runRight, runUp, runDown;
    Animation jumpLeft, jumpRight, jumpUp, jumpDown;
    Animation swimLeft, swimRight;

    // Global coordinates
    float x, y;
    
    // Player constants
    private final String spriteSheetPath    = "mystic_woods_free_2.1/sprites/characters/player.png";
    private final String flippedSheetPath   = "mystic_woods_free_2.1/sprites/characters/player-flipped.png";
    private final int spriteW = 288 / 6;
    private final int spriteH = 480 / 10;

    // Current player state
    State state;
    Direction direction;
    float jumpH = 0;
    int jumpStartTime = 0;

    Player(float x, float y) {
        this.x = x;
        this.y = y;
        this.direction = Direction.DOWN;
        this.state = State.IDLE;
        this.spriteSheet = loadImage(spriteSheetPath);
        this.flippedSheet = loadImage(flippedSheetPath);
        loadAnimations();
        updateAnimation();
    }

    PImage getFlippedSprite(int row, int col) {
        return flippedSheet.get(col * spriteW, row * spriteH, spriteW, spriteH);
    }

    PImage getSprite(int row, int col) {
        return spriteSheet.get(col * spriteW, row * spriteH, spriteW, spriteH);
    }

    PImage[] getFlippedSpriteSet(int row, int numSprites) {
        PImage[] set = new PImage[numSprites];

        for(int i = 0; i < numSprites; i++) {
            set[numSprites-i-1] = getFlippedSprite(row, i);
        }

        return set;
    }

    PImage[] getSpriteSet(int row, int numSprites) {
        PImage[] set = new PImage[numSprites];

        for(int i = 0; i < numSprites; i++) {
            set[i] = getSprite(row, i);
        }

        return set;
    }


    void loadAnimations() {
        idleLeft    = new Animation(getFlippedSpriteSet(1, 6));
        idleRight   = new Animation(getSpriteSet(1, 6));
        idleUp      = new Animation(getSpriteSet(2, 6));
        idleDown    = new Animation(getSpriteSet(0, 6));

        runLeft     = new Animation(getFlippedSpriteSet(4, 6));
        runRight    = new Animation(getSpriteSet(4, 6));
        runUp       = new Animation(getSpriteSet(5, 6));
        runDown     = new Animation(getSpriteSet(3, 6));

        jumpLeft    = new Animation(getFlippedSprite(4, 2));
        jumpRight   = new Animation(getSprite(4, 3));
        jumpUp      = new Animation(getSprite(5, 3));
        jumpDown    = new Animation(getSprite(3, 3));

        swimLeft    = new Animation(getFlippedSprite(9, 3), getFlippedSprite(9, 4));
        swimRight   = new Animation(getSprite(9, 1), getSprite(9, 2));
    }

    /** Updates the current sprite based off the player's direction and state.
     */
    void updateAnimation() {
        if(this.state == State.IDLE) {
            switch(direction) {
                case UP:
                    this.animation = idleUp;
                    break;
                case DOWN:
                    this.animation = idleDown;
                    break;
                case LEFT:
                    this.animation = idleLeft;
                    break;
                case RIGHT:
                    this.animation = idleRight;
                    break;
                default:
                    break;
            }
        } else if(this.state == State.RUN) {
            switch(direction) {
                case UP:
                    this.animation = runUp;
                    break;
                case DOWN:
                    this.animation = runDown;
                    break;
                case LEFT:
                    this.animation = runLeft;
                    break;
                case RIGHT:
                    this.animation = runRight;
                    break;
                default:
                    break;
            }
        } else if(this.state == State.JUMP) {
            switch(direction) {
                case UP:
                    this.animation = jumpUp;
                    break;
                case DOWN:
                    this.animation = jumpDown;
                    break;
                case LEFT:
                    this.animation = jumpLeft;
                    break;
                case RIGHT:
                    this.animation = jumpRight;
                    break;
                default:
                    break;
            }
        } else if(this.state == State.SWIM) {
            switch(direction) {
                case LEFT:
                    this.animation = swimLeft;
                    break;
                case RIGHT:
                    this.animation = swimRight;
                    break;
                default:
                    break;
            }
        }
    }

    void idle() {
        this.state = State.IDLE;
    }

    void jump() {
        this.state = State.JUMP;
        startJumpTimer();
    }

    void swim() {
        this.state =State.SWIM;
    }

    void moveLeft() {
        // x -= vX;
        this.state = State.RUN;
        this.direction = direction.LEFT;
    }
    void moveUp() {
        // y -= vY;
        this.state = State.RUN;
        this.direction = direction.UP;
    }
    void moveRight() {
        // x += vX;
        this.state = State.RUN;
        this.direction = direction.RIGHT;
    }
    void moveDown() {
        // y += vY;
        this.state = State.RUN;
        this.direction = direction.DOWN;
    }

    void startJumpTimer() {
        jumpStartTime = millis();
    }

    /** Return height as a quadratic function of time t.
     * function is of the form f(t) = h(1 - ((t-c)^2)/c^2)
     * @return the current height in the jump
     */
    float jumpHeight() {
        float c = 200;
        float t = millis() - jumpStartTime;
        float h = -20;
        
        float jumpDuration = 2*c;
        if(t > jumpDuration) state = State.IDLE;
        
        return h * (1 - (pow(t-c, 2) / pow(c, 2)));
    }

    void update() {
        if(state == State.JUMP) {
            jumpH = jumpHeight();
        } else {
            jumpH = 0;
        }

        updateAnimation();
    }

    void draw(float screenX, float screenY) {
        update();

        imageMode(CENTER);
        pushMatrix();
        translate(screenX, screenY);
        scale(2);
        animation.display(0, jumpH);
        popMatrix();
    }
}