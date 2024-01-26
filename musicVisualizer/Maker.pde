class Maker {

  AudioPlayer[] notes;
  float octave = 0;
  int fileAmt = 0;
  Key[] k;
  int t = 0;

  Maker() {
    loadNotes();

    k = new Key[fileAmt];

    for (int i = 0; i < fileAmt; i++) {
      k[i] = new Key(i);
    }
  }

  void play() {
    background(0);

    //arduino stuffs
    if (serialPort == 2000) {
      //if button is pressed, rewind audio clip & play
      notes[0 + (int(octave)*4)].rewind();
      notes[0 + (int(octave)*4)].play();

      //controls "keyboard" colour
      k[0 + (int(octave)*4)].active = true;
      k[0 + (int(octave)*4)].t = 30;

      //prevent double clicking
      delay(500);
    } else if (serialPort == 2001) {
      notes[1 + (int(octave)*4)].rewind();
      notes[1 + (int(octave)*4)].play();

      k[1 + (int(octave)*4)].active = true;
      k[1 + (int(octave)*4)].t = 30;
      delay(500);
    } else if (serialPort == 2002) {
      notes[2 + (int(octave)*4)].rewind();
      notes[2 + (int(octave)*4)].play();

      k[2 + (int(octave)*4)].active = true;
      k[2 + (int(octave)*4)].t = 30;
      delay(500);
    } else if (serialPort == 2003) {
      notes[3 + (int(octave)*4)].rewind();
      notes[3 + (int(octave)*4)].play();

      k[3 + (int(octave)*4)].active = true;
      k[3 + (int(octave)*4)].t = 30;
      delay(500);
    } else {
      octave = map(serialPort, 0, 255, 4, 0);
      octave = constrain(octave, 0, 4);
    }

    for (int i = 0; i < k.length; i++) {
      //show the keys
      k[i].display();
    }
    
    if (t < 240) {
      startInfo();
      t++;
    }
  }

  void loadNotes() {
    //find the notes folder with the individual piano notes
    File notesDir = new File(dataPath("/notes")); 

    //get a list of all the file names within the folder
    File[] names = notesDir.listFiles();

    //initialize AudioPlayer array
    notes = new AudioPlayer[names.length];
    for (int i = 0; i < names.length; i++) {
      //assign each array index to a file
      notes[i] = m.loadFile(names[i].getAbsolutePath());
    }

    //save variable for how many items there are
    fileAmt = names.length;
  }
  
  void startInfo(){
    cam.beginHUD();
    textAlign(CENTER, CENTER);
    textSize(fsize * 0.75);
    fill(255);
    noStroke();
    text("Click on a key or press a button to play", width/2, fsize);
    cam.endHUD();
  }

  class Key {

    float w, h;
    boolean active = false;
    float xpos;
    int t = 0;
    int noteVal;

    Key(int note) {
      w = (width-margin) / fileAmt - (width*0.01);
      h = height * 0.25;
      noteVal = note;
      xpos = map(note, 0, fileAmt-1, margin+w, width-margin-w);
    }

    void display() {
      //disable 3D
      cam.beginHUD();

      //if mousing over key, show visually
      if (mouseX > xpos - w/2 && mouseX < xpos + w/2
        && mouseY > height/2 - h/2 && mouseY < height/2 + h/2) {
        fill(255);

        if (mousePressed) {
          //if mousing over & clicking, play the sound
          notes[noteVal].rewind();
          notes[noteVal].play();
          delay(250);
        }
      } else {
        fill(255, 100);
      }

      //active dependent on buttons
      if (active) {
        fill(
          140 + map(xpos, margin+2, width-margin-2, 0, 30), 
          255, 
          map(t, 0, 30, 100, 255)
          );

        t--;
        if (t < 0) 
          active = false;
        //timer to fade out colour
      }

      rect(xpos, height/2, w, h);
      cam.endHUD();
    }
  }
}
