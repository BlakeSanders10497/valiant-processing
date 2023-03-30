import controlP5.*;

// menu screen
ControlP5 cp5;
boolean menu;
color green = #519a66;
color white = #FFFFFF;
color lightBrown = #9d7658;
color darkBrown = #755338;

void setup() {
  size(800, 600);
  background(green);
  menu = true;

  //Make UI
  cp5 = new ControlP5(this);
  drawUI();
}

void draw() {
  
}

void drawUI() {
  String font = "disposabledroid-bb/DisposableDroidBB.ttf";
  ControlFont cf = new ControlFont(createFont(font,15));

  cp5.addButton("Start Game")
    .setPosition(width/2 - 350/2, height/2 + 50)
    .setSize(350, 50)
    .setColorForeground(darkBrown)
    .setColorBackground(lightBrown)
    .setColorActive(white)
    ;

  cp5.addTextfield("Enter Name")
    .setPosition(width/2 - 350/2, height/2 - 100)
    .setSize(350, 50)
    .setColorForeground(darkBrown)
    .setColorBackground(lightBrown)
    .setColorActive(white)
    .setAutoClear(false)
    ;
}
