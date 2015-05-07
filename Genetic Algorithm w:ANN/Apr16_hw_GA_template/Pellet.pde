class Pellet {
  
  float x, y, r, value;
  float red, green, blue;
  boolean visible;
  
  Pellet(Float _x, float _y, float _value) {
    x = _x;
    y = _y;
    r = 5;
    value = _value;
    visible = true;
    if (value < 0) {
      red = 1.0; green = 0.0; blue = 0.0;  // pellets with negative values are red
    } else {
      red = 0.0; green = 1.0; blue = 0.0;  // pellets with positive values are green
    }
  }
    
  void display() {
    if (visible) {
      fill(255*red, 255*green, 255*blue);
      ellipse(x, y, 2*r, 2*r);
    }
  }
}
