/**
 * Holds the tilemap of the mountain and displays it to the screen.
 */

 class GameBoard {
    int height;
    int width;
    int x, y;
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

    void setXY(int x, int y) {
        if(x != -1) {
            this.x = x;
        }
        if(y != -1) {
            this.y = y;
        }
        //check out of bounds
        if(x + width > imgWidth) {
            x = imgWidth - width;
        }
        else if(x < 0) {
            x = 0;
        }
        if(y + height > imgHeight) {
            x = imgHeight - height;
        }
        else if(y < 0) {
            y = 0;
        }
    }
 }