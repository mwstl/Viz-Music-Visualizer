class Visualizer extends Music {

  float freqCont = 2.2, gain = -80;
  float bhue = 120, hueScl = 25;
  float t = 0;

  int vtype = 1, radius, fftbands = 256;
  boolean counter = true;

  Node[] n = new Node[2500];

  Visualizer() {
    super();

    for (int i = 0; i < n.length; i++) {
      n[i] = new Node(random(-width, width), random(-height, height));
    }

    radius = width/2;

    p.play();
  }

  void playViz() {
    background(0);
    fft.forward(p.mix);

    //change type of visualizer
    switch (vtype) {
    case 1:
      nodeWeb();
      break;

    case 2:
      circleSpec3D();
      break;

    case 3:
      horizontalSpec();
      break;

    case 4:
      verticalSpec();
      break;

    default:
      println("something went wrong");
      screen = 0;
      break;
    }

    //arduino control stuffs
    if (serialPort > 1500) {            //check if potentiometer or button
      if (serialPort == 2000) {         //blue
        bhue = 120; //blue
      } else if (serialPort == 2001) {  //green
        bhue = 80;  //green
      } else if (serialPort == 2002) {  //yellow
        bhue = 20;  //yellow
      } else if (serialPort == 2003) {  //red
        bhue = -10;   //red-yellow
      }
    } else {    //potentiometer
      gain = map(serialPort, 0, 500, 20, -80);
      gain = constrain(gain, -80, 20);  //prevent too loud
      p.setGain(gain);
    }

    currentSong();
    autoNext();
    playPause();

    //timing for info helper
    if (t < 240) {
      startInfo();
      t++;
    }
  }

  void nodeWeb() {
    for (int i = 0; i < n.length; i++) {
      //move node based off of position & sound frequency
      float freq = fft.getFreq(dist(
        n[i].pos.x, n[i].pos.y, 0, 0) 
        * freqCont
        );

      //if there is a audible frequency/sound for this node, jump a bit
      if (freq > 6.0) {
        n[i].applyForce(new PVector(0, 0, random(n[i].maxSpd*5, n[i].maxSpd*10)));
      }

      //distance from center
      float d = dist(n[i].pos.x, n[i].pos.y, 0, 0);

      strokeWeight(freq / 15);
      //color based off of distance
      stroke(
        bhue + (d/800 * hueScl), 
        255, 
        255
        );

      //check distance to other nodes
      //connect with a line if close together
      for (int j = i + 1; j < n.length; j++) {
        Node other = n[j];
        float dist = n[i].pos.dist(other.pos);

        if (dist > 0 && dist < 75) {
          line(
            n[i].pos.x, n[i].pos.y, n[i].pos.z, 
            other.pos.x, other.pos.y, other.pos.z
            );
        }
      }
      stroke(255);
      n[i].run();
    }
  }

  //random spheres
  PVector sph1 = new PVector(random(-width/2, width/2), random(-height/2), random(-height/2, height/2));
  float s1 = random(25, 75);
  PVector sph2 = new PVector(random(-width/2, width/2), random(-height/2), random(-height/2, height/2));
  float s2 = random(25, 75);
  PVector sph3 = new PVector(random(-width/2, width/2), random(-height/2), random(-height/2, height/2));
  float s3 = random(26, 75);

  void circleSpec3D() {
    for (int i = 0; i < fftbands/2; i++) {
      stroke(bhue + ((i / 10) + hueScl), 255, 255);

      //find circular position
      float x = radius * cos(TAU * i / fftbands);
      float y = radius * sin(TAU * i / fftbands);

      stroke(bhue + hueScl, 255, 255);
      line(
        x, y, 
        x + fft.getBand(i) * 7 * cos(TAU * i / fftbands), 
        y + fft.getBand(i) * 7 * sin(TAU * i / fftbands)
        );
    }

    //random spheres
    //rotation based off of song from 0 to two pi (360)
    float rot = map(p.position(), 0, p.length(), 0, TAU);
    pushMatrix();
    rotateY(rot);
    sphereDetail(12);
    noFill();
    sphere(300);
    popMatrix();

    sphereDetail(4);
    pushMatrix();
    translate(sph1.x, sph1.y, sph1.z);
    rotateY(radians(frameCount / (s1 / 5)));
    sphere(s1);
    popMatrix();

    pushMatrix();
    translate(sph2.x, sph2.y, sph2.z);
    rotateY(radians(frameCount / (s2 / 5)));
    sphere(s2);
    popMatrix();

    pushMatrix();
    translate(sph3.x, sph3.y, sph3.z);
    rotateY(radians(frameCount / (s3 / 5)));
    sphere(s3);
    popMatrix();
  }

  void horizontalSpec() {
    //disable 3Da
    cam.beginHUD();

    beginShape();
    vertex(margin, height/1.25 + 20);
    curveVertex(margin, height/1.25 + 20);

    for (int i = 0; i < fft.specSize() * 0.6; i += 5) {
      //gradient colours
      //stroke(bhue + ((i / 10) + hueScl), 255, 255);
      //strokeWeight(2);
      fill(bhue + ((i / 10) + hueScl), 255, 255);
      noStroke();

      //standard line spectrum
      //float x = map(i, 0, fft.specSize(), -width/2, width/2);
      //line(x, height/2, x, height/2-fft.getBand(i) * 4);

      //wavy spectrum
      float x = map(i, 0, fft.specSize() * 0.6, margin, width-margin);
      curveVertex(x, height/1.25-fft.getBand(i) * 4);
    }

    curveVertex(width-margin, height/1.25 + 20);
    vertex(width-margin, height/1.25 + 20);
    endShape();
    cam.endHUD();
  }

  void verticalSpec() {
    for (int i = 0; i < fft.specSize(); i++) {
      fill(bhue + hueScl, 255, 255);
      stroke(bhue + hueScl, 50, 120);
      strokeWeight(1);

      //change y based off of spectrum location
      float y = map(i, 0, fft.specSize(), -height/2, height/2);

      pushMatrix();
      translate(0, y);
      rotateX(HALF_PI);
      //change size based off of fft band
      circle(0, 0, fft.getBand(i) * 4);
      popMatrix();
    }
  }

  void currentSong() {  //song title and progress bar  
    cam.beginHUD();
    textSize(fsize * 0.5);
    fill(255, 125);
    noStroke();
    textAlign(LEFT, BASELINE);
    text("Currently playing: <" + (audioFile()) + ">", 15, height-fsize/2);

    //progress bar
    stroke(255, 125);
    strokeWeight(2);
    line(
      width-width*0.25, height-fsize/2, 
      width-15, height-fsize/2
      );
    circle(
      //current song position to total song length
      map(p.position(), 0, p.length(), width-width*0.25, width-15), 
      height-fsize/2, 
      10
      );
    cam.endHUD();
  }

  void startInfo() {
    //heads up information that dissapears after a while
    cam.beginHUD();
    textAlign(CENTER, CENTER);
    textSize(fsize * 0.75);
    fill(255);
    noStroke();
    text("Press the buttons to change colour", width/2, fsize);
    text("The potentiometer controls the volume", width/2, fsize*2);
    text("Change visualizer type with numbers 1-4", width/2, fsize*3);
    cam.endHUD();
  }

  void playPause() {
    //music controls
    cam.beginHUD();
    textAlign(CENTER, CENTER);
    textSize(fsize * 0.75);
    noFill();
    stroke(255, 125);
    strokeWeight(2);
    //prev
    if (mouseX < width/2-37.5 && mouseX > width/2-62.5
      && mouseY < height-22.5 && mouseY > height-47.5
      ) {
      fill(255, 100);
    } else {
      noFill();
    }
    noStroke();
    circle(width/2-48, height-35, 40);
    fill(255, 125);
    text("<", width/2 - 50, height-35, 25);

    //pause
    if (mouseX < width/2+12.5 && mouseX > width/2-12.5
      && mouseY < height-22.5 && mouseY > height-47.5
      ) {
      fill(255, 100);
    } else {
      noFill();
    }
    noStroke();
    circle(width/2, height-35, 40);
    fill(255, 125);
    if (p.isPlaying()) {
      text("ll", width/2, height-35, 25);
    } else {
      text(">", width/2, height-35, 25);
    }

    //next
    if (mouseX < width/2+62.5 && mouseX > width/2+37.5
      && mouseY < height-22.5 && mouseY > height-47.5
      ) {
      fill(255, 100);
    } else {
      noFill();
    }
    noStroke();
    circle(width/2+48, height-35, 40);
    fill(255, 125);
    text(">", width/2 + 50, height-35, 25);
    cam.endHUD();
  }
}
