//Max Li

//=======================================
//COMPUTER SCIENCE CULMINATING ASSIGNMENT
//ICD20G-1
//MR. IERFINO
//PERIOD 1, RM 305
//=======================================

//=======================================
//BONUS FEATURES:
//
// - Title screen: start, how to play, and exit selector
// - Platforms: full collision detection with all control characters and projectiles
// - Doors & targets: when projectiles hit targets, doors open.
// - Death animations: cool randomize death particles
// - Personalized projectile curve: created a curve that fits the projectile 
// - JSON data parsing: all level data is stored in json files, and is then parsed to display on the screen
// - Arrow rotational matrices: got some really cool math to calculate the location of the verticies of the arrow when its rotated
//=======================================

//=======================================
//CONTROLS:
//
//WAD - RED PLAYER MOVEMENT
//ARROW KEYS - BLUE PLAYER MOVEMENT
//S - RED PLAYER SHOOT
//DOWN - BLUE PLAYER SHOOT
//=======================================

//=======================================
//HOW TO PLAY:
//
// Jump on platforms and avoid the green goo to try and get to your coloured door!
// Shoot arrows at targets to toggle doors!
//=======================================

//(level designs are really boring, sorry lol)

import processing.sound.*;

//GAME STAGE VARIABLES
int stage = 0;
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
PImage youWon;
PImage youWonInversed;
int delayTimer = 0;
int tick = 0;

//GLOBAL OBJECT VARIABLES
Control red;
Control blue;
LevelHandler level;

//SOUND FILES
SoundFile arrowFire;
SoundFile arrowStop;
SoundFile arrowHit;
SoundFile playerDie;

void setup(){
  size(1000, 900);
  textAlign(CENTER);

  //create new control objs
  red = new Control(0, 20, 70, 50);
  blue = new Control(1, 10, 10, 50);
  //create images for menu screen buttons
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
  youWonInversed = loadImage("./assets/youWonInverse.png");
  youWonInversed.resize(600, 150);
  youWon = loadImage("./assets/youWon.png");
  youWon.resize(600, 150);
  //create sound files
  arrowFire = new SoundFile(this, "./sounds/arrowFire.mp3");
  arrowHit = new SoundFile(this, "./sounds/arrowHit.mp3");
  arrowStop = new SoundFile(this, "./sounds/arrowStop.mp3");
  playerDie = new SoundFile(this, "./sounds/death.mp3");
}


