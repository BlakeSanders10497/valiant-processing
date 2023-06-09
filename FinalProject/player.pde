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

    // player constructor, sets the player states and loads in all necessary files to draw it
    Player() {
        this.direction = Direction.DOWN;
        this.state = State.IDLE;
        this.spriteSheet = loadImage(spriteSheetPath);
        this.flippedSheet = loadImage(flippedSheetPath);
        loadAnimations();
        updateAnimation();
    }

    // gets the image of the flipped sprite
    PImage getFlippedSprite(int row, int col) {
        return flippedSheet.get(col * spriteW, row * spriteH, spriteW, spriteH);
    }

    // gets the image of the sprite
    PImage getSprite(int row, int col) {
        return spriteSheet.get(col * spriteW, row * spriteH, spriteW, spriteH);
    }

    // gets the sprite sheet of the flipped images
    PImage[] getFlippedSpriteSet(int row, int numSprites) {
        PImage[] set = new PImage[numSprites];

        for(int i = 0; i < numSprites; i++) {
            set[numSprites-i-1] = getFlippedSprite(row, i);
        }

        return set;
    }

    // gets the sprite sheet of the player images
    PImage[] getSpriteSet(int row, int numSprites) {
        PImage[] set = new PImage[numSprites];

        for(int i = 0; i < numSprites; i++) {
            set[i] = getSprite(row, i);
        }

        return set;
    }

    // loads in all the animations from the sprite sheets 
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
                    this.animation = swimRight;
                    break;
            }
        }
    }

    // sets the state to idle
    void idle() {
        this.state = State.IDLE;
    }

    // sets the state to jump
    void jump() {
        this.state = State.JUMP;
        startJumpTimer();
    }

    // sets the state to swim
    void swim() {
        this.state =State.SWIM;
    }

    // sets the players state to facing left
    void moveLeft() {
        // x -= vX;
        this.state = State.RUN;
        this.direction = direction.LEFT;
    }
    // sets the players state to facing up
    void moveUp() {
        // y -= vY;
        this.state = State.RUN;
        this.direction = direction.UP;
    }
    // sets the players state to facing right
    void moveRight() {
        // x += vX;
        this.state = State.RUN;
        this.direction = direction.RIGHT;
    }
    // sets the players state to facing down
    void moveDown() {
        // y += vY;
        this.state = State.RUN;
        this.direction = direction.DOWN;
    }
    // starts the time for the players jump duration
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

    // updates the player jump animation 
    void update() {
        if(state == State.JUMP) {
            jumpH = jumpHeight();
        } else {
            jumpH = 0;
        }

        updateAnimation();
    }

    // draws the player based on its animation state
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