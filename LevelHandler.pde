import java.util.Arrays;
BufferedReader reader;
public class LevelHandler{
  //LOCAL LEVEL OBJECTS
  int[][] startingPos = new int[2][2];
  int[][] endingPos = new int[2][2];

  int[] doorHeight = {-55, -55};
 
  ArrayList<int[][]> walls = new ArrayList<int[][]>();
  ArrayList<int[][]> spikes = new ArrayList<int[][]>();
  ArrayList<String> doors = new ArrayList<String>(); 
  ArrayList<String> levers = new ArrayList<String>(); 
  ArrayList<String> buttons = new ArrayList<String>();
  ArrayList<String> targets = new ArrayList<String>();

  public LevelHandler(int level){ //LEVEL LOADER

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
    red.setPos(startingPos[0]);
    blue.setPos(startingPos[1]);

    reader = createReader("./levels/" + level + "/walls.json"); 
    JSONArray wallsJSON;
    try{
      wallsJSON = parseJSONObject(reader.readLine()).getJSONArray("walls"); //returns a 3d array lol
    }catch(IOException e){ //only throws ioexception if file not found, but will still throw it if it's not in a try catch lmao
      wallsJSON = null; 
    }
    for(int i = 0; true; i++){
      JSONArray wallJSON;
      try{
        wallJSON = wallsJSON.getJSONArray(i);
      }catch(RuntimeException e){
        break;
      }
      if(wallJSON != null){
        int[][] wall = new int[2][2];
        for(int j = 0; j<2; j++){
          JSONArray wallPoint = wallJSON.getJSONArray(j);
          for(int h = 0; h<2; h++){
            wall[j][h] = wallPoint.getInt(h);
          }
        }
        fill(0);
        walls.add(wall);
      }else{
        break;
      }
    }

        reader = createReader("./levels/" + level + "/spikes.json"); 
    JSONArray spikesJSON;
    try{
      spikesJSON = parseJSONObject(reader.readLine()).getJSONArray("spikes"); //returns a 3d array lol
    }catch(IOException e){ //only throws ioexception if file not found, but will still throw it if it's not in a try catch lmao
      spikesJSON = null; 
    }
    for(int i = 0; true; i++){
      JSONArray spikeJSON;
      try{
        spikeJSON = spikesJSON.getJSONArray(i);
      }catch(RuntimeException e){
        break;
      }
      if(spikeJSON != null){
        int[][] spike = new int[2][2];
        for(int j = 0; j<2; j++){
          JSONArray spikePoint = spikeJSON.getJSONArray(j);
          for(int h = 0; h<2; h++){
            spike[j][h] = spikePoint.getInt(h);
          }
        }
        fill(0);
        spikes.add(spike);
      }else{
        break;
      }
    }
  }
  public void update(){
    background(255);
    fill(0);
    for(int[][] wall : walls){
      rect(wall[0][0], wall[0][1], wall[1][0] - wall[0][0], wall[1][1] - wall[0][1]);
    }
    fill(123,252,18);
    noStroke();
    for(int[][] spike : spikes){
      rect(spike[0][0], spike[0][1], spike[1][0] - spike[0][0], spike[1][1] - spike[0][1]);
    }

    for(int i = 0; i<2; i++){
      int[] endPos = endingPos[i];
      float[] pos = i == 0 ? red.getPos() : blue.getPos();
      if(i == 1){
        fill(0, 0, 255);
      }else fill(255, 0, 0);
      boolean flag = false;
      if(pos[0] <= endPos[0] + 50 && pos[0] >= endPos[0] - 50){
        if(pos[1] <= endPos[1] && pos[1] >= endPos[1] - 55){
          flag = true;
          doorHeight[i] += 0.1;
        }
      }
      if(!flag && doorHeight[i] != -55) {
        doorHeight[i] -= 1;
      }
      rect(endPos[0], endPos[1], 50, doorHeight[i]);
    }
    for(int i = 0; i<2; i++){
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

    for(int[][] spike : spikes){
      for(int i = 0; i<2; i++){
        Control cube = i == 0 ? red : blue;
        float[] pos = cube.getPos();
        if(pos[0] < spike[1][0] && pos[0] > spike[0][0] - 50 && pos[1] < spike[1][1] && pos[1] > spike[0][1] - 50 && !cube.isDying()){
          cube.die();
        }
      }
    }
  }

  //GETTERS AND SETTERS
  public ArrayList<int[][]> getWalls(){
    return walls;
  }
}