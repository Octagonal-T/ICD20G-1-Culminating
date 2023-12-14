import java.util.Arrays;
BufferedReader reader;
public class LevelHandler{
  //LOCAL LEVEL OBJECTS
  int[][] startingPos = new int[2][2];
  int[][] endingPos = new int[2][2];

  ArrayList<Integer[][]> walls = new ArrayList<Integer[][]>();
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
      wallsJSON = parseJSONObject(reader.readLine()).getJSONArray("walls");
    }catch(IOException e){
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
        System.out.println(i);
        fill(0);
        rect(wall[0][0], wall[0][1], wall[1][0] - wall[0][0], wall[1][1] - wall[0][1]);
      }else{
        break;
      }
    }
  }
  public void update(){
    // background(255);
  }
}