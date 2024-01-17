//Max Li

//=======================================
//COMPUTER SCIENCE CULMINATING ASSIGNMENT
//ICD20G-1
//MR. IERFINO
//PERIOD 1, RM 305
//=======================================

//GAME STAGE VARIABLES

int stage = 0; //
int levelNum = 1; //TO SKIP FORWARD, JUST CHANGE LEVEL TO DESIRED LEVEL.
int selector = 0;

//menu screen variables
float menuSpriteRedX = -100;
float menuSpriteBlueX = 1000;
PImage menuSpriteRed;
PImage menuSpriteBlue;
float titleY = -400;
PImage title;
PImage beginButton;
PImage beginButtonInversed;
PImage exitButton;
PImage exitButtonInversed;
PImage howtoplayButton;
PImage howtoplayButtonInversed;
int delayTimer = 0;

//GLOBAL OBJECT VARIABLES
Control red;
Control blue;
LevelHandler level;

void setup(){
  size(1000, 900);
  textAlign(CENTER);
  red = new Control(0, 20, 70, 50);
  blue = new Control(1, 10, 10, 50);
  menuSpriteBlue = loadImage("./assets/blueReversed.jpg");
  menuSpriteRed = loadImage("./assets/red.jpg");
  title = loadImage("./assets/logo.png");
  menuSpriteBlue.resize(100, 100);
  menuSpriteRed.resize(100, 100);
  title.resize(608, 258);
  beginButton = loadImage("./assets/beginButton.png");
  beginButton.resize(300, 75);
  beginButtonInversed = loadImage("./assets/beginButtonInversed.png");
  beginButtonInversed.resize(300, 75);
  exitButton = loadImage("./assets/exitButton.png");
  exitButton.resize(300, 75);
  exitButtonInversed = loadImage("./assets/exitButtonInversed.png");
  exitButtonInversed.resize(300, 75);
  howtoplayButton = loadImage("./assets/howtoplayButton.png");
  howtoplayButton.resize(300, 75);
  howtoplayButtonInversed = loadImage("./assets/howtoplayButtonInversed.png");
  howtoplayButtonInversed.resize(300, 75);
}


void draw(){
  // System.out.println(mouseX + " " + mouseY);
  if(stage == 0){
    float error = 130 - menuSpriteRedX;
    double velocity = error * 0.12; 
    menuSpriteBlueX-=velocity;
    menuSpriteRedX+=velocity;
    titleY+=15;
    background(0);
    image(menuSpriteBlue, menuSpriteBlueX, 800);
    image(menuSpriteRed, menuSpriteRedX, 800);
    image(title, 228,titleY);
    if(menuSpriteRedX >= 125) {
      stage++;
    }
  }else if(stage == 1){
    background(0);
    image(menuSpriteBlue, menuSpriteBlueX, 800);
    image(menuSpriteRed, menuSpriteRedX, 800);
    image(title, 228,titleY);
    textSize(50);
    fill(0);
    //if mouse is hovering over restart and hovering over exit
    boolean hoverRestart = (mouseX > width/2-150 && mouseX < width/2+ 150) && (mouseY > 350 && mouseY < 425);
    boolean hoverHowtoplay = (mouseX > width/2-150 && mouseX < width/2 + 150) && (mouseY > 450 && mouseY < 525);
    boolean hoverExit = (mouseX > width/2-150 && mouseX < width/2+ 150) && (mouseY > 550 && mouseY < 625);

    //if mouse is hovering over the buttons, reset the selector
    if(hoverExit || hoverRestart || hoverHowtoplay) cursor(HAND);
    else cursor(ARROW);
    //if highlight restart, make button inverse red
    if(hoverRestart){
      image(beginButtonInversed, width/2-150, 350);
      
    }else{
      image(beginButton, width/2-150, 350);
    }
    
    if(hoverHowtoplay){
      image(howtoplayButtonInversed, width/2-150, 450);
    }else{
      image(howtoplayButton, width/2-150, 450);
    }

    if(hoverExit){
      image(exitButtonInversed, width/2-150, 550);
    }else{
      image(exitButton, width/2-150, 550);
    }
    
    //if mouse pressed, restart
    if (hoverRestart && mousePressed) {
      stage++;
      menuSpriteBlue = loadImage("./assets/blue.jpg");
      menuSpriteRed = loadImage("./assets/redReversed.jpg");
      menuSpriteBlue.resize(100, 100);
      menuSpriteRed.resize(100, 100);
    } else if (hoverExit && mousePressed) {//if mouse pressed, exit
      exit();
    }
  }else if(stage == 2){
    cursor(ARROW);
    background(0);
    image(menuSpriteBlue, menuSpriteBlueX, 800);
    image(menuSpriteRed, menuSpriteRedX, 800);
    image(title, 228,titleY);
    float error = -105 - menuSpriteRedX;
    double velocity = error * 0.12;
    menuSpriteRedX+=velocity;
    menuSpriteBlueX-=velocity;
    titleY-=15;
    if(menuSpriteRedX <= -100){
      menuSpriteBlue = loadImage("./assets/blueReversed.jpg");
      menuSpriteRed = loadImage("./assets/red.jpg");
      menuSpriteBlue.resize(100, 100);
      menuSpriteRed.resize(100, 100);
      level = new LevelHandler(levelNum);
      red.setDirection(0);
      blue.setDirection(0);
      red.otherControl = blue;
      blue.otherControl = red;
      stage++;
    }
  }else if(stage == 3){
    level.update();
    red.update();
    blue.update();
    if(openTransition()) stage++;
  }else if(stage == 4){
    level.update();
    red.update();
    blue.update();
    transitionCounter = 0;
  }else if(stage == 5){ //transition stage
    if(closeTransition()) stage = 0;
  }else if(stage == 6){ //next level
    if(closeTransition()){
      levelNum++;
      if(levelNum == 100) stage = 8; //CHANGE TO LAST LEVEL, change to end stage
      else{
        level = new LevelHandler(levelNum);
        stage++;
      }
    }
  }else if(stage == 7){ //delay stage
    delayTimer++;
    if(delayTimer == 50) stage = 3;
  }
}

void keyPressed(){
  char keyChar = Character.toLowerCase(key);
  if(stage == 0){

  }else if(stage == 4){
    switch (keyChar) {
      case 'a':
        red.setDirection(-1);
        break;
      case 'd':
        red.setDirection(1);
        break;
      case 'w':
        red.jump();
        break;
      case 'e':
        level.addArrow(new Arrow(red.getPos()[0]+25, red.getPos()[1], !red.getReversed()));
        break;
    }
    switch(keyCode){
      case RIGHT:
        blue.setDirection(1);
        break;
      case LEFT:
        blue.setDirection(-1);
        break;
      case UP:
        blue.jump();
        break;
      case SHIFT:
        level.addArrow(new Arrow(blue.getPos()[0]+25, blue.getPos()[1], !blue.getReversed()));
    }
  }else if(stage == 2){
    
  }
}

void keyReleased() {
  if(stage == 4){
    if ((Character.toLowerCase(key) == 'a' && red.getDirection() == -1) || (Character.toLowerCase(key) == 'd' && red.getDirection() == 1)) {
      red.setDirection(0);
    }
    if ((keyCode == RIGHT && blue.getDirection() == 1) || (keyCode == LEFT && blue.getDirection() == -1)){
      blue.setDirection(0);
    }
  }
}