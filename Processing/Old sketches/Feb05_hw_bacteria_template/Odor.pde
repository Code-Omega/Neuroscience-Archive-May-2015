class Odor {
  // 2D Gaussian odor profile, centered at (xc,yc) 
  // peak amplitude = 1.0;
  float xc, yc, sigma;
  float omin, omax;
  float omin_noise, omax_noise;
  float xscale, yscale;

  Odor(float _xc, float _yc, float _sigma, float _xscale, float _yscale) {
    xc = _xc;
    yc = _yc;
    sigma = _sigma;
    omin = omin_noise = 1.0;
    omax = omax_noise = 0.0;
    xscale = _xscale;
    yscale = _yscale;
  }

  float getVal(float x, float y) {
    if (!map) {return noise(xc + xscale * x, yc + yscale * y);}
    float num = sq(x-xc) + sq(y-yc);
    float denom = 2*sq(sigma);
    //return exp(-num/denom);
    return exp(-num/denom) + random(-0.03, 0.03);
  }

  PImage getImage() {
    pushStyle();
    map = true;
    PImage img = createImage(width, height, RGB);
    for (int ix = 0; ix<width; ix++) {
      for (int iy = 0; iy<height; iy++) {
        float value = getVal(ix, iy);
        if (value < omin) omin = value;
        if (value > omax) omax = value;
        img.set(ix, iy, color(0, 255*value, 0));
      }
    }
    map = false;
    popStyle();
    return img;
  }

  PImage getNoiseImage() {
    pushStyle();
    map = false;
    colorMode(HSB, 360, 1, 1);
    PImage img = createImage(width, height, RGB);
    for (int i = 0; i < width; i++) {
      for (int j = 0; j < height; j++) {
        float data = getVal(i, j);
        if (data < omin_noise) omin_noise = data;
        if (data > omax_noise) omax_noise = data;
        float hue = constrain(330 - 300*data, 0, 360);
        float bright = constrain(0.2 + data, 0, 1);
        color c = color(hue, 1.0, bright);
        img.set(i, j, c);
      }
    }
    map = true;
    popStyle();
    return img;
  }
}

