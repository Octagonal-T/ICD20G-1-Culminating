public class Control{
  int direction = 0; //-1 = left, 0 = not moving, 1 = right
  float x; 
  float y;
  int size;
  boolean reversed;
  boolean dying = false;
  float[][] dyingCubes =  new float[10][3];
  int dyingFrames = 0;

  float jumpTarget;
  float jumpVelocity;
  final float gravityIncrement = 0.3;
  boolean jumping = false;
  float groundY = 0;

  int colour;
  Control otherControl;

  PImage[] images;
  public Control(int colour, int x, int y, int size){ //colour, 0 = red, 1 = blue (too lazy to make an enum)
    this.colour = colour;
    images = new PImage[2];
    if(colour == 0){ //if the character is red, load the red images
      images[0] = loadImage("./assets/red.jpg");
      images[1] = loadImage("./assets/redReversed.jpg");
    }else{ //if not, load the blue images
      images[0] = loadImage("./assets/blue.jpg");
      images[1] = loadImage("./assets/blueReversed.jpg");
    }
    images[0].resize(size, size);
    images[1].resize(size, size);
    this.x = x;
    this.y = y;
    this.size = size;
  }
  
  public void update(){
    if(!dying){ //if the character is not in its dying animation
      if(this.direction == -1 && checkCollision(-1)){ //if the character is going left and there's nothing blocking it from doing so,
        this.reversed = true;
        this.x -=5; //go left
      }else if(this.direction == 1 && checkCollision(1)){ //else if the character is going right and there's nothing blocking it from doing so,
        this.reversed = false;
        this.x +=5; //go right
      }
      
      if(jumping && checkCollision(2)){ //if the character is jumping and there's nothing blocking it from doing so,
        double error = this.jumpTarget - this.y; //create a P loop to slowly approach the target jump height
        this.y += error * 0.2;
        this.jumpVelocity = 0;
        if(Math.abs(error) < 0.5) jumping = false; //if the error of the jump is 0.5 pixels away, start falling
      }else{ //if not jumping
        jumping = false;
        if(checkCollision(3)){ //if there's nothing from blocking it from falling
          this.jumpVelocity+=this.gravityIncrement; //increase the velocity by the constatnt gravity increment
          this.y += this.jumpVelocity; //increase the y by the velocity
          if(!checkCollision(3)) { //if we are at the ground now, 
            this.y = this.groundY;
            this.jumpVelocity = 0; //reset the jump velocity
          }
        }
      }
      render();//render
    }else{ //if we are dying
      dyingFrames++; //create a dying frames variable
      if(dyingFrames == 100) stage++; //once 100 frames have passed of the dying animation, increase the stage
      else{ //if weare not done dying,
        for(int i = 0; i<dyingCubes.length; i++){ //for each dyinc cube
          if(colour == 1){ //change colour to matching colour
            fill(0, 0, 255);
          }else fill(255, 0, 0);
          rect(dyingCubes[i][0], dyingCubes[i][1], 10, 10); //draw small rects of the dying cubes
          dyingCubes[i][1] += dyingCubes[i][2]; //increase the y value by the speed factor
        }
      }
    }
  }

  private void render(){
    if(reversed){ //render the images
      image(images[1], x, y);
    }else{
      image(images[0], x, y);
    }
  }


  //this method is very confusing, my bad
  //i made this very convoluted, will try and make more efficient if possible
  private boolean checkCollision(int boundary){ //2 = top, 3 = bottom, -1 = left, 1 = right (too lazy to make an enum)
    ArrayList<int[][]> walls = level.getWalls();
    ArrayList<Door> doors = level.getDoors();
    //basically, for each boundary, it checks all doors, walls, and edges of the application to make sure that the character is allowed to move in that boundary
    if(boundary == 2){
      if(this.y < otherControl.getPos()[1] + this.size && this.y > otherControl.getPos()[1]-this.size){
        if(this.x < otherControl.getPos()[0] + this.size && this.x > otherControl.getPos()[0]-this.size){
          if(this.y > otherControl.getPos()[1]){
            return false;
          }
        }
      }
      for(int[][] wall : walls){
        int yPos = wall[0][1];
        int xPos = wall[0][0];
        if(this.y >= yPos && this.y <= wall[1][1]){
          if(this.x > xPos - this.size && this.x < wall[1][0]){
            return false;
          }
        }
      }
      for(Door doorObj : doors){
        int[][] door = doorObj.getCoords();
        int yPos = door[0][1];
        int xPos = door[0][0];
        if(this.y >= yPos && this.y <= door[1][1]){
          if(this.x > xPos - this.size && this.x < door[1][0]){
            return false;
          }
        }
      }
      return true;
    }else if(boundary == 3){ //return true if not on ground or another object
      if(this.y <= otherControl.getPos()[1] + this.size && this.y >= otherControl.getPos()[1]-this.size){
        if(this.x < otherControl.getPos()[0]+this.size && this.x > otherControl.getPos()[0]-this.size){
          if(this.y <= otherControl.getPos()[1]){
            this.groundY = otherControl.getPos()[1] - this.size;
            return false;
          }
        }
      }
      for(int[][] wall : walls){
        int yPos = wall[0][1];
        int xPos = wall[0][0];
        if(this.y >= yPos - this.size && this.y <= yPos){
          if(this.x > xPos - this.size && this.x < wall[1][0]){
            this.groundY = yPos - this.size;
            return false;
          }
        }
      }
      for(Door doorObj : doors){
        int[][] door = doorObj.getCoords();
        int yPos = door[0][1];
        int xPos = door[0][0];
        if(this.y >= yPos - this.size && this.y <= yPos){
          if(this.x > xPos - this.size && this.x < door[1][0]){
            this.groundY = yPos - this.size;
            return false;
          }
        }
      }
      boolean atGround = this.y < height - this.size;
      if(!atGround) this.groundY = height - this.size;
      return atGround;
    }else if(boundary == -1){
      boolean checkX = (this.x >= otherControl.getPos()[0] + this.size || this.x <= otherControl.getPos()[0]);
      boolean checkY = (this.y >= otherControl.getPos()[1] + this.size || this.y <= otherControl.getPos()[1]-this.size);
      for(int[][] wall : walls){
        int yPos = wall[0][1];
        int xPos = wall[0][0];
        if(this.x <= wall[1][0]&& this.x > xPos){
          if(this.y > yPos -this.size && this.y < wall[1][1]){
            return false;
          }
        }
      }
      for(Door doorObj: doors){
        int[][] door = doorObj.getCoords();
        int yPos = door[0][1];
        int xPos = door[0][0];
        if(this.x <= door[1][0]&& this.x > xPos){
          if(this.y > yPos -this.size && this.y < door[1][1]){
            return false;
          }
        }
      }
      if(!checkX) checkX = checkY;
      return this.x > 0 && checkX; 
    }else if(boundary == 1){
      boolean checkX = (this.x >= otherControl.getPos()[0] || this.x <= otherControl.getPos()[0] - this.size);
      boolean checkY = (this.y >= otherControl.getPos()[1] + this.size || this.y <= otherControl.getPos()[1]-this.size);
      if(!checkX) checkX = checkY;
      for(int[][] wall : walls){
        int yPos = wall[0][1];
        int xPos = wall[0][0];
        if(this.x >= xPos - this.size && this.x < wall[1][0]){
          if(this.y > yPos -this.size && this.y < wall[1][1]){
            return false;
          }
        }
      }
      for(Door doorObj : doors){
        int[][] door = doorObj.getCoords();
        int yPos = door[0][1];
        int xPos = door[0][0];
        if(this.x >= xPos - this.size && this.x < door[1][0]){
          if(this.y > yPos -this.size && this.y < door[1][1]){
            return false;
          }
        }
      }
      return this.x < width - this.size && checkX; 
    }
    return true;
  }

  //GETTERS & SETTERS
  public void jump(){
    if(!checkCollision(3)){ //if we are on the ground
      this.jumping = true;
      this.jumpTarget = this.y - 100; //set the target to 100 pixels above where we are
      this.jumpVelocity = 2;
    }
  } 
  public void die(){ //dying method
    playerDie.play(); //play the death sound
    this.dyingFrames = 0;
    this.dying = true;
    this.jumpVelocity = 0;
    for(int i=0; i<dyingCubes.length; i++){ //for each dying cube, randomize the x, y and speed values
      dyingCubes[i] = new float[]{random(this.x, this.x + 50), random(this.y, this.y + 50), random(2, 10)};
    }
  }
  public boolean isDying(){
    return this.dying;
  }
  public void setDirection(int dir){
    this.direction = dir;
  }
  public int getDirection(){
    return this.direction;
  }
  public boolean getReversed(){
    return this.reversed;
  }
  public float[] getPos(){
    return new float[] {this.x, this.y};
  }
  public void setPos(int[] pos){
    this.dying = false;
    this.x = pos[0];
    this.y = pos[1];
  }
}