/* 
 Feb 19 Homework Assignment (due Feb 24 midnight)
 
 Create a small ecosystem with 3 species: 
 volvox - small, green algae
 fish   - medium, eat algae, avoid sharks
 shark  - large, eats fish, ignores algae
 
 Include lots of algae, several fish and just one shark.
 
 Use several of Reynold's steering behaviors to control the 
 behavior of your agents (seek, flee, pursue, evade, wander,
 flow field following, flocking, path following, etc.)
 
 Consider using different values of max speed and 
 max acceleration (max force) for the different species.
 
 Example ideas:
 algea could move slowly in a flow field, fish could school
 and seek algae unless a shark is nearby in which case they 
 should evade the predator, the shark could follow a fixed path
 through the environment until it got close to some fish, in 
 which case it could switch to pursuit.
 
 Adjust the level of complexity to match your programming skills.
 This is an open-ended assignment. Be creative and have fun.
 
 Start simple!!
 
 WHEN YOU SUBMIT YOUR HOMEWORK, PLEASE PROVIDE A SHORT TEXT
 DESCRIPTION IN THE EMAIL THAT SUMMARIZES THE BEHAVIORS THAT
 YOU IMPLEMENTED FOR EACH SPECIES.
 
 */
 
int NVOLVOX = 100;
//int NFISH = 30;
int NFISH = 30;
int NSHARK = 0;

ArrayList<Volvox> volvoxArray;
ArrayList<Fish> fishArray;
ArrayList<Shark> sharkArray;
FlowField ff;

void setup() {
  size(600, 400);
  ff = new FlowField(10);
  volvoxArray = new ArrayList<Volvox>();
  fishArray = new ArrayList<Fish>();
  sharkArray = new ArrayList<Shark>();
  for (int i=0; i<NVOLVOX; i++) volvoxArray.add(new Volvox());
  for (int i=0; i<NFISH; i++) fishArray.add(new Fish());
  for (int i=0; i<NSHARK; i++) sharkArray.add(new Shark());
}

void draw() {
  // display
  background(30);
  
  int newV = 0;
  int newF = 0;
  int newS = 0;

  for (int j = fishArray.size()-1; j>=0; j--) {
    Fish f = fishArray.get(j);
    if (f.energy <= 0) {
        fishArray.remove(j);
    }
  }
  
  for (int k = volvoxArray.size()-1; k>=0; k--) {
    Volvox v = volvoxArray.get(k);
    if (v.energy <= 0.1) {
      volvoxArray.remove(k);
    }
  }

  
  for (int i = sharkArray.size()-1; i>=0; i--) {
    Shark s = sharkArray.get(i);
    if (s.energy <= 0) {
      sharkArray.remove(i);
    }
    for (int j = fishArray.size()-1; j>=0; j--) {
      Fish f = fishArray.get(j);
      float dj = f.location.dist(s.location);
      if (dj < f.r + s.r) {
        s.energy += f.energy*0.1;
        fishArray.remove(j);
      }
      for (int k = volvoxArray.size()-1; k>=0; k--) {
        Volvox v = volvoxArray.get(k);
        float dk = f.location.dist(v.location);
        if (dk < f.r + v.r) {
          f.energy += v.energy*0.1;
          volvoxArray.remove(k);
          newV++;
        }
      }
    }
  }
  
  for (Volvox v : volvoxArray) {
    v.display();
    v.update();
    confine(v);
    /*if (frameCount%30 < 1) {
      v.energy -= 1000.0*(volvoxArray.size()+1)/(width*height);
    if (v.energy > 0.30) newV++;}*/
  }
  for (Fish f : fishArray) {
    f.display();
    f.update();
    confine(f);
    if (frameCount%50 < 1) {f.energy -= 0.05;
    if (f.energy > 5) {newF++; f.energy -= 4;}}
  }
  for (Shark s : sharkArray) {
    s.display();
    s.update();
    confine(s);
    if (frameCount%50 < 1) {s.energy -= 0.4;
    if (s.energy > 20) {newS++; s.energy -= 14;}}
  }
  
  for (int i = 0; i < newV; i++) volvoxArray.add(new Volvox());
  for (int j = 0; j < newF; j++) fishArray.add(new Fish());
  for (int k = 0; k < newS; k++) sharkArray.add(new Shark());
}

void confine(Fish b) {
  float r = b.r;
  if (b.location.x < r/2) b.location.x = r/2;
  if (b.location.x > width - r/2) b.location.x =  width - r/2;
  if (b.location.y < r/2) b.location.y = r/2;
  if (b.location.y > height - r/2) b.location.y = height - r/2;
}

void confine(Shark b) {
  float r = b.r;
  if (b.location.x < r/2) b.location.x = r/2;
  if (b.location.x > width - r/2) b.location.x =  width - r/2;
  if (b.location.y < r/2) b.location.y = r/2;
  if (b.location.y > height - r/2) b.location.y = height - r/2;
}

void confine(Volvox b) {
  float r = b.r;
  if (b.location.x < r/2) b.location.x = r/2;
  if (b.location.x > width - r/2) b.location.x =  width - r/2;
  if (b.location.y < r/2) b.location.y = r/2;
  if (b.location.y > height - r/2) b.location.y = height - r/2;
}

void keyPressed() {
  if (key == 'p' || key == ' ') {
    paused = !paused;
    if(!paused) loop();
  }
}

