// Song "Playing With Fire" by Shaolin Dub imported from https://freemusicarchive.org/
import ddf.minim.*;
import controlP5.*;

// background music
Minim minim;
AudioPlayer song;

// menu screen
ControlP5 cp5;
boolean menu;
color green = #519a66;
color white = #FFFFFF;
color lightBrown = #9d7658;
color darkBrown = #755338;
Player player;

void setup() {
  size(800, 600);
  background(green);
  menu = true;
  player = new Player();

  //Make UI
  cp5 = new ControlP5(this);
  drawUI();
  
  // load music from file
  minim = new Minim(this);
  song = minim.loadFile("Shaolin Dub - Playing With Fire.mp3");
  song.play();
}

void draw() {
  background(green);
  PFont font = createFont("disposabledroid-bb/DisposableDroidBB.ttf", 100);
  fill(white);
  textFont(font);
  text("VALIANT", width/2 - 150, height/2 - 175);
}

void controlEvent(ControlEvent theEvent) {
  String name = theEvent.getController().getName();
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
