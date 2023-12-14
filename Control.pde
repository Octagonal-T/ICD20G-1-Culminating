public class Control{
  int direction = 0; //-1 = left, 0 = not moving, 1 = right
  float x; 
  float y;
  int size;
  boolean reversed;

  double jumpTarget;
  double jumpVelocity;
  final double gravityIncrement = 0.3;
  boolean jumping = false;

  Control otherControl;

  PImage[] images;
  public Control(int colour, int x, int y, int size){ //colour, 0 = red, 1 = blue
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
    

    if(jumping){
      double error = this.jumpTarget - this.y;
      this.y += error * 0.2;
      if(Math.abs(error) < 0.5) jumping = false;
    }else{
      if(checkCollision(3)){
        this.jumpVelocity+=this.gravityIncrement;
        this.y += this.jumpVelocity;
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

  private boolean checkCollision(int boundary){ //2 = top, 3 = bottom, -1 = left, 1 = right
    if(boundary == 2){

    }else if(boundary == 3){
      boolean checkY = (this.y + this.size > otherControl.getPos()[1] || this.y < otherControl.getPos()[1] + this.size);
      System.out.println(this.y + this.size > otherControl.getPos()[1]);
      if(!checkY){
        checkY = (this.x > otherControl.getPos()[0] + this.size || this.x < otherControl.getPos()[0]);
      }
      return this.y < height - this.size && checkY;
    }else if(boundary == -1){
      boolean checkX = (this.x > otherControl.getPos()[0] + this.size || this.x < otherControl.getPos()[0]);
      boolean checkY = (this.y > otherControl.getPos()[1] + this.size || this.y < otherControl.getPos()[1]-this.size);
      if(!checkX) checkX = checkY;
      return this.x > 0 && checkX; 
      //insert check with walls
    }else if(boundary == 1){
      boolean checkX = (this.x > otherControl.getPos()[0] || this.x < otherControl.getPos()[0] - this.size);
      boolean checkY = (this.y > otherControl.getPos()[1] + this.size || this.y < otherControl.getPos()[1]-this.size);
      if(!checkX) checkX = checkY;

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
  public double[] getPos(){
    return new double[] {this.x, this.y};
  }
}