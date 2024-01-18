public class Door{
  int x;
  int y;
  int xLength;
  int yLength;
  int direction;
  int state; //state machine: 0: closed, 1: opened, 2: opening
  public Door(JSONObject data){
    x = data.getJSONArray("coordinates").getInt(0);
    y = data.getJSONArray("coordinates").getInt(1);
    xLength = data.getInt("width");
    yLength = data.getInt("height");
    direction = data.getInt("direction");
    state = 0;
  }
  public void open(){
    if(state == 0) state = 2;
  }
  public void render(){
    if(state == 2){
      if(direction == 1){
        y+=1;
        yLength-=1;
      }else{
        yLength-=1;
      }
      if(yLength < 0) state = 1;
    }
    fill(0);
    rect(x, y, xLength, yLength);
  }
  public int[][] getCoords(){
    return new int[][] {{x, y}, {x + xLength, y + yLength}};
  }
}