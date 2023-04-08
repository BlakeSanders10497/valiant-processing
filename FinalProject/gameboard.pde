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
    
    GameBoard(int height, int width) {
        this.height = height;
        this.width = width;
        this.x = 0;
        this.y = 0;    
        this.objects = new ArrayList<Integer>();
        speed = 30;
        swimming = false;
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

    void checkSwimming(color c) {
        if(int(red(c)) == 95 && (int(green(c)) == 150 || int(green(c)) == 149) && (int(blue(c)) == 243 || int(blue(c)) == 245)) {
            this.swimming = true;
        }
        else {
            this.swimming = false;
        }
    }

    void cameraUp() {
      color c = get(width/2, height/2-10);
        noFill();
      stroke(3);
      circle( width/2, height/2-10, 10);
      checkSwimming(c);
      /*println("HEX COLOR: ", hex(c)," RGB: ", red(c), green(c), blue(c));
      
      if (160<=red(c) && red(c)>=130 && 130<=green(c) && green(c)>=100 && 100<=blue(c) && blue(c)>=70){
        return;
      }
      if (90<=red(c) && red(c)>=50 && 65<=green(c) && green(c)>=40 && 45<=blue(c) && blue(c)>=15){
        return;
      }*/
      setXY(this.x, this.y-speed);
    }

    void cameraRight() {
      color c = get(width/2+30, height/2+25);
    noFill();
      stroke(3);
      circle( width/2+30, height/2+25, 10);
      checkSwimming(c);
      /*println("HEX COLOR: ", hex(c)," RGB: ", red(c), green(c), blue(c));
      
      if (160<=red(c) && red(c)>=130 && 130<=green(c) && green(c)>=100 && 100<=blue(c) && blue(c)>=70){
        return;
      }
      if (90<=red(c) && red(c)>=50 && 65<=green(c) && green(c)>=40 && 45<=blue(c) && blue(c)>=15){
        return;
      }*/
      setXY(this.x+speed, this.y);
    }

    void cameraLeft() {
      color c = get(width/2-30, height/2+25);
      noFill();
      stroke(3);
      circle(width/2-30, height/2+25, 10);
      checkSwimming(c);
      /*println("HEX COLOR: ", hex(c)," RGB: ", red(c), green(c), blue(c));
      if (160<=red(c) && red(c)>=130 && 130<=green(c) && green(c)>=100 && 100<=blue(c) && blue(c)>=70){
        return;
      }
      if (90<=red(c) && red(c)>=50 && 65<=green(c) && green(c)>=40 && 45<=blue(c) && blue(c)>=15){
        return;
      }*/
        setXY(this.x-speed, this.y);
    }

    void cameraDown() {
     color c = get(width/2, height/2+55);
        noFill();
      stroke(3);
      circle(width/2, height/2+55, 10);
     checkSwimming(c);
      /*println("HEX COLOR: ", hex(c)," RGB: ", red(c), green(c), blue(c));
      if (160<=red(c) && red(c)>=130 && 130<=green(c) && green(c)>=100 && 100<=blue(c) && blue(c)>=70){
        return;
      }
      if (90<=red(c) && red(c)>=50 && 65<=green(c) && green(c)>=40 && 45<=blue(c) && blue(c)>=15){
        return;
      }*/
      setXY(this.x, this.y+speed);
    }

    boolean swimming() {
        return swimming;
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