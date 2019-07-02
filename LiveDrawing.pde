// ENTER NAME
String name = "Sophie";
// ENTER NAME


ArrayList<brush> strokes = new ArrayList();
PImage img = new PImage();
color c;
int numOfBrushes = 1;
int maxBrushes = 50;
int arrayNum;
ArrayList<String> files = new ArrayList();
int totalScore = 0;
int currentScore;
boolean gameOver = false;
//String path = sketchPath();
ArrayList<brush> newStrokes = new ArrayList();
boolean show = false;
String path = "C:\\Users\\razat\\OneDrive\\Documents\\Processing\\Code\\LiveDrawing\\data";
String scoreFolder = "C:\\Users\\razat\\OneDrive\\Documents\\Processing\\Code\\LiveDrawing\\scores\\";
int roundsPlayed = 0;
int scorePer = 2500;

void setup() {

  currentScore = scorePer;
  String[] fileNames = listFileNames(path);
  for (String s : fileNames) {
    files.add(s);
  }
  arrayNum = int(random(0, files.size()));
  img = loadImage(files.get(arrayNum));
  size(700, 700);
  img.resize(width, height);

  background(0);
  noStroke();
  for (int i = 0; i < numOfBrushes; i++) {

    strokes.add(new brush(width/2, height/2, new PVector(cos(2*PI/numOfBrushes * i)*4, sin(2*PI/numOfBrushes * i)*4)));
  }
  c = color(random(0, 255), random(0, 255), random(0, 255));
}

void draw() {

  if (roundsPlayed<5) {
    if (show) {
      image(img, 0, 0);
      textSize(30);
      text("+"+currentScore, width/2-50, height/2-55);
      text(files.get(arrayNum).substring(0, files.get(arrayNum).length()-4), width/2-50, height/2-20);
      text("Press enter to continue",width/2-140, height/2+40);
    } else {

      for (brush b : strokes) {
        b.drawStroke(colorAt(int(b.x), int(b.y)));
      }


      for (int i = 0; i < 2; i++) {
        try {
          if (strokes.get(i).hitWall && strokes.size()<maxBrushes)
            newStrokes.add(new brush(int(strokes.get(i).x), int(strokes.get(i).y), new PVector(width/2 - strokes.get(i).x, height/2 - strokes.get(i).y).normalize()));
        }
        catch(Exception e) {
        }
      }
      for (brush b : newStrokes) {
        strokes.add(b);
      }
      newStrokes.clear();
      fill(255);
      rect(0, height, 80, -70);
      fill(0);
      textSize(12);
      text("Score:" + currentScore, 0, height -40);
      text("Total:" + totalScore, 0, height -20);

      currentScore--;

      if (!show && currentScore==-1) {
        roundsPlayed++;
        show = true;
        totalScore+=currentScore;
     
        currentScore--;
      }
    }
  } else {
    background(0);
    fill(255);
    textSize(30);
    text("Total Score:\n" + totalScore, width/2-50, height/2-20 );
  }
}
color colorAt(int x, int y) {
  float red = 0;
  float green = 0;
  float blue = 0;
  int counter = 0;
  for (int i = -1; i <=1; i++) {
    for (int j = -1; j <=1; j++) {
      try {
        red += red(img.pixels[(y+i)*width+x+j]);
        green += green(img.pixels[(y+i)*width+x+j]);
        blue += blue(img.pixels[(y+i)*width+x+j]);
        counter++;
        //return color(img.pixels[(y)*width+x]);
      }
      catch(Exception e) {
      }
    }
  }
  return color(red/counter, green/counter, blue/counter);
}
String typed = "";
boolean correct = false;
void keyPressed() {
  if (keyCode == BACKSPACE && typed.length() >= 1) {
    typed = typed.substring(0, typed.length()-1);
  } else if (keyCode == ENTER) {
    if (files.get(arrayNum).equals((typed.trim()+".jpg").toLowerCase())) {
      roundsPlayed++;
      correct = true;
    }
    typed="";
  } else if (keyCode == DELETE) {
    roundsPlayed++;
    if (roundsPlayed<5) {
      files.remove(files.get(arrayNum));
      if (roundsPlayed<5) {
        arrayNum = int(random(0, files.size()));
      } else {
        gameOver = true;
      }

      background(0);
      currentScore = scorePer;
      img = loadImage(files.get(arrayNum));
      img.resize(width, height);
      background(0);
      strokes.clear();
      for (int i = 0; i < numOfBrushes; i++) {
        strokes.add(new brush(width/2, height/2));
      }
      show = false;
      correct = false;
    }
  } else if (key != '' && key !='?') {
    typed = typed+key;
  }
  println(typed);
  if (correct) { 

    if (!show) {
      println(files.get(arrayNum));
      show = true;
      totalScore+=currentScore;
    } else if (roundsPlayed<5) {
      files.remove(files.get(arrayNum));
      if (roundsPlayed<5) {
        arrayNum = int(random(0, files.size()));
      } else {
        gameOver = true;
      }

      background(0);
      currentScore = scorePer;
      img = loadImage(files.get(arrayNum));
      img.resize(width, height);
      background(0);
      strokes.clear();
      for (int i = 0; i < numOfBrushes; i++) {
        strokes.add(new brush(width/2, height/2));
      }
      show = false;
      correct = false;
    }
  } else if (show) {

    files.remove(files.get(arrayNum));
    if (roundsPlayed<5) {
      arrayNum = int(random(0, files.size()));
    } else {
      gameOver = true;
    }

    background(0);
    currentScore = scorePer;
    img = loadImage(files.get(arrayNum));
    img.resize(width, height);
    background(0);
    strokes.clear();
    for (int i = 0; i < numOfBrushes; i++) {
      strokes.add(new brush(width/2, height/2));
    }
    show = false;
    correct = false;
  }

  if (roundsPlayed>=5) {
    gameOver = true; 
    OutputStream file = createOutput(scoreFolder + totalScore + " - " + name + ".txt");
    try {
      file.close();
    } 
    catch (Exception e) {
 
    }
  }
}

File[] listFiles(String dir) {
  File file = new File(dir);
  if (file.isDirectory()) {
    File[] files = file.listFiles();
    return files;
  } else {
    // If it's not a directory
    return null;
  }
}
String[] listFileNames(String dir) {
  File file = new File(dir);
  if (file.isDirectory()) {
    String names[] = file.list();
    return names;
  } else {
    // If it's not a directory
    return null;
  }
}
