float r,g,b,a; // rgba values for the splatters.
boolean continuous; // whether continuous stroke is enabled.
boolean help; // whether to display help.
boolean sort; // whether biggher spots are printed first.
boolean alpha; // whether alpha channel is used.
boolean dynamic; // whether blobs move around.
boolean wrap; // whether blobs wrap around.
boolean bounce; // whether blobs bounce around.
int diversity; // diversity of color.
ArrayList<Blob> bList;
 
void setup() {
  size(500,500);
  background(230,230,220);
  continuous = false;
  help = true;
  sort = false;
  alpha = true;
  diversity = 200;
  dynamic = true;
  wrap = false;
  bounce = true;
  // original color for the splatters
  r = (randomGaussian()*(second()+minute()*60+hour()*3600))%255;
  g = (randomGaussian()*(second()+minute()*60+hour()*3600))%255;
  b = (randomGaussian()*(second()+minute()*60+hour()*3600))%255;
  a = (randomGaussian()*(second()+minute()*60+hour()*3600))%200+55;
  displayInstructions();
  bList = new ArrayList<Blob>();
}
 
void draw() {
  if (continuous)
    splatter(mouseX,mouseY);
  if (dynamic){
    background(230,230,220);
    for (Blob b : bList){
      b.update();
      b.display();
    }
    if (help){
      displayInstructions();
    }
    if (bounce){
      for (Blob b : bList)
        b.bounce();
    }
    else if(wrap){
      for (Blob b : bList)
        b.wrap();
    }
    else {
      ArrayList<Integer> bListBoundary = new ArrayList<Integer>();
      int idx = 0;
      for (Blob b : bList){
        if (b.boundary());
          bListBoundary.add(idx);
        idx++;
      }
      for (int i = bListBoundary.size()-1; i >= 0; i--){
        bList.remove(bListBoundary.get(i));
      }
    }
  }
}
 
void keyPressed() {
  // reset canvas
  if (key == 'r') {
    background(230,230,220);
    String s = "'r' - reset canvas\n'c' or right mouse button - continuous stroke\n"+
               "'s' - uniformity of a single splatter\n"+
               "'a' - toggle transparency\n"+
               "Up/Down arrow key - higher/lower diversity\n";
    fill(65,55,55);
    text(s, width*0.2, height*0.4, width*0.8, height*0.3);
  }
  // toggle continuous stroke
  else if (key == 'c') {
    continuous = !continuous;
  }
  else if (key == 's') {
    sort = !sort;
  }
  else if (key == 'a') {
    alpha = !alpha;
  }
  else if (key == 'h') {
    help = !help; 
  }
  else if (key == 'd') {
    dynamic = !dynamic;
  }
  else if (key == 'b') {
    bounce = !bounce;
    wrap = false;
  }
  else if (key == 'w') {
    wrap = !wrap;
    bounce = false;
  }
  else if (key == CODED) {
    if (keyCode == UP) {
      diversity *= 1.1;
    } else if (keyCode == DOWN) {
      diversity *= 0.9;
    } 
  }
}
 
void mouseClicked() {
  // paint at the cursor location
  if (mouseButton == LEFT)
    splatter(mouseX, mouseY);
  // toggle continuous stroke
  else if (mouseButton == RIGHT)
    continuous = !continuous;
}
 
void splatter(float mx,float my) {
  // set diameters of spots
  int numSplatter = int(randomGaussian()*10+50);
  float[] splatters = new float[numSplatter];
  for (int i = 0; i < numSplatter; i++){
    splatters[i] = abs(randomGaussian()*width/random(40,50));
  }
  if (sort)
    splatters = sort(splatters);
  //println(splatters);
  //int td = 5;
  // print spots from the largest to the smallest
  for (int i = numSplatter-1; i >= 0; i--) {
    // assign location
    float dia = splatters[i];
    float sx = randomGaussian()*(width/5/dia)+mx;
    float sy = randomGaussian()*(width/5/dia)+my;  
    // apply change to color  
    int j = int(random(4));
    switch (i){
      case 0:
        r = constrain((randomGaussian()*diversity*(abs(mx-width/2)*abs(my-height/2))/width/height+r), 0, 255);
        break;
      case 1:
        g = constrain((randomGaussian()*diversity*(abs(mx-width/2)*abs(my-height/2))/width/height+g), 0, 255);
        break;
      case 2:
        b = constrain((randomGaussian()*diversity*(abs(mx-width/2)*abs(my-height/2))/width/height+b), 0, 255);
        break;
      case 3:
        if (alpha)
            a = constrain((randomGaussian()*diversity*(abs(mx-width/2)*abs(my-height/2))/width/height+a), 55, 255);
        else a = 255;
    }
    // draw spot
    if (!dynamic){
      noStroke();
      fill(r,g,b,a);
      ellipse(sx,sy,dia,dia);
    }
    bList.add(new Blob(sx,sy,r,g,b,a,dia));
    //int t0 = millis();
    //while (millis() < t0+td) {println(millis());}
    //td *= 1;
  }
}

class Blob {
  PVector pos;
  PVector vel;
  float dia;
  color cfill;
  
  Blob(float x,float y,float r,float g,float b,float a,float d){
    pos = new PVector(x, y);
    vel = new PVector(random(-1.0,1.0), random(-1.0,1.0));
    dia = d;
    cfill =color(r,g,b,a);
  }
  
  void update(){
    pos.add(vel);
  }
  void wrap(){
    if (pos.x>width+dia/2 || pos.x<0-dia/2) pos.x = width-pos.x;
    if (pos.y>height+dia/2 || pos.y<0-dia/2) pos.y = height-pos.y;
  }
  void bounce(){
    if (pos.x>width-dia/2 || pos.x<dia/2) vel.x *= -1;
    if (pos.y>height-dia/2 || pos.y<dia/2) vel.y *= -1;
  }
  boolean boundary(){
    if (pos.x>width+dia || pos.x<0-dia || pos.y>height+dia || pos.y<0-dia)
      return true;
    return false;
  }
  
  void display(){
    noStroke();
    fill(cfill);
    ellipse(pos.x,pos.y,dia,dia);
  }

}

void displayInstructions(){
  String s = "'r' - reset canvas\n'c' or right mouse button - toggle continuous stroke\n"+
             "'s' - uniformity of a single splatter (slow on sketchpad)\n"+
             "'a' - toggle transparency\n"+
             "'h' - toggle instructions and status\n"+
             "'d' - toggle blob dynamic\n"+
             "'w' - toggle wrap\n"+
             "'b' - toggle bounce\n"+
             "Up/Down arrow key - higher/lower diversity\n";
  fill(65,55,55);
  text(s, width*0.14, height*0.4, width*0.8, height*0.3);
  String stat = (sort?"S ":"")+(alpha?"A ":"")+(help?"H ":"")+(dynamic?"D ":"")+(wrap?"W ":"")+(bounce?"B ":"")+("diversity: "+diversity);
  fill(65,55,55);
  text(stat, width*0.7, height*0.02, width*0.4, height*0.2);
}
