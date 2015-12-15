/*
The motor output specification for the bot.
In this case, thrust and torque are applied via fisica.

The bot constructor should initialize the motor system and
pass a reference to the bot as follows:
    Bot() {
      ...
      MotorSystem motors = new MotorSystem(this);
      ...
    }
    
The controller code should set the thrust and torque values:
   motors.thrust = ...
   motors.torque = ...
*/
class MotorSystem {
  
  Cell cell;
  float thrust;
  float torque;
  float max_torque = 10.0;
  float max_thrust = 1000.0;
  
  MotorSystem(Cell _b) {
    cell = _b;
    thrust = 0.0;
    torque = 0.0;
  }
  
  void update() {
    // update body forces and torques using fisica
    float heading = cell.getRotation();
    float thrust_limited = constrain(thrust, -max_thrust, max_thrust);
    float torque_limited = constrain(torque, -max_torque, max_torque);
    cell.addForce(thrust_limited*cos(heading), thrust_limited*sin(heading));
    cell.addTorque(torque_limited);
  }
}

