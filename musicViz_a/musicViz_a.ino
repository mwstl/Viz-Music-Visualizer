const int blueBtn    = 2;
const int greenBtn   = 3;
const int redBtn     = 4;
const int yellowBtn  = 5;
const int pot        = A0; //potentiometer
const int redLED     = 9;
const int blueLED    = 10;

char active;

void setup() {
  //pullup for onboard resistor
  pinMode(blueBtn, INPUT_PULLUP);
  pinMode(greenBtn, INPUT_PULLUP);
  pinMode(redBtn, INPUT_PULLUP);
  pinMode(yellowBtn, INPUT_PULLUP);

  pinMode(redLED, OUTPUT);
  pinMode(blueLED, OUTPUT);

  Serial.begin(9600);
}

void loop() {
  //buttons and potentiometer to Processing
  if (digitalRead(blueBtn) == LOW) {
    delay(50);
    Serial.println("2000");
  } else if (digitalRead(greenBtn) == LOW) {
    delay(50);
    Serial.println("2001");
  } else if (digitalRead(redBtn) == LOW) {
    delay(50);
    Serial.println("2002");
  } else if (digitalRead(yellowBtn) == LOW) {
    delay(50);
    Serial.println("2003");
  } else {
    Serial.println(analogRead(pot) / 4);
    delay(50);
  }

  //Processing to Arduino
  if (Serial.available() > 0) {
    active = Serial.read();
    if (active == 'v') {
      digitalWrite(redLED, HIGH);
      digitalWrite(blueLED, LOW);
    }
    if (active = 'm') {
      digitalWrite(redLED, LOW);
      digitalWrite(blueLED, HIGH);
    }
    if (active = 't') {
      digitalWrite(redLED, LOW);
      digitalWrite(blueLED, LOW);
    }
  }
}
