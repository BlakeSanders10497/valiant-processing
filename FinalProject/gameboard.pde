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
    ArrayList<Integer> objects;
    
    GameBoard(int height, int width) {
        this.height = height;
        this.width = width;
        this.x = 0;
        this.y = 0;    
        this.objects = new ArrayList<Integer>();
        speed = 10;
    }

    void drawBoard() {
        imageMode(CORNER);
        image(tilesheet.get(x, y, width, height), 0, 0);
    }

    void setLevel(String level) {
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
        println("x val: " + x);
        println("y val: " + y);
        println("imgWidth val: " + imgWidth);
        println("imgHeiht val: " + imgHeight);
        if(x + width > imgWidth + 390) {
            this.x = imgWidth - width + 390;
        }
        else if(x < -390) {
            this.x = -390;
        }
        if(y + height > imgHeight + 300) {
            this.y = imgHeight - height + 300;
        }
        else if(y < -300) {
            this.y = -300;
        }
    }
 }