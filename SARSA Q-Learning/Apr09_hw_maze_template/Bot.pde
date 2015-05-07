class Bot {
  int ix, iy;   // location in maze
  int nstates, state;
  int last_action;
  float reward;
  float summed_reward;
  float alpha; // learning rate
  float gamma; // discount factor
  float epsilon; // epsilon-greedy parameter
  float[][] Q;

  Bot() {
    nstates = maze.nx * maze.ny;   
    Q = new float[nstates][4]; // 4 actions
    alpha = 0.6;
    gamma = 0.9;
    epsilon = 0.15;
    reset();
  }

  void reset() {
    home();
    resetQ();
  }

  void home() {
    // start in lower left corner
    ix = 1;
    iy = maze.ny - 2;
    state = ix + maze.ny*iy; // convert position to state
    last_action = 4; // NONE
    reward = 0.0;
    summed_reward = 0.0;
  }

  void resetQ() {
    for (int s=0; s<nstates; s++) {
      for (int a=0; a<4; a++) {
        Q[s][a] = 0.0;
      }
    }
  }


  void step() {
    int s0, s1, a0, a1;
    if (reward == maze.REWARD_VAL){  // reached the reward
      nextTrial();
    }
    s0 = state;
    a0 = pickAction();
    takeAction(a0); 
    s1 = state;
    a1 = pickAction();
    // RECODE THE FOLLOWING LINE TO CORRECTLY IMPLEMENT THE SARSA UPDATE RULE
    Q[s0][a0] = Q[s0][a0]+alpha*(reward+gamma*Q[s1][a1]-Q[s0][a0]);
  }

  int pickAction() {
    // RECODE THIS METHOD TO IMPLEMENT THE EPSILON-GREEDY ALGORITHM
    int maxIdx = 0;
    float maxVal = max(Q[state]);
    println(maxVal);
    for (int i = 0; i < 4; i++){ if (Q[state][i] == maxVal) maxIdx = i;}
    int action = (random(1.0) < epsilon) ? (int(random(4.0))) : maxIdx; // pick a random action
    println(action);
    return action;
  }

  void display() {
    // yellow circle
    fill(250, 250, 0);
    float r = maze.w/2;
    ellipse(maze.xc[ix][iy], maze.yc[ix][iy], r, r);
  }

  void takeAction(int action) {
    last_action = action;
    int xold = ix;
    int yold = iy;
    if (action == NORTH) iy--;
    if (action == SOUTH) iy++;
    if (action == EAST) ix++;
    if (action == WEST) ix--; 
    reward = maze.val[ix][iy];
    summed_reward += reward;
    // if bot runs into wall, move bot back
    if (maze.isWall(ix, iy)) {
      ix = xold;
      iy = yold;
    }
    state = ix + maze.ny*iy;
  }
}

