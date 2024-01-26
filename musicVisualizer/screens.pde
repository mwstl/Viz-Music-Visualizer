// scr abbreviation

//buttons
//title
char showCont = 'a';
char mode1 = '1';
char mode2 = '2';

final String t_wel = "Welcome to";
final String t_name = "VIZ";
final String t_cont = "Press '" + showCont + "' to see more controls";
final String t_credit = "project by : Micole";
final String t_mode1 = "Press '" + mode1 + "' to browse music library";
final String t_mode2 = "Press '" + mode2 + "' to create music realtime";

PGraphics sv;

void titleScr() {
  //cam.beginHUD();
  background(0);

  fill(255);

  //top left
  textSize(125);
  text(t_wel, -width + margin, -height + 125);
  text(t_name, -width + margin, -height + 125*2);

  //bot left 
  textSize(fsize);
  //text(t_cont, -width + margin, height-fsize/2);

  //bot right
  textAlign(RIGHT);
  text(t_credit, width - margin/2, height-fsize/2);

  //center modes
  textAlign(CENTER, CENTER);
  text(t_mode1, -textWidth(t_mode1), height/2);
  text(t_mode2, +textWidth(t_mode2), height/2);
  
  //random squiggle
  image(sv, -500, -250);

  if (keyPressed) {
    if (key == '1') screen = 1;
    if (key == '2') screen = 2;
  }
  //cam.endHUD();
}

void startViz() {
  sv.beginDraw();
  sv.noFill();
  sv.stroke(255);
  sv.strokeWeight(3);
  sv.translate(0, 250/2);
  sv.beginShape();
  for (int x = 0; x <= 1000; x += 20) {
    float y = random(-100, 100);
    sv.vertex(x, y);
  }
  sv.endShape();
  sv.endDraw();
}
