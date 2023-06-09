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

PImage trophyIcon;
PImage questionIcon;
boolean highScores;
boolean howTo;

PFont font;

Map<Integer, String> easyMap = new HashMap<Integer, String>();
PriorityQueue<Integer> easyTimes = new PriorityQueue<Integer>();
Map<Integer, String> hardMap = new HashMap<Integer, String>();
PriorityQueue<Integer> hardTimes = new PriorityQueue<Integer>();

// setup function, initializes the start game page, and loads the music
// constructs class instances for the objects used in the game and sets default state params 
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
  song.play();
  
  trophyIcon = loadImage("trophy-icon.png");
  questionIcon = loadImage("question-icon.png");
  
  trophyIcon.resize(120, 120);
  questionIcon.resize(80, 80);
  
  highScores = false;
  howTo = false;
  
  font = createFont("disposabledroid-bb/DisposableDroidBB.ttf", 100);
}

// draw function, switches between different game state: start menu, how to menu, scores menu, and game play
void draw() {
  background(green);
  if(menu) {
    //draw menu
    fill(white);
    textFont(font);
    text("VALIANT", width/2 - 150, height/2 - 175);
    
    imageMode(CORNER);
    image(trophyIcon, 30, 50);
    image(questionIcon, 650, 60);
  }
  else if (howTo){
    fill(lightBrown);
    rectMode(CENTER);
    rect(width/2, height/2, 740, 520);
    
    fill(white);
    textFont(font);
    textMode(CENTER);
    textSize(60);
    text("HOW TO PLAY", width/2 - 150, height/2 - 200);
    textSize(20);
    text("Be the fastest to complete a maze and make it to the other side! Navigate thru", width/2 - 350, height/2 - 150);
    text("the fences and cross the finish line in the shortest amount of time to set a", width/2 - 350, height/2 - 125);
    text("high score and make it onto the leaderboard!", width/2 - 350, height/2 - 100);
    text("Use the following keys on your computer to move around:", width/2 - 350, height/2 - 50);
    text("W - move up", width/2 - 350, height/2 - 25);
    text("A - move left", width/2 - 350, height/2);
    text("S - move down", width/2 - 350, height/2 + 25);
    text("D - move right", width/2 - 350, height/2 + 50);
    text("You can see your current run time on the top left of the screen which will stop", width/2 - 350, height/2 + 100);
    text("once you exit the maze on the opposite side.", width/2 - 350, height/2 + 125);
    text("Think outside the box to be the fastest!", width/2 - 350, height/2 + 175);
    text("Good luck!", width/2 - 350, height/2 + 200);
    fill(darkBrown);
    rect(width/2 + 250, height/2 + 200, 150, 50);
    fill(white);
    textSize(30);
    text("CLOSE", width/2 + 215, height/2 + 208); 
  }
  else if (highScores){
    fill(lightBrown);
    rectMode(CENTER);
    rect(width/2, height/2, 740, 520);
    
    fill(white);
    textFont(font);
    textMode(CENTER);
    textSize(60);
    text("HIGH SCORES", width/2 - 150, height/2 - 200);
    
    textSize(40);
    text("EASY", width/2 - 300, height/2 - 150);
    text("HARD", width/2 + 200, height/2 - 150);
    
    getHighScores();
    
    int count = 0;

    //Iterator iterator = easyTimes.iterator();
    //System.out.println(easyTimes);
    while(easyTimes.size() > 0 && count < 5) {
      textSize(20);
      text(easyMap.get(easyTimes.poll()), width/2 - 300, height/2 - 100 + (50*count));
      count++;
    }

    count = 0;
    while(hardTimes.size() > 0 && count < 5) {
      textSize(20);
      text(hardMap.get(hardTimes.poll()), width/2 + 200, height/2 - 100 + (50*count));
      count++;
    }
    
    fill(darkBrown);
    rect(width/2 + 250, height/2 + 200, 150, 50);
    fill(white);
    textSize(30);
    text("CLOSE", width/2 + 215, height/2 + 208); 
  }
  else {
    //draw game
    board.drawBoard();
    player.draw(width/2, height/2);
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

// retrieves the high score from the txt file and stores them in hashmaps and priority queues 
void getHighScores(){
  String[] scores = loadStrings("PlayerScores.txt");
  easyTimes.clear();
  hardTimes.clear();

  for (int i=0; i<scores.length; i++){
    String[] split = scores[i].split(" ");
    
    //System.out.println("HERE: " + split[0]);
    //System.out.println(str(split.length));
    
    if (split[0].indexOf("easy") >= 0){
      int time = Integer.parseInt(split[2].substring(split[2].length()-2)) + 60 * Integer.parseInt(split[2].substring(0, split[2].length()-3));
      //System.out.println("NOW: " + time);
      easyMap.put(time, split[1] + " " + split[2]);
      easyTimes.add(time);
    }
    
    if (split[0].indexOf("hard") >= 0){
      int time = Integer.parseInt(split[2].substring(split[2].length()-2)) + 60 * Integer.parseInt(split[2].substring(0, split[2].length()-3));
      //System.out.println("NOW hard: " + time);
      hardMap.put(time, split[1] + " " + split[2]);
      hardTimes.add(time);
    }
  }
}

// handles mouse clicks for the how to, scores, and restart buttons 
void mousePressed(){
  if (menu){
    if (mouseX >= 650 && mouseX <= 730 && mouseY >= 60 && mouseY <= 140){
      menu = false;
      cp5.getController("How to Play").setVisible(false);
      cp5.getController("Start Game").setVisible(false);
      cp5.getController("Select Difficulty").setVisible(false);
      cp5.getController("Enter Name").setVisible(false);
      howTo = true;
    }
    
    if (mouseX >= 30 && mouseX <= 150 && mouseY >= 50 && mouseY <= 170){
      menu = false;
      cp5.getController("How to Play").setVisible(false);
      cp5.getController("Start Game").setVisible(false);
      cp5.getController("Select Difficulty").setVisible(false);
      cp5.getController("Enter Name").setVisible(false);
      highScores = true;
    }
  }
  if (howTo){
    if (mouseX >= width/2 + 175 && mouseX <= width/2 + 325 && mouseY >= height/2 + 175 && mouseY <= height/2 + 225){
      rect(width/2 + 250, height/2 + 200, 150, 50);
      howTo = false;
      menu = true;
      cp5.getController("How to Play").setVisible(true);
      cp5.getController("Start Game").setVisible(true);
      cp5.getController("Select Difficulty").setVisible(true);
      cp5.getController("Enter Name").setVisible(true);
    }
  }
  if (highScores){
    if (mouseX >= width/2 + 175 && mouseX <= width/2 + 325 && mouseY >= height/2 + 175 && mouseY <= height/2 + 225){
      rect(width/2 + 250, height/2 + 200, 150, 50);
      highScores = false;
      menu = true;
      cp5.getController("How to Play").setVisible(true);
      cp5.getController("Start Game").setVisible(true);
      cp5.getController("Select Difficulty").setVisible(true);
      cp5.getController("Enter Name").setVisible(true);
    }
  }
  if(gameOver) {
    if(mouseX >= width/2 + 185 && mouseX <= width/2 + 385 && mouseY >= height/2 - 285 && mouseY >= height/2 - 335) {
      gameOver = false;
      gameStart = false;
      menu = true;
      difficulty = "";
      time = "";
      System.out.println("restarting");
      drawUI();
    }
  }
}

// controls the character and board movement based on the user inputs
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
      
      String[] lines = loadStrings("PlayerScores.txt");
      String score = "";
      
      for (int i=0; i<lines.length; i++){
        score += lines[i] + "\n";
      }
      
      int sec = game.second();
      int min = game.minute();
      if(sec < 10) {
        time = str(min) + ":0" + str(sec);
      }
      else {
        time = str(min) + ":" + str(sec);
      }
      score += difficulty + ": " + player_name + " " + time + "\n";
      String[] scores = split(score, "\n");
      
      saveStrings("PlayerScores.txt", scores);
      cp5.getController("Restart").setVisible(true);
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

// handles the player movement, defaults to idle on key relased 
void keyReleased() {
  if(!board.swimming() && key != ' ') {
    player.idle();
  }
}

// handles the cp5 buttons 
void controlEvent(ControlEvent theEvent) {
  String name = theEvent.getController().getName();

  String data = cp5.get(Textfield.class, "Enter Name").getText();
  print("name: " + data);
  if(data != "" && !data.isBlank()) {
    player_name = data;
  }

  System.out.println(name);

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
      cp5.getController("How to Play").setVisible(false);
      cp5.getController("Start Game").setVisible(false);
      cp5.getController("Select Difficulty").setVisible(false);
      cp5.getController("Enter Name").setVisible(false);
    }
  }

  if(name == "Restart") {
    gameOver = false;
      gameStart = false;
      menu = true;
      difficulty = "";
      time = "";
      System.out.println("restarting");
      drawUI();
  }
}

// draws all the buttons as visible or not based on the current game state 
void drawUI() {
  String cfont = "disposabledroid-bb/DisposableDroidBB.ttf";
  ControlFont cf = new ControlFont(createFont(cfont, 20));
  fill(white);
  
  cp5.addButton("How to Play")
    .setPosition(width/2 - 350/2, height/2 + 150)
    .setSize(350, 50)
    .setColorForeground(darkBrown)
    .setColorBackground(lightBrown)
    .setColorActive(white)
    .setVisible(menu)
    .setFont(cf)
    ;

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

  cp5.addButton("Restart")
    .setPosition(width/2 + 185, height/2 - 285)
    .setSize(200, 50)
    .setColorForeground(darkBrown)
    .setColorBackground(lightBrown)
    .setColorActive(white)
    .setVisible(gameOver)
    .setFont(cf)
    ;
}