void draw(){
  if(stage == 0 || stage == 8){ //entering menu stage
    float error = 130 - menuSpriteRedX; //create a P loop for the two characters coming into the screen
    //set kP to 0.12. this makes the velocity at which the characters come into the screen slow down as they get closer to their target
    double velocity = error * 0.12; 
    //add and subtract the menu x values by velocity
    menuSpriteBlueX-=velocity;
    menuSpriteRedX+=velocity;
    titleY+=15;
    background(0);
    //draw the images to the screen
    image(menuSpriteBlue, menuSpriteBlueX, 800);
    image(menuSpriteRed, menuSpriteRedX, 800);
    image(title, 228,titleY);
    //if menu sprite red x is greater than 125
    if(menuSpriteRedX >= 125) {
      stage++;
    }
  }else if(stage == 1){ //menu stage
    //draw the images and background
    background(0);
    image(menuSpriteBlue, menuSpriteBlueX, 800);
    image(menuSpriteRed, menuSpriteRedX, 800);
    image(title, 228,titleY);
    textSize(50);
    fill(0);
    //if mouse is hovering over restart and hovering over exit
    boolean hoverRestart = (mouseX > width/2-150 && mouseX < width/2+ 150) && (mouseY > 350 && mouseY < 425);
    boolean hoverExit = (mouseX > width/2-150 && mouseX < width/2+ 150) && (mouseY > 450 && mouseY < 525);

    //if mouse is hovering over the buttons, change cursor type
    if(hoverExit || hoverRestart) cursor(HAND);
    else cursor(ARROW);
    //if highlight restart, make button inverse green
    if(hoverRestart){
      image(beginButtonInversed, width/2-150, 350);
      
    }else{
      image(beginButton, width/2-150, 350);
    }
    //if highlighting exit, make button inverse red
    if(hoverExit){
      image(exitButtonInversed, width/2-150, 450);
    }else{
      image(exitButton, width/2-150, 450);
    }
    
    //if mouse pressed, begin
    if (hoverRestart && mousePressed) {
      stage++;
      menuSpriteBlue = loadImage("./assets/blue.jpg");
      menuSpriteRed = loadImage("./assets/redReversed.jpg");
      menuSpriteBlue.resize(100, 100);
      menuSpriteRed.resize(100, 100);
    } else if (hoverExit && mousePressed) {//if mouse pressed, exit
      exit();
    }
  }else if(stage == 2){ //menu sprites exit stage
    //reset all sprites
    cursor(ARROW);
    background(0);
    image(menuSpriteBlue, menuSpriteBlueX, 800);
    image(menuSpriteRed, menuSpriteRedX, 800);
    image(title, 228,titleY);
    //create a P loop for menu sprites to leave
    float error = -105 - menuSpriteRedX;
    double velocity = error * 0.12;
    menuSpriteRedX+=velocity;
    menuSpriteBlueX-=velocity;
    titleY-=15;
    //when the menu sprite is off the screen, load the next level.
    if(menuSpriteRedX <= -100){
      menuSpriteBlue = loadImage("./assets/blueReversed.jpg");
      menuSpriteRed = loadImage("./assets/red.jpg");
      menuSpriteBlue.resize(100, 100);
      menuSpriteRed.resize(100, 100);
      //load the level
      level = new LevelHandler(levelNum);
      //set the red and blue constants
      red.setDirection(0);
      blue.setDirection(0);
      red.otherControl = blue;
      blue.otherControl = red;
      stage++;
    }
  }else if(stage == 3){ //transition stage
    level.update();
    red.update();
    blue.update();
    if(openTransition()) stage++; //when the transition is finished, increase the stage
  }else if(stage == 4){ //keep updating all sprites and levels
    level.update();
    red.update();
    blue.update();
    transitionCounter = 0;
  }else if(stage == 5){ //death transition stage
    if(closeTransition()) stage = 0; //when finished, redirect to menu screen
  }else if(stage == 6){ //next level transition stage
    if(closeTransition()){ //close transition, once its finished,
      levelNum++;
      if(levelNum == 4) stage = 8; //if this was the last level, change to end stage
      else{ //if this was not the last level, go to next level
        level = new LevelHandler(levelNum);
        stage++;
      }
    }
  }else if(stage == 7){ //delay stage
    delayTimer++;
    if(delayTimer == 50){ //once delay timer has reached 50 ms, restart at stage 3
      stage = 3;
      delayTimer = 0;
    }
  }else if(stage == 9){
    tick++;
    background(0); //sprites enter the screen
    image(menuSpriteBlue, menuSpriteBlueX, 800);
    image(menuSpriteRed, menuSpriteRedX, 800);
    image(title, 228,titleY);
    //every 30 ticks the you won button will flash
    image(Math.floor(tick / 30) % 2 == 0 ? youWon : youWonInversed,width/2-275, 350);
  }
}

void keyPressed(){ //on keypressed
  char keyChar = Character.toLowerCase(key); //set the key charcter to lowercase (caps lock preventive measure)
  if(stage == 4){ //if this is during the gameplay stage
    switch (keyChar) {
      case 'a': //if a, set red to go left
        red.setDirection(-1);
        break;
      case 'd': //if d, set red to go right
        red.setDirection(1);
        break;
      case 'w': //if w, tell red to jump
        red.jump();
        break;
      case 's': //if s, create a new arrow
        arrowFire.play();
        level.addArrow(new Arrow(red.getPos()[0]+25, red.getPos()[1], !red.getReversed()));
        break;
    }
    switch(keyCode){
      case RIGHT: //if right, set blue to go right
        blue.setDirection(1);
        break;
      case LEFT: //if left, set blue to go left
        blue.setDirection(-1);
        break;
      case UP: //if up, tell blue to jump
        blue.jump();
        break;
      case DOWN: //if down, create a new arrow
        arrowFire.play();
        level.addArrow(new Arrow(blue.getPos()[0]+25, blue.getPos()[1], !blue.getReversed()));
        break;
    }
  }
}

void keyReleased() { //on keyreleased
  if(stage == 4){ //if stage is gameplay stage
    if ((Character.toLowerCase(key) == 'a' && red.getDirection() == -1) || (Character.toLowerCase(key) == 'd' && red.getDirection() == 1)) {
    //if key is a and red is going to the left, or if key is d and red is going to the right,  
      red.setDirection(0); //stop the character
    }
    if ((keyCode == RIGHT && blue.getDirection() == 1) || (keyCode == LEFT && blue.getDirection() == -1)){
    //if key is right and blue is going to the right, or if key is left and red is going to the left,  
      blue.setDirection(0); //stop the character
    }
  }
}