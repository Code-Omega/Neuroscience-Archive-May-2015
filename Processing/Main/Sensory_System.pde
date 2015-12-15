/*The sensor input specification for the bot.

The bot constructor should pass a reference to the bot:
    Bot() {
      ...
      SensorySystem sensors = new SensorySystem(this);
      ...
    }
    
The bot update routine should call 
    sensors.update();
    
The bot controller code should access relevant sensor data, e.g.: 
    if(sensors.numContacts > 0) {
      // do something
    }
*/
class SensorySystem {
  
  Cell cell;
  // mechanical contact sensors
  int numContacts;
  int maxContacts = 6;
  float[] contactAngle;
  FContact[] botContacts;
  
  SensorySystem(Cell _b) {
    cell = _b;
    contactAngle = new float[maxContacts];
    botContacts = new FContact[maxContacts];
  }
  
  void update() {
    update_contact_sensors();
  }
  
  void update_contact_sensors() {
    // bot position and heading
    float bx = cell.getX();
    float by = cell.getY();
    float bheading = cell.getRotation();
    
    // loop over fisica contacts
    ArrayList<FContact> contacts = cell.getContacts();
    numContacts = contacts.size();
    for (int i=0; i<numContacts; i++) {
      if (i == maxContacts) break;
      FContact contact = contacts.get(i);
      botContacts[i] = contacts.get(i);
      float cx = contact.getX();
      float cy = contact.getY();
      float cheading = atan2(cy-by, cx-bx);
      float delta_heading = (cheading - bheading) % TWO_PI;
      if (delta_heading > PI) delta_heading -= TWO_PI;
      if (delta_heading < -PI) delta_heading += TWO_PI;
      contactAngle[i] = delta_heading;
    }
  }
}

