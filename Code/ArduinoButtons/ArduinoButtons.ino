int pinkButtonState = HIGH;
int pinkButtonLastState = HIGH;

int whiteButtonState = HIGH;
int whiteButtonLastState = HIGH;

int greenButtonState = HIGH;
int greenButtonLastState = HIGH;

int yellowButtonState = HIGH;
int yellowButtonLastState = HIGH;

unsigned long yellowButtonPressedTime = 0;
bool yellowButtonPressed = false;

#define pinkButton 8
#define whiteButton 9
#define greenButton 10
#define yellowButton 12

void setup() {
  pinMode(pinkButton, INPUT_PULLUP);
  pinMode(whiteButton, INPUT_PULLUP);
  pinMode(greenButton, INPUT_PULLUP);
  pinMode(yellowButton, INPUT_PULLUP);
  Serial.begin(9600);
}

void loop() {
  // Read the current state of each button
  pinkButtonState = digitalRead(pinkButton);
  whiteButtonState = digitalRead(whiteButton);
  greenButtonState = digitalRead(greenButton);
  yellowButtonState = digitalRead(yellowButton);

  // Check for pink button press
  if (pinkButtonState != pinkButtonLastState && pinkButtonState == LOW) {
    Serial.println("k");
  }
  pinkButtonLastState = pinkButtonState;

  // Check for white button press
  if (whiteButtonState != whiteButtonLastState && whiteButtonState == LOW) {
    Serial.println("d");
  }
  whiteButtonLastState = whiteButtonState;

  // Check for green button press
  if (greenButtonState != greenButtonLastState && greenButtonState == LOW) {
    Serial.println("f");
  }
  greenButtonLastState = greenButtonState;

  // Check for yellow button press
  if (yellowButtonState != yellowButtonLastState) {
    if (yellowButtonState == LOW) {
      yellowButtonPressedTime = millis();
      yellowButtonPressed = true;
      Serial.println("j");
    } else {
      if (yellowButtonPressed) {
        unsigned long pressDuration = millis() - yellowButtonPressedTime;
        if (pressDuration >= 2000) {
          Serial.println("r");
        }
        yellowButtonPressed = false;
      }
    }
  }
  
  yellowButtonLastState = yellowButtonState;
  
  delay(50);
}
