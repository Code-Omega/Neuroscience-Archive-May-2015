void create_next_generation() {
  generation++;
  for (int i = 0; i < popSize; i++) {
    // tournament selection, k=2
    int a1 = int(random(popSize));
    int a2 = int(random(popSize));
    Bot parentA = bots[a1].fitness > bots[a2].fitness ? bots[a1] : bots[a2];
    int b1 = int(random(popSize));
    int b2 = int(random(popSize));
    Bot parentB = bots[b1].fitness > bots[b2].fitness ? bots[b1] : bots[b2];
    // give birth
    Bot child = crossover(parentA, parentB);
    child.iworld = i; // set world
    mutate(child, mutationRate);
    children[i] = child;
  }
  children[0] = bots[ibest]; // elitist - save best parent
  arrayCopy(children, bots); // copy the children back into the bots array
}

Bot crossover(Bot parentA, Bot parentB) {
  Bot child = new Bot(-1); // no world assignment yet
  int numGenes = parentA.numGenes;
  int crosspoint = 0;
  if (random(1) < crossoverProb) crosspoint = int(random(numGenes)); 
  for (int i = 0; i < numGenes; i++) {
    if (i < crosspoint) child.genes[i] = parentA.genes[i];
    else                child.genes[i] = parentB.genes[i];
  }
  return child;
}

void mutate(Bot b, float mutationRate) {
  int iworld = b.iworld;
  for (int i = 0; i < b.numGenes; i++) {
    if (random(1) < mutationRate) {
      float newval;
      float rn = random(1);
      // YOU MAY WANT TO CHANGE THIS   
      if (rn < 0.1) {
        newval = random(0.0, 1.0);
      } else {
        newval = b.genes[i] * random(0.9, 1.1);
      } 
      bots[iworld].genes[i] = constrain(newval, 0.0, 1.0);
    }
  }
}

