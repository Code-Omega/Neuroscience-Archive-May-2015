import controlP5.*;
ControlP5 cp5;
ControlFont cfont = new ControlFont(createFont("Arial", 14)); // controls font
ControlFont sfont = new ControlFont(createFont("Arial", 12)); // slider font

void add_gui() {
  cp5 = new ControlP5(this);
  
  addToggle("avoid", 420, 38, 80, 25);
  addBang("reset",   510, 5, 80, 25);
  addToggle("pause", 510, 38, 80, 25);
  addToggle("reassign_after_2500", 430, 390, 150, 25);
  
  addSlider("epsilon",        440,  70, 130, 10, 0.0, 0.5, 0.05);
  addSlider("beta",           440, 110, 130, 10, 0.0, 2.0, 0.25);
  
  addSlider("expected_red",   430, 150, 150, 10, -10.0, 10.0, 0.0);
  addSlider("expected_green", 430, 190, 150, 10, -10.0, 10.0, 0.0);
  addSlider("expected_blue",  430, 230, 150, 10, -10.0, 10.0, 0.0);
  
  addSlider("prob_red",   430, 270, 150, 10, 0.0, 1.0, 1.0/3);
  addSlider("prob_green", 430, 310, 150, 10, 0.0, 1.0, 1.0/3);
  addSlider("prob_blue",  430, 350, 150, 10, 0.0, 1.0, 1.0/3);
  
  // lock the sliders that are displaying expected values
  cp5.getController("expected_red").lock();
  cp5.getController("expected_green").lock();
  cp5.getController("expected_blue").lock();
  cp5.getController("prob_red").lock();
  cp5.getController("prob_green").lock();
  cp5.getController("prob_blue").lock();
}

void addBang(String name, int x, int y, int w, int h) {
  cp5.addBang(name).setPosition(x, y).setSize(w, h)
     .getCaptionLabel().toUpperCase(false).setFont(cfont)
     .align(ControlP5.CENTER, ControlP5.CENTER)
     ;
}

void addToggle(String name, int x, int y, int w, int h) {
  cp5.addToggle(name).setPosition(x, y).setSize(w, h)
     .getCaptionLabel().toUpperCase(false).setFont(cfont)
     .align(ControlP5.CENTER, ControlP5.CENTER)
     ;
}

void addSlider(String name, int x, int y, int w, int h, float vmin, float vmax, float v) {
  cp5.addSlider(name).setPosition(x, y).setSize(w, h)
     .setRange(vmin, vmax)
     .setValue(v)
     ;
  cp5.getController(name).getCaptionLabel()
     .toUpperCase(false).setFont(cfont)
     .align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingY(0)
     ;
  cp5.getController(name).getValueLabel()
     .toUpperCase(false).setFont(cfont)
     .align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingY(0)
     ;
}
