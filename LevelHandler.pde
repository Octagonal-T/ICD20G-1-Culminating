import java.util.Arrays;
BufferedReader reader;
public class LevelHandler{
  //LOCAL LEVEL OBJECTS
  int[][] startingPos = new int[2][2];
  int[][] endingPos = new int[2][2];

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
  }
  public void update(){
    background(255);
  }
}