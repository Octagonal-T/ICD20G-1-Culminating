public class Arrow{
  PImage arrow;
  float xGraph = 0;
  float xOrigin;
  float yOrigin;
  float x;
  float y;
  boolean reversed; //true = right false = left
  public Arrow(float x, float y, boolean reversed){
    this.x = x;
    this.y = y;
    this.xOrigin = x;
    this.yOrigin = y;
    this.reversed = reversed;
    arrow = loadImage("./assets/arrow.png");
    arrow.resize(60, 21);
  }
  public void update(){
    xGraph+= reversed? 10 : -10;
    x = xOrigin + xGraph;
    y = yOrigin - curve(xGraph);
    imageMode(CENTER);
    translate(x, y);
    pushMatrix();
    rotate(-angle(xGraph));
    image(arrow, 0, 0);
    rotate(angle(xGraph));
    popMatrix();
    translate(-x, -y);
    imageMode(CORNER);
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
    //find slope of tangent line by subsituting x value into the derivative function of the curve,
    //then take arctan of slope to convert into a radian value
  }
}