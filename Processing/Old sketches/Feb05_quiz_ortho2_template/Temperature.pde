class Temperature {
  // 2D Perlin noise
  float xoff, yoff;
  float xscale, yscale;
  float tmin, tmax;

  Temperature(float _xoff, float _yoff, float _xscale, float _yscale) {
    xoff = _xoff;
    yoff = _yoff;
    xscale = _xscale;
    yscale = _yscale;
    tmin = 1.0;
    tmax = 0.0;
  }

  float getVal(float _x, float _y) {
    return noise(xoff + xscale * _x, yoff + yscale * _y);
  }

  PImage getImage(int _left, int _upper, int _width, int _height) {
    pushStyle();
    colorMode(HSB, 360, 1, 1);
    PImage img = createImage(width, height, RGB);
    for (int i = 0; i < width; i++) {
      for (int j = 0; j < height; j++) {
        float data = getVal(_left + i, _upper + j);
        if (data < tmin) tmin = data;
        if (data > tmax) tmax = data;
        float hue = constrain(330 - 300*data, 0, 360);
        float bright = constrain(0.2 + data, 0, 1);
        color c = color(hue, 1.0, bright);
        img.set(i, j, c);
      }
    }
    popStyle();
    return img;
  }
}

