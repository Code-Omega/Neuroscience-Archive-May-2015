class Light {
  
  float x, y, intensity;
  
  Light(float _x, float _y, float _intensity) {
    x = _x;
    y = _y;
    intensity = _intensity;
  }
  
  float getVal(float _xpos, float _ypos) {
    // return light intensity at location (xpos, ypos)
    // based on an inverse-square relationship
    float r = dist(x, y, _xpos, _ypos); // distance to source
    return (r < 1) ? intensity : intensity / (r * r);
  }
  
  void display() {
    // draw a diffuse yellow light using alpha shading
    pushStyle();
    noStroke();
    for (float d=50.0; d>1.0; d-=2.0){
      float alpha = 255.0/d;
      fill(255, 255, 0, alpha);
      ellipse(x, y, d, d);
    }
    popStyle();
  }
  
}
