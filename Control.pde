public class Control{
  int direction = 0; //-1 = left, 0 = not moving, 1 = right
  float x; 
  float y;
  int size;
  boolean reversed;

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
    if(colour == 0){
      images[0] = loadImage("./assets/red.jpg");
      images[1] = loadImage("./assets/redReversed.jpg");
    }else{
      images[0] = loadImage("./assets/blue.jpg");
      images[1] = loadImage("./assets/blueReversed.jpg");
    }
    images[0].resize(size, size);
    images[1].resize(size, size);
    this.x = x;
    this.y = y;
    this.size = size;
  }
  
  void update(){
    if(this.direction == -1 && checkCollision(-1)){
      this.reversed = true;
      this.x -=5;
    }else if(this.direction == 1 && checkCollision(1)){
      this.reversed = false;
      this.x +=5;
    }
    

    if(jumping && checkCollision(2)){
      double error = this.jumpTarget - this.y;
      this.y += error * 0.2;
      if(Math.abs(error) < 0.5) jumping = false;
    }else{
      jumping = false;
      if(checkCollision(3)){
        this.jumpVelocity+=this.gravityIncrement;
        this.y += this.jumpVelocity;
        if(!checkCollision(3)) this.y = this.groundY;
      }
    }
    render();
  }

  private void render(){
    if(reversed){
      image(images[1], x, y);
    }else{
      image(images[0], x, y);
    }
  }


  //this method is very confusing, my bad
  //i made this very convoluted, will try and make more efficient if possible
  private boolean checkCollision(int boundary){ //2 = top, 3 = bottom, -1 = left, 1 = right (too lazy to make an enum)
    ArrayList<int[][]> walls = level.getWalls();
    if(boundary == 2){
      if(this.y < otherControl.getPos()[1] + this.size && this.y > otherControl.getPos()[1]-this.size){
        if(this.x < otherControl.getPos()[0]+this.size && this.x > otherControl.getPos()[0]-this.size){
          if(this.y > otherControl.getPos()[1]){
            return false;
          }
        }
      }
      return this.y > 0;
    }else if(boundary == 3){ //return true if not on ground or another object
      if(this.y <= otherControl.getPos()[1] + this.size && this.y >= otherControl.getPos()[1]-this.size){
        if(this.x <= otherControl.getPos()[0]+this.size && this.x >= otherControl.getPos()[0]-this.size){
          if(this.y <= otherControl.getPos()[1]){
            this.groundY = otherControl.getPos()[1] - this.size;
            return false;
          }
        }
      }
      for(int[][] wall : walls){
        int yPos = wall[0][1];
        int xPos = wall[0][0];
        if(this.y >= yPos - this.size && this.y <= wall[1][1]){
          if(this.x >= xPos - this.size && this.x <= wall[1][0]){
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
        if(this.x <= wall[1][0]&& this.x >= xPos){
          if(this.y > yPos -this.size && this.y < wall[1][1]){
            return false;
          }
        }
      }
      if(!checkX) checkX = checkY;
      return this.x > 0 && checkX; 
      //insert check with walls
    }else if(boundary == 1){
      boolean checkX = (this.x >= otherControl.getPos()[0] || this.x <= otherControl.getPos()[0] - this.size);
      boolean checkY = (this.y >= otherControl.getPos()[1] + this.size || this.y <= otherControl.getPos()[1]-this.size);
      if(!checkX) checkX = checkY;
      for(int[][] wall : walls){
        int yPos = wall[0][1];
        int xPos = wall[0][0];
        if(this.x <= wall[1][0]&& this.x >= xPos - this.size){
          if(this.y > yPos -this.size && this.y < wall[1][1]){
            return false;
          }
        }
      }
      //insert check with walls
      return this.x < width - this.size && checkX; 
    }
    return true;
  }

  //GETTERS & SETTERS
  public void jump(){
    if(!checkCollision(3)){
      this.jumping = true;
      this.jumpTarget = this.y - 100;
      this.jumpVelocity = 2;
    }
  }
  public void setDirection(int dir){
    this.direction = dir;
  }
  public int getDirection(){
    return this.direction;
  }
  public float[] getPos(){
    return new float[] {this.x, this.y};
  }
  public void setPos(int[] pos){
    this.x = pos[0];
    this.y = pos[1];
  }
}