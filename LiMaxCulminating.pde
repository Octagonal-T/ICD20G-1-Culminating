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

//GLOBAL OBJECT VARIABLES
LevelHandler level;
Control red;
Control blue;

void setup(){
  size(1000, 900);
  red = new Control(0, 20, 70, 50);
  blue = new Control(1, 10, 10, 50);
}

void draw(){
  if(stage == 0){ //using if statement cuz i prefer its syntax (switch case is ugly)

    level = new LevelHandler(selector);
    stage++;
    red.otherControl = blue;
    blue.otherControl = red;
    //initialize & load level at end of select menu
  }else if(stage == 1){
    level.update();
    red.update();
    blue.update();
  }else if(stage == 2){

  }else if(stage == 3){

  }
}

void keyPressed(){
  char keyChar = Character.toLowerCase(key);
  if(stage == 0){

  }else if(stage == 1){
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
  if(stage == 1){
    if ((Character.toLowerCase(key) == 'a' && red.getDirection() == -1) || (Character.toLowerCase(key) == 'd' && red.getDirection() == 1)) {
      red.setDirection(0);
    }
    if ((keyCode == RIGHT && blue.getDirection() == 1) || (keyCode == LEFT && blue.getDirection() == -1)){
      blue.setDirection(0);
    }
  }
}