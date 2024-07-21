class Note {
  int posX;
  int posY;
  int heightNote;
  int widthNote;
  float speed;
  color colorNote;
  
  // Constructor
  Note(int x, int y, int h, int w, float s) {
    posX = x;
    posY = y;
    heightNote = h;
    widthNote = w;
    speed = s;
    colorNote = color(255, 255, 255);
  }
  
  void display() {
    fill(colorNote);
    ellipse(posX, posY, widthNote, heightNote);
  }
  
  void update() {
    posY += speed;
  }
  
  void reset() {
    posX = 0;
    posY = 0;
    speed = 0;
    colorNote = color(0); 
  }
}
