float r,g,b,a; // rgba values for the splatters.
boolean continuous; // whether continuous stroke is enabled.
boolean help; // whether to display help.
boolean sort; // whether biggher spots are printed first.
boolean alpha; // whether alpha channel is used.
int diversity; // diversity of color.
 
void setup() {
  size(500,500);
  background(230,230,220);
  continuous = false;
  help = true;
  sort = false;
  alpha = true;
  diversity = 200;
  // original color for the splatters
  r = (randomGaussian()*(second()+minute()*60+hour()*3600))%255;
  g = (randomGaussian()*(second()+minute()*60+hour()*3600))%255;
  b = (randomGaussian()*(second()+minute()*60+hour()*3600))%255;
  a = (randomGaussian()*(second()+minute()*60+hour()*3600))%200+55;
  // instructions
  String s = "'r' - reset canvas\n'c' or right mouse button - toggle continuous stroke\n"+
             "'s' - uniformity of a single splatter\n"+
             "'a' - toggle transparency\n"+
             "Up/Down arrow key - higher/lower diversity\n";
  fill(65,55,55);
  text(s, width*0.2, height*0.4, width*0.8, height*0.3);
}
 
void draw() {
  if (continuous)
    splatter(mouseX,mouseY);
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
    noStroke();
    fill(r,g,b,a);
    ellipse(sx,sy,dia,dia);
    //int t0 = millis();
    //while (millis() < t0+td) {println(millis());}
    //td *= 1;
  }
}
