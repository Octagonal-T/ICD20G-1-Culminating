//Max Li

//=======================================
//COMPUTER SCIENCE CULMINATING ASSIGNMENT
//ICD20G-1
//MR. IERFINO
//PERIOD 1, RM 305
//=======================================

//GAME STAGE VARIABLES
int stage = 0; //0 = menu select, 1 = playing, 2 = paused, 3 = dead
int selector = 1;
int transitionCounter = 60;

//menu screen variables
float menuSpriteRedX = -100;
float menuSpriteBlueX = 1000;
PImage menuSpriteRed;
PImage menuSpriteBlue;
float titleY = -400;
PImage title;
//GLOBAL OBJECT VARIABLES
Control red;
Control blue;
LevelHandler level;

void setup(){
  size(1000, 900);
  red = new Control(0, 20, 70, 50);
  blue = new Control(1, 10, 10, 50);
  menuSpriteBlue = loadImage("./assets/blueReversed.jpg");
  menuSpriteRed = loadImage("./assets/red.jpg");
  title = loadImage("./assets/logo.png");
  menuSpriteBlue.resize(100, 100);
  menuSpriteRed.resize(100, 100);
  title.resize(608, 258);
}


void draw(){
  if(stage == 0){
    background(0);
    image(menuSpriteBlue, menuSpriteBlueX, 800);
    image(menuSpriteRed, menuSpriteRedX, 800);
    image(title, 228,titleY);
    float error = 130 - menuSpriteRedX;
    double velocity = error * 0.12; 
    menuSpriteBlueX-=velocity;
    menuSpriteRedX+=velocity;
    titleY+=15;
    if(menuSpriteRedX >= 125) {
      stage++;
      menuSpriteBlue = loadImage("./assets/blue.jpg");
      menuSpriteRed = loadImage("./assets/redReversed.jpg");
      menuSpriteBlue.resize(100, 100);
      menuSpriteRed.resize(100, 100);
    }
  }else if(stage == 1){
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
      level = new LevelHandler(selector);
      red.otherControl = blue;
      blue.otherControl = red;
      stage++;
    }
  }else if(stage == 2){ //using if statement cuz i prefer its syntax (switch case is ugly)
    //the Nth index of the sequence = (n)*(n + 1)/2
    //triangle numbers sequence
    level.update();
    red.update();
    blue.update();
    fill(0);
    transitionCounter--;
    if(transitionCounter > 58){
      rect(500, 450, 25, 25);
    }
    if(transitionCounter > 56){
      rect(500, 425, 25, 25);
      rect(475, 450, 25, 25);
      rect(525, 450, 25, 25);
      rect(500, 475, 25, 25);
    }
    if(transitionCounter > 55){
      rect(500, 400, 25, 25);
      rect(525, 425, 25, 25);
      rect(550, 450, 25, 25);
      rect(525, 475, 25, 25);
      rect(500, 500, 25, 25);
      rect(475, 475, 25, 25);
      rect(450, 450, 25, 25);
      rect(475, 425, 25, 25);
    }
    for(int i = 0; i< 4; i++){
      for(int j = 0; j<transitionCounter; j++){
        for(int h = 0; h<transitionCounter-j; h++){
          int x;
          int y;
          if(i % 2 == 0){
            x = (h % (j+1)) * 25;
          }else{
            x = 1000 - (h % (j+1)) * 25;
          }
          if(i >=2 ){
            y = (((j+1) % transitionCounter)) * 25;
          }else{
            y = 900 - (((j+1) % transitionCounter)) * 25;
          }
          rect(x, y, 25, 25);
        }
      }
    }
    if(transitionCounter == 0) {
      stage++;
    }
  }else if(stage == 3){
    level.update();
    red.update();
    blue.update();
    transitionCounter = 0;
  }else if(stage == 4){ //transition stage
    //the Nth index of the sequence = (n)*(n + 1)/2
    //triangle numbers sequence
    fill(0);
    transitionCounter++;
    for(int i = 0; i< 4; i++){
      for(int j = 0; j<transitionCounter; j++){
        for(int h = 0; h<transitionCounter-j; h++){
          int x;
          int y;
          if(i % 2 == 0){
            x = (h % (j+1)) * 25;
          }else{
            x = 1000 - (h % (j+1)) * 25;
          }
          if(i >=2 ){
            y = (((j+1) % transitionCounter)) * 25;
          }else{
            y = 900 - (((j+1) % transitionCounter)) * 25;
          }
          rect(x, y, 25, 25);
        }
      }
    }
    if(transitionCounter == 56) { //easiest workaround, trust
      rect(500, 400, 25, 25);
      rect(525, 425, 25, 25);
      rect(550, 450, 25, 25);
      rect(525, 475, 25, 25);
      rect(500, 500, 25, 25);
      rect(475, 475, 25, 25);
      rect(450, 450, 25, 25);
      rect(475, 425, 25, 25);
    }else if(transitionCounter == 57){
      rect(500, 425, 25, 25);
      rect(475, 450, 25, 25);
      rect(525, 450, 25, 25);
      rect(500, 475, 25, 25);
    }else if(transitionCounter == 58){
      rect(500, 450, 25, 25);
      stage=0;
    }
  }
}

void keyPressed(){
  char keyChar = Character.toLowerCase(key);
  if(stage == 0){

  }else if(stage == 3){
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
    }
  }else if(stage == 2){
    
  }
}

void keyReleased() {
  if(stage == 3){
    if ((Character.toLowerCase(key) == 'a' && red.getDirection() == -1) || (Character.toLowerCase(key) == 'd' && red.getDirection() == 1)) {
      red.setDirection(0);
    }
    if ((keyCode == RIGHT && blue.getDirection() == 1) || (keyCode == LEFT && blue.getDirection() == -1)){
      blue.setDirection(0);
    }
  }
}