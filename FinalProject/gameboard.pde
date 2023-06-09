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
    boolean swimming;

    int easyStartX = -210;
    int easyStartY = 600;
    int hardStartX = -330;
    int hardStartY = 330;
    int easyEndX = 960;
    int easyEndY = -180;
    int hardEndX = 1067;
    int hardEndY = 240;
    
    // constructor based on screen width and height
    // sets the current location and keeps tracks of all the objects on the image 
    GameBoard(int height, int width) {
        this.height = height;
        this.width = width;
        this.x = 0;
        this.y = 0;    
        this.objects = new ArrayList<Integer>();
        speed = 10;
        swimming = false;
    }

    // draws a section of the larger game board image to the screen
    void drawBoard() {
        imageMode(CORNER);
        image(tilesheet.get(x, y, width, height), 0, 0);
    }

    // loads in the background image of the game board based on the level 
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

    // moves the field of view up on the camera if its a valid spot the user can move
    void cameraUp() {
        this.swimming = checkSwim(this.x, this.y-speed);
        if(!checkBounding(this.x, this.y-speed)) {
            setXY(this.x, this.y-speed);
        }
    }

    // moves the field of view right on the camera if its a valid spot the user can move
    void cameraRight() {
        this.swimming = checkSwim(this.x+speed, this.y);
        if(!checkBounding(this.x+speed, this.y)) {
            setXY(this.x+speed, this.y);
        }
    }

    // moves the field of view left on the camera if its a valid spot the user can move
    void cameraLeft() {
        this.swimming = checkSwim(this.x-speed, this.y);
        if(!checkBounding(this.x-speed, this.y)) {
            setXY(this.x-speed, this.y);
        }
    }

    // moves the field of view down on the camera if its a valid spot the user can move
    void cameraDown() {
        this.swimming = checkSwim(this.x, this.y+speed);
        if(!checkBounding(this.x, this.y+speed)) {
            setXY(this.x, this.y+speed);
        }
    }

    // retuns true if the user is over water 
    boolean swimming() {
        return swimming;
    }

    // sets the current x, y of the camera/ field of view of the game board
    // doesnt update the position if its off (out of bounds) the gameboard image
    void setXY(int x, int y) {
        if(x != -1) {
            this.x = x;
        }
        if(y != -1) {
            this.y = y;
        }
        //check out of bounds
        //println("x val: " + x);
        //println("y val: " + y);
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

    // checks if the player has reached the end of the maze 
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
            if(this.x <= easyEndX + 20 && this.x >= easyEndX - 20) {
                if(this.y <= easyEndY + 20 && this.y >= easyEndY - 20) {
                    // println("win");
                    return true;
                }
            }
        }
        return false;
    }

    // checks if the player has moved from the starting position of the game 
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

    // returns true if the user is over water
    // reads in water coordinates from the txt file
    boolean checkSwim(int newX, int newY) {
        JSONArray waterCoordinates = new JSONArray();
        if(level == "easy") {
            JSONObject water = loadJSONObject("data/maze_easy.json");
            waterCoordinates = water.getJSONArray("water");
        }
        else {
            JSONObject water = loadJSONObject("data/maze_difficult.json");
            waterCoordinates = water.getJSONArray("water");
        }
        for(int i = 0; i < waterCoordinates.size(); i++) {
            JSONArray coordinates = waterCoordinates.getJSONArray(i);
            int x1 = coordinates.getInt(0);
            int y1 = coordinates.getInt(1);
            int x2 = coordinates.getInt(2);
            int y2 = coordinates.getInt(3);
            //println("x1: " + x1 + " " + "y1: " + y1 + " " + "x2: " + x2 + " " + "y2: " + y2);
            if(checkSwimBox(x1, y1, x2, y2, newX, newY)) {
                return true;
            }
        }
        return false;
    }

    // checks if the user is trying to move into an object on the screen
    // (fence, trees, rocks, etc)
    // reads in object locations from txt file
    boolean checkBounding(int newX, int newY) {
        JSONArray fenceCoordinates = new JSONArray();
        if(level == "easy") {
            JSONObject fence = loadJSONObject("data/maze_easy.json");
            fenceCoordinates = fence.getJSONArray("fence");
        }
        else {
            JSONObject fence = loadJSONObject("data/maze_difficult.json");
            fenceCoordinates = fence.getJSONArray("fence");
        }
        for(int i = 0; i < fenceCoordinates.size(); i++) {
            JSONArray coordinates = fenceCoordinates.getJSONArray(i);
            int x1 = coordinates.getInt(0);
            int y1 = coordinates.getInt(1);
            int x2 = coordinates.getInt(2);
            int y2 = coordinates.getInt(3);
            //println("x1: " + x1 + " " + "y1: " + y1 + " " + "x2: " + x2 + " " + "y2: " + y2);
            if(checkBoundingBox(x1, y1, x2, y2, newX, newY)) {
                return true;
            }
        }
        return false;
    }

    // checks if the user is in a water bounding box
    boolean checkSwimBox(int x1, int y1, int x2, int y2, int x, int y) {
        // 1 = top left
        // 2 = bottom right
        if(x >= x1 && y >= y1 && x <= x2 && y <= y2) {
            return true;
        }
        return false;
    }

    // checks if the user is in a object bounding box 
    boolean checkBoundingBox(int x1, int y1, int x2, int y2, int x, int y) {
        // 1 = top left
        // 2 = bottom right
        if(x > x1 && y > y1 && x < x2 && y < y2) {
            return true;
        }
        return false;
    }

}
