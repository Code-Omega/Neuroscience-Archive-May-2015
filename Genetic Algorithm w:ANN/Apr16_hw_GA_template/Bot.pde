class Bot {

  int iworld;  // each bot lives in its own world
  float x, y, r, heading, energy;
  float speed, turnAngle;
  
  // sense data (NR = Nearest RED, NG = Nearest GREEN)
  float SNS_RANGE = 100.0;
  float bearingNR, strengthNR;
  float bearingNG, strengthNG;
  
  // Info for Genetic Algorithm 
  int numGenes;
  float[] genes;  // gene sequence (genome)
  float fitness;

  Bot(int _iworld) {
    iworld = _iworld;
    reset();
    //numGenes = 28;  // YOU WILL NEED TO CHANGE THIS IF YOU ADD GENES
    //numGenes = 83;
    //numGenes = 6;
    //numGenes = 52;
    numGenes = 27;
    genes = new float[numGenes];
    for (int i = 0; i < numGenes; i++) {
      genes[i] = random(1.0);
    }
  }
  
  void reset() {
    x = width/2;
    y = height/2;
    r = 10;
    heading = 0;
    energy = 0.0;
    speed = 0.0;
    turnAngle = 0.0;
    fitness = 0.0;
    bearingNR = 0.0;
    strengthNR = 0.0;
    bearingNG = 0.0;
    strengthNG = 0.0;
  }
  
  void setpos(float _x, float _y, float _heading) {
    x = _x;
    y = _y;
    heading = _heading;
  }

  void update() {
    update_sensors();
    
    //-------------------------------------------------------------
    // MODIFY THIS SECTION 
    // compute speed and turnAngle using some combination of
    // gene parameter values and sensor values, then use the GA
    // to optimize performance.
    // Remember to set numGenes in the Constructor to match
    // the number of genes you are using
    // (You can add if-else structure here if you think it will help)
    
    //speed = genes[0]+genes[2]/strengthNG+genes[4]/strengthNR;
    //turnAngle = genes[1]-0.5+20.0*(genes[3]-0.5)*bearingNG+20.0*(genes[5]-0.5)*bearingNR;
    speed = neuralNet().x;
    turnAngle = neuralNet().y;
    
    
    
    //-------------------------------------------------------------

    speed = constrain(speed, -2.0, 2.0);
    turnAngle = constrain(turnAngle, -0.2, 0.2);
    heading += turnAngle;
    x += speed * cos(heading);
    y += speed * sin(heading);
    x = constrain(x, r, width-r);
    y = constrain(y, r, height-r);
    consume_pellets();
  }
      PVector neuralNet() {
        /*float i1, i2, i3, i4;
        float h1, h2, h3, h4, h5;
        float o1, o2;
        float[] genesTemp = new float[numGenes];
        for (int i = 0; i < numGenes; i++) {
          genesTemp[i] = 2.0*(genes[i]-0.5);
        }
        i1 = strengthNG; i2 = strengthNR; i3 = bearingNG; i4 = bearingNR;
        h1 = (i1*genesTemp[0]+i2*genesTemp[1]+i3*genesTemp[2]+i4*genesTemp[3]);
        h2 = (i1*genesTemp[4]+i2*genesTemp[5]+i3*genesTemp[6]+i4*genesTemp[7]);
        h3 = (i1*genesTemp[8]+i2*genesTemp[9]+i3*genesTemp[10]+i4*genesTemp[11]);
        h4 = (i1*genesTemp[12]+i2*genesTemp[13]+i3*genesTemp[15]+i4*genesTemp[16]);
        h5 = 1.0*genesTemp[17];
        //h4 = 0;
        o1 = h1*genesTemp[18]+h2*genesTemp[19]+h3*genesTemp[20]+h4*genesTemp[21]+h5*genesTemp[22];
        o2 = h1*genesTemp[23]+h2*genesTemp[24]+h3*genesTemp[25]+h4*genesTemp[26]+h5*genesTemp[27];
        return new PVector(o1, o2);*/
        
        /*float[] genesTemp = new float[numGenes];
        for (int i = 0; i < numGenes; i++) {
          genesTemp[i] = 2.0*(genes[i]-0.5);
        }
        float[] in = new float [8];
        in[0] = strengthNG; in[1] = strengthNR; in[2] = bearingNG; in[3] = bearingNR;
        in[4] = 1.0/strengthNG; in[5] = 1.0/strengthNR; in[6] = 1.0/bearingNG; in[7] = 1.0/bearingNR;
        float[] hn = new float [9];
        for (int i = 0; i < 8; i++) {
          for (int j = 0; j < 8; j++) {
            hn[i] += (in[j]*genesTemp[i*j+j]);
          }
        }
        hn[8] = 1.0*genesTemp[64];
        float o1, o2;
        o1 = o2 = 0;
        for (int i = 0; i < 9; i++) {
           o1 += hn[i]*genesTemp[65+i];
           o2 += hn[i]*genesTemp[65+i+9];
        }
        return new PVector(o1, o2);*/
        
        /*float[] genesTemp = new float[numGenes];
        for (int i = 0; i < numGenes; i++) {
          genesTemp[i] = 2.0*(genes[i]-0.5);
        }
        float[] in = new float [6];
        in[0] = strengthNG; in[1] = strengthNR; in[2] = bearingNG; in[3] = bearingNR;
        in[4] = 1.0/strengthNG; in[5] = 1.0/strengthNR;
        float[] hn = new float [7];
        for (int i = 0; i < 6; i++) {
          for (int j = 0; j < 6; j++) {
            hn[i] += (in[j]*genesTemp[i*j+j]);
          }
        }
        hn[6] = 1.0*genesTemp[36];
        float o1, o2;
        o1 = o2 = 0;
        for (int i = 0; i < 7; i++) {
           o1 += hn[i]*genesTemp[37+i];
           o2 += hn[i]*genesTemp[37+i+7];
        }
        return new PVector(o1, o2);*/
        
        float[] genesTemp = new float[numGenes];
        for (int i = 0; i < numGenes; i++) {
          genesTemp[i] = 2.0*(genes[i]-0.5);
        }
        float[] in = new float [4];
        in[0] = strengthNG; in[1] = strengthNR; in[2] = bearingNG; in[3] = bearingNR;
        //in[4] = 1.0/strengthNG; in[5] = 1.0/strengthNR; in[6] = 1.0/bearingNG; in[7] = 1.0/bearingNR;
        float[] hn = new float [5];
        for (int i = 0; i < 4; i++) {
          for (int j = 0; j < 4; j++) {
            hn[i] += (in[j]*genesTemp[i*j+j]);
          }
        }
        hn[4] = 1.0*genesTemp[16];
        float o1, o2;
        o1 = o2 = 0;
        for (int i = 0; i < 5; i++) {
           o1 += hn[i]*genesTemp[17+i];
           o2 += hn[i]*genesTemp[17+i+5];
        }
        return new PVector(o1, o2);
    }

  void consume_pellets() {
    for (int j = 0; j < numPellets; j++) {
      Pellet p = pellets[iworld][j];
      if (p.visible) {
        float d = dist(x, y, p.x, p.y);
        if (d < (r + p.r)) {
          p.visible = false;
          energy += p.value;
        } 
      }
    }
  }
  
  void update_sensors() {
    bearingNR = 0.0;
    bearingNG = 0.0;
    strengthNR = 0.0;
    strengthNG = 0.0;
    float dminR = width + height; 
    float dminG = width + height;
    for (int j = 0; j < numPellets; j++) {
      Pellet p = pellets[iworld][j];
      if (p.visible) {
        float d = dist(x, y, p.x, p.y);
        if (p.red > 0.9 && d < SNS_RANGE && d < dminR) {           // Nearest RED
          dminR = d;
          float delta = atan2(p.y-y, p.x-x) - heading;
          if (delta > PI) delta -= TWO_PI;
          if (delta < -PI) delta += TWO_PI;
          bearingNR = delta;
          strengthNR = 1.0/constrain(d-r-p.r, 1, SNS_RANGE);
        } else if (p.green > 0.9 && d < SNS_RANGE && d < dminG) {   // Nearest GREEN
          dminG = d;
          float delta = atan2(p.y-y, p.x-x) - heading;
          if (delta > PI) delta -= TWO_PI;
          if (delta < -PI) delta += TWO_PI;
          bearingNG = delta;
          strengthNG = 1.0/constrain(d-r-p.r, 1, SNS_RANGE);
        }
      }
    }
  }

  void display() {
    stroke(50);
    pushMatrix();
    translate(x, y);
    fill(50);
    textSize(12);
    text(nf(energy, 0, 0), r, r);
    rotate(heading);
    fill(250, 200, 50);
    ellipse(0, 0, 2*r, 2*r);
    line(0, 0, r, 0);
    popMatrix();
  }

  
}

