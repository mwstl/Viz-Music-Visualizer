class Music {

  int bands = 256;
  float size;

  Music() {
    playAudio();
    
    fft.linAverages(bands);
    size = fft.specSize();
  }
}
