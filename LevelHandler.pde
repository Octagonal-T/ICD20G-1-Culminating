import java.util.Arrays;
BufferedReader reader;

public class LevelHandler{ //create class level handler
  //LOCAL LEVEL OBJECTS
  int[][] startingPos = new int[2][2];
  int[][] endingPos = new int[2][2];

  int[] doorHeight = {-55, -55};
 
  int level;

  //create array list of objects for the level
  ArrayList<int[][]> walls = new ArrayList<int[][]>();
  ArrayList<int[][]> spikes = new ArrayList<int[][]>();
  ArrayList<Door> doors = new ArrayList<Door>(); 
  ArrayList<int[]> targets = new ArrayList<int[]>();
  ArrayList<Arrow> arrows = new ArrayList<Arrow>();


  public LevelHandler(int level){ //LEVEL LOADER
    this.level = level;
    //parse level data file
    reader = createReader("./levels/" + level + "/levelData.json");
    JSONObject levelDataJSON;
    try{
      levelDataJSON = parseJSONObject(reader.readLine());
    }catch(IOException e){
      levelDataJSON = null;
    }

    //parse starting positions
    JSONArray startingPosJSON = levelDataJSON.getJSONArray("startingPos");
    for(int i = 0; i<2; i++){
      JSONArray characterStartingPosJSON = startingPosJSON.getJSONArray(i);
      for(int j = 0; j<2; j++){
        startingPos[i][j] = characterStartingPosJSON.getInt(j);
      }
    }

    //parse ending positions
    JSONArray endingPosJSON = levelDataJSON.getJSONArray("endingPos");
    for(int i = 0; i<2; i++){
      JSONArray characterEndingPosJSON = endingPosJSON.getJSONArray(i);
      for(int j = 0; j<2; j++){
        endingPos[i][j] = characterEndingPosJSON.getInt(j);
      }
    }
    //set the positions of red and blue to their starting postitions
    red.setPos(startingPos[0]);
    blue.setPos(startingPos[1]);

    //parse walls json
    reader = createReader("./levels/" + level + "/walls.json"); 
    JSONArray wallsJSON;
    try{
      wallsJSON = parseJSONObject(reader.readLine()).getJSONArray("walls"); //returns a 3d array lol
    }catch(IOException e){ //only throws ioexception if file not found, but will still throw it if it's not in a try catch lmao
      wallsJSON = null; 
    }
    //for each wall
    for(int i = 0; true; i++){
      JSONArray wallJSON;
      try{
        wallJSON = wallsJSON.getJSONArray(i);
      }catch(RuntimeException e){
        break;
      }
      if(wallJSON != null){ //if the wall exists
        int[][] wall = new int[2][2]; //create 2d array
        for(int j = 0; j<2; j++){ //for each vertex
          JSONArray wallPoint = wallJSON.getJSONArray(j);
          for(int h = 0; h<2; h++){ //parse the vertex into the 2d array
            wall[j][h] = wallPoint.getInt(h);
          }
        }
        fill(0);
        walls.add(wall); //add 2d array to arraylist
      }else{ //else break
        break;
      }
    }

    //parse spikes json
    reader = createReader("./levels/" + level + "/spikes.json"); 
    JSONArray spikesJSON;
    try{
      spikesJSON = parseJSONObject(reader.readLine()).getJSONArray("spikes"); //returns a 3d array lol
    }catch(IOException e){ //only throws ioexception if file not found, but will still throw it if it's not in a try catch lmao
      spikesJSON = null; 
    }
    //for each spike
    for(int i = 0; true; i++){
      JSONArray spikeJSON;
      try{
        spikeJSON = spikesJSON.getJSONArray(i);
      }catch(RuntimeException e){
        break;
      }
      if(spikeJSON != null){ //if the spike exists
        int[][] spike = new int[2][2]; //create 2d array
        for(int j = 0; j<2; j++){ //for each vertex
          JSONArray spikePoint = spikeJSON.getJSONArray(j);
          for(int h = 0; h<2; h++){
            spike[j][h] = spikePoint.getInt(h); //parse the vertex
          }
        }
        fill(0);
        spikes.add(spike); //add the arary to the arraylist
      }else{ //if not, break
        break;
      }
    }

    //parse doors json
    reader = createReader("./levels/" + level + "/doors.json"); 
    JSONArray doorsJSON;
    try{
      doorsJSON = parseJSONObject(reader.readLine()).getJSONArray("doors");
    }catch(IOException e){ //only throws ioexception if file not found, but will still throw it if it's not in a try catch lmao
      doorsJSON = null; 
    }
    for(int i = 0; true; i++){ //for each door
      JSONObject doorJSON = new JSONObject();
      try{
        doorJSON = doorsJSON.getJSONObject(i);
      }catch(RuntimeException e){
        break;
      }
      if(doorJSON != null){ //if door exists
        //send json to the door constructor for it to parse
        doors.add(new Door(doorJSON));
      }else{ //else break
        break;
      }
    }

    //parse targets json
    reader = createReader("./levels/" + level + "/targets.json"); 
    JSONArray targetsJSON;
    try{
      targetsJSON = parseJSONObject(reader.readLine()).getJSONArray("targets");
    }catch(IOException e){ //only throws ioexception if file not found, but will still throw it if it's not in a try catch lmao
      targetsJSON = null; 
    }
    //for each target
    for(int i = 0; true; i++){
      JSONArray targetJSON = new JSONArray();
      try{
        targetJSON = targetsJSON.getJSONArray(i);
      }catch(RuntimeException e){
        break;
      }
      if(targetJSON != null){ //if the target exists,
        //add a new 2d array to the arraylist
        targets.add(new int[] {targetJSON.getInt(0), targetJSON.getInt(1)});
      }else{ //else break
        break;
      }
    }
  }
  public void update(){ //update function, gets called every tick
    //reset the background
    background(255);
    fill(0);
    //draw all the walls
    for(int[][] wall : walls){
      rect(wall[0][0], wall[0][1], wall[1][0] - wall[0][0], wall[1][1] - wall[0][1]);
    }
    fill(123,252,18);
    noStroke();
    //draw all the spikes
    for(int[][] spike : spikes){
      rect(spike[0][0], spike[0][1], spike[1][0] - spike[0][0], spike[1][1] - spike[0][1]);
      for(int i = 0; i<2; i++){ //check if either character is touching a spike, if so, make them die
        Control cube = i == 0 ? red : blue;
        float[] pos = cube.getPos();
        if(pos[0] < spike[1][0] && pos[0] > spike[0][0] - 50 && pos[1] < spike[1][1] && pos[1] > spike[0][1] - 50 && !cube.isDying()){
          cube.die();
        }
      }
    }

    //draw the end doors
    for(int i = 0; i<2; i++){
      int[] endPos = endingPos[i];
      float[] pos = i == 0 ? red.getPos() : blue.getPos();
      if(i == 1){
        fill(0, 0, 255);
      }else fill(255, 0, 0);
      boolean flag = false;
      if(pos[0] <= endPos[0] + 50 && pos[0] >= endPos[0] - 50){ //if the character is within the door
        if(pos[1] <= endPos[1] && pos[1] >= endPos[1] - 55){
          flag = true;
          doorHeight[i] += 0.1; //raise the door
        }
      }
      if(!flag && doorHeight[i] != -55) { //if the character is not in the door, and the door isn't all the way down,
        doorHeight[i] -= 1; //close the door
      }
      rect(endPos[0], endPos[1], 50, doorHeight[i]);// draw the doors
    }
    for(int i = 0; i<2; i++){ //draw the frames of the doors
      int[] endPos = endingPos[i];
      if(i == 1){
        fill(30, 70, 155);
      }else fill(204, 65, 37);
      beginShape();
      vertex(endPos[0]-25, endPos[1]);
      vertex(endPos[0]-25, endPos[1]-80);
      vertex(endPos[0]+75, endPos[1]-80);
      vertex(endPos[0]+75, endPos[1]);
      vertex(endPos[0]+50, endPos[1]);
      vertex(endPos[0]+50, endPos[1]-55);
      vertex(endPos[0], endPos[1]-55);
      vertex(endPos[0], endPos[1]);
      endShape();
    }
    if(doorHeight[0] == 0 && doorHeight[1] == 0) { //if both doors are all th way up, change the level stage to the end stage
      stage = 6;
    }
    for(Door door : doors){ //for each non ending door, render them
      door.render();
    }
    for(int[] target : targets){ //draw each target
      fill(0);
      rect(target[0], target[1], 10, 50);
      fill(255, 0, 0);
      rect(target[0]+2, target[1]+10, 6, 30);
    }
    for(Arrow arrow : arrows){ //update each arrow
      arrow.update();
    }
  }

  //GETTERS AND SETTERS
  public ArrayList<int[][]> getWalls(){
    return walls;
  }
  public ArrayList<Door> getDoors(){
    return doors;
  }
  public ArrayList<Arrow> getArrows(){
    return arrows;
  }
  public void addArrow(Arrow arrow){
    arrows.add(arrow);
  }
  public ArrayList<int[]> getTargets(){
    return targets;
  }
}