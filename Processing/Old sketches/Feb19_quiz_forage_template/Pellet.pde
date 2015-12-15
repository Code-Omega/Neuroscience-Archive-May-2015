class Pellet {
  
  PVector location;
  float r;
  
  Pellet() {
    location = new PVector(random(width), random(height));
    r = 5;
  }
   
  void display() {
    noStroke();
    fill(50, 250, 50);
    ellipse(location.x, location.y, 2*r, 2*r);
  }
}
