class Node {

  PVector pos, pos0, vel, vel0, acc, acc0;
  float size = height * 0.1;
  int maxSpd = 2;

  Node(float x, float y) {
    float movex = random(-2, 2);
    float movey = random(-2, 2);
    pos = new PVector(x, y, 0);
    pos0 = new PVector(x, y, 0);
    vel = new PVector(0, 0, 0);
    vel0 = new PVector(movex, movey, 0);
    acc = new PVector();
    acc0 = new PVector();
  }

  void run() {
    boundary();
    arrive();
    move();
    display();
  }

  void display() {
    point(pos.x, pos.y, pos.z);
  }

  void move() {
    vel.add(acc);
    vel.limit(maxSpd);
    pos.add(vel); 
    acc.mult(0);

    //z home position 
    //keep nodes relatively in place
    vel0.add(acc0);
    vel0.limit(maxSpd);    
    pos0.add(vel0);
    acc0.mult(0);
  }
  
  //Nature of Code autonomous agents
  void arrive() {
    PVector target = PVector.sub(pos0, pos);

    float d = target.mag();
    target.normalize();

    if (d < 100) {
      float m = map(d, 0, 100, 0, maxSpd*10.5);
      target.mult(m);
    } else {
      target.mult(maxSpd*10.5);
    }

    PVector steer = PVector.sub(target, vel0);
    applyForce(steer);
  }

  void applyForce(PVector f) {
    acc.add(f);
  }

  void boundary() {
    //bounce if the distance from the center is too far
    if (dist(pos.x, pos.y, 0, 0) < width) {
      vel.x *= -1;
      vel0.x *= -1;
      vel.y *= -1; 
      vel0.y *= -1;
    }
  }
}
