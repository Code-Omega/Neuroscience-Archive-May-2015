/*
Finite State Machine for bot behavior
Based on FSM code by Greg Borenstein at:
https://github.com/atduskgreg/Processing-FSM/blob/master/FSM.pde

*** YOU SHOULD NOT NEED TO EDIT ANYTHING IN THIS FSM MODULE ***

Usage:
In your bot class, declare one FSM controller and as many States as you need.

  FSM   controller;
  State wanderState = new State(this, "wander", "enterWander", "doWander", null);
  State spinState = new State(this, "spin", "enterSpin", "doSpin", null);

To initialize a State you pass in the parent bot, a string representing the name of the behavioral state,
and three strings representing the names of the enter/execute/exit methods for that state. 
Any of these three methods can be specified as null if not needed.

The first method will be called once each time the FSM enters this state. (enter function)
The second method will be called repeated as long as the FSM stays in this state. (execute function)
The third method will be called one when the FSM transitions away from this state. (exit function)

When you initialize the FSM, you must specify the initial state:

    FSM controller;
    controller = new FSM(wanderState);
    
To transition to a different state:
    controller.transitionTo(someState);
    
To get the current state of the FSM::
    controller.getCurrentState();
    
To test if the FSM is in some particular state:
    if(controller.isInState(someState){
      // do something
    }

*/

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

class FSM {
  State currentState;

  FSM(State initialState) {
    currentState = initialState;
    currentState.enterFunction();
  }

  void update() {
    currentState.executeFunction();
  }

  State getCurrentState() {
    return currentState;
  }

  boolean isInState(State state) {
    return currentState == state;
  }

  void transitionTo(State newState) {
    currentState.exitFunction();
    currentState = newState;
    currentState.enterFunction();
  }
}

class State {
  Cell    parent;
  String name;
  Method enterFunction;
  Method executeFunction;
  Method exitFunction;

  State(Cell b, String stateName, String enterFunctionName, String executeFunctionName, String exitFunctionName) {

    parent = b;
    name = stateName;
    Class botClass = parent.getClass();

    if (enterFunctionName == null) {
      enterFunction = null;
    } else {
      try { 
        enterFunction = botClass.getMethod(enterFunctionName);
      }
      catch(NoSuchMethodException e) {
        println("enter function is missing.");
      }
    }
    
    if (executeFunctionName == null) {
      executeFunction = null;
    } else {
      try { 
        executeFunction = botClass.getMethod(executeFunctionName);
      }
      catch(NoSuchMethodException e) {
        println("exectue function is missing.");
      }
    }

    if (exitFunctionName == null) {
      exitFunction = null;
    } else {
      try { 
        exitFunction = botClass.getMethod(exitFunctionName);
      }
      catch(NoSuchMethodException e) {
        println("exit function is missing.");
      }
    } 
  }

  void enterFunction() {
    if (enterFunction == null) return;
    
    try {
      enterFunction.invoke(parent);
    } 
    catch(IllegalAccessException e) {
      println("State enter function is missing or something is wrong with it.");
    }
    catch(InvocationTargetException e) {
      println("State enter function is missing.");
    }
  }

  void executeFunction() {
    if (executeFunction == null) return;
    
    try {
      executeFunction.invoke(parent);
    }
    catch(IllegalAccessException e) {
      println("State execute function is missing or something is wrong with it.");
    }
    catch(InvocationTargetException e) {
      println("State execute function is missing.");
    }
  }
  
  void exitFunction() {
    if (exitFunction == null) return;
    
    try {
      exitFunction.invoke(parent);
    }
    catch(IllegalAccessException e) {
      println("State exit function is missing or something is wrong with it.");
    }
    catch(InvocationTargetException e) {
      println("State exit function is missing.");
    }
  }
}

