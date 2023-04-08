/**
 * Holds the tilemap of the mountain and displays it to the screen.
 */

 class GameBoard {
    int height;
    int width;
    int x, y;
    int speed;
    PImage tilesheet; 
    int imgHeight;
    int imgWidth;
    String level;
    ArrayList<Integer> objects;

    int easyStartX = -210;
    int easyStartY = 600;
    int hardStartX = -330;
    int hardStartY = 330;
    int easyEndX = 960;
    int easyEndY = -180;
    int hardEndX = 1067;
    int hardEndY = 240;
    
    GameBoard(int height, int width) {
        this.height = height;
        this.width = width;
        this.x = 0;
        this.y = 0;    
        this.objects = new ArrayList<Integer>();
        speed = 30;
    }

    void drawBoard() {
        imageMode(CORNER);
        image(tilesheet.get(x, y, width, height), 0, 0);
    }

    void setLevel(String level) {
        this.level = level;
        if(level == "hard") {
            tilesheet = loadImage("maze_difficult.png");
            imgHeight = tilesheet.height;
            imgWidth = tilesheet.width;
        }
        else {
            tilesheet = loadImage("maze_easy.jpeg");
            imgHeight = tilesheet.height;
            imgWidth = tilesheet.width;
        }
    }

    void cameraUp() {
        setXY(this.x, this.y-speed);
    }

    void cameraRight() {
        setXY(this.x+speed, this.y);
    }

    void cameraLeft() {
        setXY(this.x-speed, this.y);
    }

    void cameraDown() {
        setXY(this.x, this.y+speed);
    }

    void setXY(int x, int y) {
        if(x != -1) {
            this.x = x;
        }
        if(y != -1) {
            this.y = y;
        }
        //check out of bounds
        // println("x val: " + x);
        // println("y val: " + y);
        if(x + width > imgWidth + 390) {
            this.x = imgWidth - width + 390;
        }
        else if(x < -390) {
            this.x = -390;
        }
        if(y + height > imgHeight + 260) {
            this.y = imgHeight - height + 260;
        }
        else if(y < -300) {
            this.y = -300;
        }
    }

    boolean checkWin() {
        if(level == "hard") {
            if(this.x <= hardEndX + 40 && this.x >= hardEndX - 40) {
                if(this.y <= hardEndY + 40 && this.y >= hardEndY - 40) {
                    // println("win");
                    return true;
                }
            }
        }
        else {
            if(this.x <= easyEndX + 40 && this.x >= easyEndX - 40) {
                if(this.y <= easyEndY + 40 && this.y >= easyEndY - 40) {
                    // println("win");
                    return true;
                }
            }
        }
        return false;
    }

    boolean checkStart() {
        if(level == "hard") {
            if(this.x <= hardStartX + 40 && this.x >= hardStartX - 40) {
                if(this.y <= hardStartY + 40 && this.y >= hardStartY - 40) {
                    return true;
                }
            }
        }
        else {
            if(this.x <= easyStartX + 40 && this.x >= easyStartX - 40) {
                if(this.y <= easyStartY + 40 && this.y >= easyStartY - 40) {
                    return true;
                }
            }
        }
        return false;
    }
 }