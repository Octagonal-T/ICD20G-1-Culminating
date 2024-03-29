public class Arrow{
  PImage arrow;
  float xGraph = 0;
  float xOrigin;
  float yOrigin;
  float x;
  float y;
  boolean reversed; //true = right false = left
  boolean moving = true;
  boolean hitTarget = false;

  //math constants
  final float beta = (float) Math.atan(25.5/2.5); //see line 48 for explanation
  final float d = (float) (Math.sqrt(2729) / 2); // see line 47 for explanation

  public Arrow(float x, float y, boolean reversed){
    this.x = x;
    this.y = y;
    this.xOrigin = x;
    this.yOrigin = y;
    this.reversed = reversed; 
    //if the arrow is going reversed, load the reversed image
    arrow = loadImage(reversed ? "./assets/arrow.png" : "./assets/arrowReversed.png");
    arrow.resize(51, 5);
  }
  public void update(){ //update method
    //find the new angle of the arrow, by finding the slope of the derivative function at that x point 
    float angleNew = angle(xGraph);
    //find the y value by folling the curve at that x value
    float yValue = curve(xGraph);
    if(moving) { //if the arrow is not in a wall,
      moving = checkCollision(angleNew); //check collision with all walls and doors and targets
      if(!moving){ //if we've hit something,
        if(!hitTarget){ //if we havent hit a target
          arrowStop.play(); //play the sound
        }
      }else{ //if we havent hit anything
        xGraph+= reversed? 10 : -10; //increase the x value by 10
        x = xOrigin + xGraph; //set the x value to the origin x plsu the x graph
        y = yOrigin - yValue; //set the y value to the origin y plus the y value
      }
    }
    //translate and draw the arrow
    imageMode(CENTER);
    translate(x, y);
    pushMatrix(); 
    rotate(-angleNew);
    image(arrow, 0, 0);
    rotate(angleNew);
    popMatrix();
    translate(-x, -y);
    imageMode(CORNER);
  }


  //source: https://en.wikipedia.org/wiki/Rotation_matrix#In_two_dimensions 

  //in rectangle ABCD, rotated positive theta degrees so that the top of the rect is going towards the right, where A is the topmost point, B is the point immediately to the right, and so on,
  //we need to find the coordiantes of the verticies of this rectangle when oriented this way, to be able to check for collision with these verticies.
  //let O be the origin of the rectangle. let E be the midpoint of line AC, and F be the midpoint of line CD. 
  //line OA = sqrt(AE^2 + CF^2) / 2. let d represent the line OA.
  //let beta represent the angle EOA. beta = arctan(EA/CF)

  //the translation of the following verticies, in relation to the origin, is below:
  //A: [-d * sin(theta + beta), -d * cos(theta + beta)]
  //B: [d * sin(theta + beta), d * cos(theta + beta)]
  //C: [-d * sin(theta - beta), -d * cos(theta - beta)]
  //D: [d * sin(theta - beta), d * cos(theta - beta)]

  private boolean checkCollision(float theta){
    ArrayList<int[][]> walls = level.getWalls();
    ArrayList<Door> doors = level.getDoors();
    ArrayList<int[]> targets = level.getTargets();

    float[] pointSide = new float[2];
    float[] pointTop = new float[2];

    //find outermost point of the arrow (either right side or left, depending on the direction of the arrow)
    //the math is not affected if the arrow is reversed or not, since sin(pi-theta) = sin(theta) in quadrants 1 and 2. 
    if(reversed){ //if the arrow is reversed (going to the right), vertex that the arrow will be following is point B. 
      pointSide = new float[] {(float) (x + (d * Math.sin(theta + beta))), (float) (y + (d * Math.cos(theta + beta)))}; //calculate the B point
      pointTop = new float[] {(float) (x + (-d * Math.sin(theta - beta))), (float) (y + (-d * Math.cos(theta - beta)))}; //calculate the A point
    }else{ // if the arrow is going to the left, the vertex that the arrow will be follwing is point A.
      pointSide = new float[] {(float) (x + (d * Math.sin(theta - beta))), (float) (y + (d * Math.cos(theta - beta)))}; //calculate the D point
      pointTop = new float[] {(float) (x + (-d * Math.sin(theta + beta))), (float) (y + (-d * Math.cos(theta + beta)))}; //calculate the C point
    }
    if(theta > 0){ //if arrow is going up
      for(int[][] wall : walls){ //check the collision against the walls
        if(pointTop[0] >= wall[0][0] && pointTop[0] <= wall[1][0]){
          if(pointTop[1] <= wall[1][1] && pointTop[1] >= wall [0][1]){
            return false;
          }
        }
        if(pointSide[1] <= wall[1][1] && pointSide[1] >= wall[0][1]){
          if(pointSide[0] >= wall[0][0] && pointSide[0] <= wall[1][0]){
            return false;
          }
        }
      }
      for(Door doorObj : doors){ //check the collision against the doors
        int[][] door = doorObj.getCoords();
        int yPos = door[0][1];
        int xPos = door[0][0];
        if(pointSide[0] >= xPos && pointSide[0] <= door[1][0]){
          if(pointSide[1] <= door[1][1] && pointSide[1] >= yPos){
            return false;
          }
        }
        if(pointTop[1] <= door[1][1] && pointTop[1] >= yPos){
          if(pointTop[0] >= xPos && pointTop[0] <= door[1][0]){
            return false;
          }
        }
      }
      for(int[] target : targets){ //check the collision agianst the targets
        int i = targets.indexOf(target);
        if(pointTop[1] >= target[1] && pointTop[1] <= target[1] + 50){
          if(pointSide[0] >= target[0] && pointSide[0] <= target[0]+10){ //if we've hit a target, open the corresponding door
            doors.get(i).open();
            hitTarget = true;
            return false;
          }
        }
      }
    }else{ //if arrow is going down
      for(int[][] wall : walls){
        if(pointSide[0] >= wall[0][0] && pointSide[0] <= wall[1][0]){
          if(pointSide[1] <= wall[1][1] && pointSide[1] >= wall [0][1]){
            return false;
          }
        }
        if(pointTop[1] <= wall[1][1] && pointTop[1] >= wall[0][1]){
          if(pointTop[0] >= wall[0][0] && pointTop[0] <= wall[1][0]){
            return false;
          }
        }
      }
      for(Door doorObj : doors){
        int[][] door = doorObj.getCoords();
        int yPos = door[0][1];
        int xPos = door[0][0];
        if(pointSide[1] >= yPos && pointSide[1] <= door[1][0]){
          if(pointSide[0] <= door[1][1] && pointSide[0] >= door [0][1]){
            return false;
          }
        }
        if(pointTop[0] <= door[1][1] && pointTop[0] >= xPos){
          if(pointTop[1] >= yPos && pointTop[1] <= door[1][0]){
            return false;
          }
        }
      }
      for(int[] target : targets){
        int i = targets.indexOf(target);
        if(pointSide[1] >= target[1] && pointSide[1] <= target[1] + 50){
          if(pointTop[0] >= target[0] && pointTop[0] <= target[0]+10){
            doors.get(i).open();
            hitTarget = true;
            return false;
          }
        }
      }
    }
    if(pointSide[0] <= 0 || pointSide[0] >= width) return false; //if the arrow is in the wall, return false
    if(pointTop[1] <= 0 || pointTop[1] >= height) return false; //if the arrow is at the roof or the ground, return false
    return true;
  }

  //curve used is y = -0.04 (0.2x-50)^2 + 100
  //desmos graph w/ tangent line: https://www.desmos.com/calculator/vtce006pgp
  private float curve(float xValue){
    if(reversed){
      return (float) (-0.04* Math.pow((0.2*xValue) - 70.71, 2)+ 200);
    }else{
      return (float) (-0.04* Math.pow((0.2*xValue) + 70.71, 2) + 200);
    }
  }
  private float angle(float x){
    if(reversed){
      return (float) (Math.atan(-0.0032*x+1.13136)); 
    }else{
      return (float) (Math.atan(-0.0032*x-1.13136));
    }
    //find slope of tangent line at the current x value by subsituting x value into the derivative function of the curve,
    //then take arctan of slope to convert into a radian value
  }
}