public class Door{
  int x;
  int y;
  int xLength;
  int yLength;
  int direction;
  int state; //state machine: 0: closed, 1: opened, 2: opening
  public Door(JSONObject data){ //parses the json data
    //set x and y to the coordinates
    x = data.getJSONArray("coordinates").getInt(0);
    y = data.getJSONArray("coordinates").getInt(1);
    //set height and width, as well as direction
    xLength = data.getInt("width");
    yLength = data.getInt("height");
    direction = data.getInt("direction");
    state = 0;
  }
  public void open(){ //open function
    arrowHit.play(); //play the sound
    //if the state of the door is closed, set it to opening
    if(state == 0) state = 2;
  }
  public void render(){ //render function
    if(state == 2){ //if the door is opening
      if(direction == 1){ //if the door opens to the top, increase the y and decrease the height
        y+=1;
        yLength-=1;
      }else{ //else just decrease the height
        yLength-=1;
      }
      if(yLength < 0) state = 1; //if the door is now opened, set the state to opened
    }
    fill(0);
    rect(x, y, xLength, yLength); //draw the door
  }
  public int[][] getCoords(){ //return the coordinates
    return new int[][] {{x, y}, {x + xLength, y + yLength}};
  }
}