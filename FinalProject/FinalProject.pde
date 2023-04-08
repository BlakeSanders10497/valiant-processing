// Song "Playing With Fire" by Shaolin Dub imported from https://freemusicarchive.org/
import ddf.minim.*;
import controlP5.*;

// background music
Minim minim;
AudioPlayer song;

// menu screen
ControlP5 cp5;
boolean menu;
boolean gameOver;
boolean gameStart;
color green = #4d9162;
color white = #FFFFFF;
color lightBrown = #9d7658;
color darkBrown = #755338;
Player player;

String player_name;
String difficulty;
String time;
GameBoard board;
Game game;

void setup() {
  size(800, 600);
  background(green);
  menu = true;
  gameOver = false;
  gameStart = false;
  player_name = "";
  difficulty = "";
  time = "";
  player = new Player();
  board = new GameBoard(height, width);
  game = new Game();

  //Make UI
  cp5 = new ControlP5(this);
  drawUI();
  
  // load music from file
  minim = new Minim(this);
  song = minim.loadFile("Shaolin Dub - Playing With Fire.mp3");
  //song.play();
}

void draw() {
  background(green);
  if(menu) {
    //draw menu
    PFont font = createFont("disposabledroid-bb/DisposableDroidBB.ttf", 100);
    fill(white);
    textFont(font);
    text("VALIANT", width/2 - 150, height/2 - 175);
  }
  else {
    //draw game
    board.drawBoard();
    player.draw(width/2, height/2);
    println(board.swimming());
    if(gameStart) {
      // display time 
      PFont font = createFont("disposabledroid-bb/DisposableDroidBB.ttf", 30);
      fill(white);
      textFont(font);
      int sec = game.second();
      int min = game.minute();
      time = str(min) + ":" + str(sec);
      text("Run Time: " + time, 0, 30);
    }
  }
}

void keyPressed() {
  if(key == 'w') {
    player.moveUp();
    board.cameraUp();
  }
  else if(key == 'd') {
    player.moveRight();
    board.cameraRight();
  }
  else if(key == 's') {
    player.moveDown();
    board.cameraDown();
  }
  else if(key == 'a') {
    player.moveLeft();
    board.cameraLeft();
  }

  if(player.state != State.JUMP && key == ' ') {
    player.jump();
  }

  if(key == 'x') {
    player.swim();
  }
  if(!gameOver) {
    boolean over = board.checkWin();
    if(over) {
      game.stop();
    }
    gameOver = over;
  }

  if(!gameStart) {
    boolean start = board.checkStart();
    println(start);
    if(start) {
      game.start();
    }
    gameStart = start;
  }

  if(board.swimming()) {
    player.swim();
  }
}

void keyReleased() {
  if(!board.swimming() && key != ' ') {
    player.idle();
  }
}
void controlEvent(ControlEvent theEvent) {
  String name = theEvent.getController().getName();

  String data = cp5.get(Textfield.class, "Enter Name").getText();
  print("name: " + data);
  if(data != "" && !data.isBlank()) {
    player_name = data;
  }

  if(name == "Select Difficulty") {
    int diff = int(theEvent.getValue());
    if(diff == 0) {
      difficulty = "easy";
      board.setLevel(difficulty);
      board.setXY(-210, 600);
    }
    else {
      difficulty = "hard";
      board.setLevel(difficulty);
      board.setXY(-330, 330);
    }
  }

  if(name == "Start Game") {
    if(player_name != "" && difficulty != "") {
      menu = false;
      cp5.getController("Start Game").setVisible(false);
      cp5.getController("Select Difficulty").setVisible(false);
      cp5.getController("Enter Name").setVisible(false);
    }
  }
}

void drawUI() {
  String cfont = "disposabledroid-bb/DisposableDroidBB.ttf";
  ControlFont cf = new ControlFont(createFont(cfont, 20));
  PFont font = createFont("disposabledroid-bb/DisposableDroidBB.ttf", 100);
  fill(white);
  textFont(font);
  text("VALIANT", width/2, height/2 - 175);

  cp5.addButton("Start Game")
    .setPosition(width/2 - 350/2, height/2 + 150)
    .setSize(350, 50)
    .setColorForeground(darkBrown)
    .setColorBackground(lightBrown)
    .setColorActive(white)
    .setVisible(menu)
    .setFont(cf)
    ;

  cp5.addDropdownList("Select Difficulty")
    .setPosition(width/2 - 350/2, height/2 - 25)
    .setSize(350, 150)
    .setColorForeground(darkBrown)
    .setColorBackground(lightBrown)
    .setColorActive(white)
    .setBarHeight(50)
    .addItem("Easy", 0)
    .setItemHeight(50)
    .addItem("Hard", 1)
    .setVisible(menu)
    .setFont(cf)
    ;

  cp5.addTextfield("Enter Name")
    .setPosition(width/2 - 350/2, height/2 - 100)
    .setSize(350, 50)
    .setColorForeground(darkBrown)
    .setColorBackground(lightBrown)
    .setColorActive(white)
    .setAutoClear(false)
    .setVisible(menu)
    .setFont(cf)
    .getCaptionLabel().align(ControlP5.LEFT, ControlP5.TOP_OUTSIDE)
    ;
}
