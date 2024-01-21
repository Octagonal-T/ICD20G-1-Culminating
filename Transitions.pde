int transitionCounter = 60;
//in the pattern N, transitionCounter is the ith index of N, and we will increment or decrement it
//starts at 60 bcuz the first method that will be run is opentransition, which goes backwards in the sequence N
boolean closeTransition(){ //return true when finished
  fill(0);
  transitionCounter++; //increment transitioncounter
  for(int i = 0; i< 4; i++){ //for each corner
    for(int j = 0; j<transitionCounter; j++){ //for each row
      for(int h = 0; h<transitionCounter-j; h++){ //for each column
        int x;
        int y;
        if(i % 2 == 0){ //if the corner is top left or bottom left
          x = (h % (j+1)) * 25; //set x to the hth % j+1 block
        }else{
          x = 1000 - (h % (j+1)) * 25; //if not, set x to 1000 - 5th % j + 1 block
        }
        if(i >=2){ //if the corner is top left or top right
          y = (((j+1) % transitionCounter)) * 25; //set the y to the jth +1 % the current tarnsiton counter
        }else{ //if not, set y to 900 - that
          y = 900 - (((j+1) % transitionCounter)) * 25;
        }
        rect(x, y, 25, 25); //draw the rectangle at x, y
      }
    }
  }
  //there's a bug that misses the center few blocks, and i spent way too long trying to fix it, and in the end i just did this:
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
    return true;
  }
  return false;
}

boolean openTransition(){ //return true when finished
  //same as closeTranstion() except reversed
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
    return true;
  }
  return false;
}