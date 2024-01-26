import processing.serial.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import peasy.*;

Serial myPort;
Minim m;
AudioPlayer p;
FFT fft;
PeasyCam cam;

Music music;
Visualizer v;
Maker mk;

PFont font;
int fsize = 50;
int screen = 0;

float margin;
float serialPort = 0;

void setup() {
  fullScreen(P3D);
  //size(1080, 1080, P3D);
  noFill();
  colorMode(HSB);
  blendMode(ADD);
  smooth();
  cursor(CROSS);
  rectMode(CENTER);

  init();
}

void draw() {
  switch (screen) {
    //title screen
  case 0:
    titleScr();
    break;

    //song visualizer
  case 1:
    //display visualizer
    v.playViz();
    break;

    //music maker
  case 2:
    mk.play();
    break;
  }
}

void serialEvent(Serial port) {
  serialPort = float(port.readStringUntil('\n'));
}

void keyPressed() {
  //return to title screen
  if (key == 'q' || key == 'Q') { 
    myPort.write('t');
    p.pause();
    screen = 0;
  }

  //title screen
  if (screen == 0) {
    //change to viz screen
    if (key == '1') {
      myPort.write('v');
      v = new Visualizer();
      //reset info timer
      v.t = 0;
      screen = 1;
    }

    //change to maker screen
    if (key == '2') {
      myPort.write('m');
      mk = new Maker();
      mk.t = 0;
      screen = 2;
    }
  }

  //change visualizer type
  if (screen == 1) {
    if (key == '1')
      v.vtype = 1;

    else if (key == '2')
      v.vtype = 2;

    else if (key == '3')
      v.vtype = 3;

    else if (key == '4')
      v.vtype = 4;

    //pause
    if (key == 'p') { 
      if (p.isPlaying()) {
        p.pause();
      } else {
        p.play();
      }
    }
  }
}


void mousePressed() {
  if (screen == 1) {
    //prev
    if (mouseX < width/2-37.5 && mouseX > width/2-62.5
      && mouseY < height-22.5 && mouseY > height-47.5
      ) {
      playerControls(1);
      p.play();
    }

    //play/pause
    if (mouseX < width/2+12.5 && mouseX > width/2-12.5
      && mouseY < height-22.5 && mouseY > height-47.5
      ) {
      playerControls(0);
    }

    //next
    if (mouseX < width/2+62.5 && mouseX > width/2+37.5
      && mouseY < height-22.5 && mouseY > height-47.5
      ) {
      playerControls(2);
      p.play();
    }
  }
}

void init() {
  margin = width * 0.1;

  folder();
  myPort = new Serial(this, Serial.list()[0], 9600);
  myPort.bufferUntil('\n');
  m = new Minim(this); 
  cam = new PeasyCam(this, width+margin);

  music = new Music();
  mk = new Maker();

  font = loadFont("MS-UIGothic-48.vlw");
  textFont(font);
  textSize(fsize);

  sv = createGraphics(1000, 250);
  startViz();
}
