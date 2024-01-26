
int audioLen;
int player = 0;
boolean pause = false;
boolean noAudio = false;
String[] fileNames;
AudioMetaData meta;
int idxFile = 0;

void autoNext() {
  //automatically go to the next song once finished
  if (!noAudio) {
    try {
      if (!p.isPlaying() && !pause) {
        playerControls(2);
      }
    }
    catch (Exception e) {
    }
  }
}

void folder() {
  //file directory is the data folder
  File dir = new File(dataPath("/songs"));

  //get the files in the folder
  File[] names = dir.listFiles();

  //initialize array
  fileNames = new String[0];
  for (int i = 0; i < names.length; i++) {
    //add in the files to the array
    fileNames = append(fileNames, names[i].getAbsolutePath());
  }
}

void playAudio() {
  if (p != null) {
    p.close();
    m.stop();
  }

  noAudio = false;

  //load in the selected file
  p = m.loadFile(fileNames[idxFile]);
  //retrieve metadata
  meta = p.getMetaData();
  //get the length of the file
  audioLen = p.length();
  fft = new FFT(p.bufferSize(), p.sampleRate());
}

void playerControls(int playerVal) {
  switch (playerVal) {

  case 0:  //play/pause
    if (p.isPlaying()) {  //if the song is playing
      p.pause();
      pause = true;
    } else {
      p.play();
      pause = false;
    }
    break;

  case 1:  //previous audio
    idxFile--;
    if (idxFile < 0)
      idxFile = fileNames.length;
    playAudio();
    break;

  case 2:  //next audio
    idxFile++;
    if (idxFile >= fileNames.length)
      idxFile = 0;
    playAudio();
    break;

  default:
    println("ERROR");
    break;
  }
}

String audioFile() {
  //if there is none
  if ( meta == null ) {
    println("meta==null");
    return "?";
  }
  else {
    //file name
    return meta.fileName().substring(dataPath("").length() + 7);
  }
}
