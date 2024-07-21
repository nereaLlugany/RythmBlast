import processing.sound.*;
import processing.serial.*;

import java.util.ArrayList; // Import ArrayList class

Serial serialPort;
Note myNote;
SoundFile sample;
GameStart startScreen;
GameLevel levelScreen;
BeatDetector beatDetector;

PImage lightsGood;
PImage lightsPerfect;

color col; 

ArrayList<Song> cancons = new ArrayList<Song>();

int score;
int gameState;
int timerKeyReset;
int selectedSong;

PImage bkimg;

//PImage background;

boolean isLoaded;

PImage note1;
PImage note2;
PImage note3;
PImage note4;

PImage readyText;
PImage finishText;
PFont font;
SoundFile hitSound;
SoundFile missSound;

String serialValue;

void setup() {
  size(1920, 1080);
  fullScreen();
  background(255);
  print(Serial.list());
  serialPort = new Serial(this, "COM4", 9600);
  
  gameState = 0;
  
  //Carrega les cançons amb la seva informació a l'array per poder reproduir-les més tard 
  cancons.add(new Song("SevenNationArmy.wav", 50, 4555.5555, "COVERSevenNationArmy.jpeg"));
  cancons.add(new Song("highway to hell.wav", 700, 4555.5555, "COVERHighwayToHell.jpeg"));  
  cancons.add(new Song("Sk8ter Boi.wav", 700, 4555.5555, "COVERSk8terBoi.jpeg"));
  cancons.add(new Song("bad guy.wav", 700, 4655.5555, "COVERBadGuy.jpeg"));  
  cancons.add(new Song("Wellerman.wav", 700, 4855.5555, "COVERWellerMan.jpeg"));
  
  note1= loadImage("sad.png");
  note2= loadImage("happy.png");
  note3= loadImage("wink.png");
  note4= loadImage("winkTonge.png");
  
  //background = loadImage("BackgroundProjectes.png");
  
  font = createFont("CooperBlack-Std.otf", 70);
  
  readyText = loadImage("ReadyText.png");
  finishText = loadImage("FinishText.png");
  
  //Carrega les cançons i el BeatDetector per poder detectar els beats de cada cançó
  for (int i = 0; i < cancons.size(); i++) {
    Song song = cancons.get(i);
    SoundFile soundFile = new SoundFile(this, song.songAudio);
    SoundFile muteFile = new SoundFile(this, song.songAudio);

    BeatDetector beatDetector = new BeatDetector(this);
    BeatDetector muteBeatDetector = new BeatDetector(this);
    
    beatDetector.input(soundFile);
    muteBeatDetector.input(muteFile);
    
    muteBeatDetector.sensitivity(350);
    beatDetector.sensitivity(140);
    
    song.setSoundFile(soundFile);
    song.setBeatDetector(beatDetector);
    song.setMuteFile(muteFile);
    song.setMuteBeatDetector(muteBeatDetector);
    
    bkimg = loadImage(song.getImg());
    song.setImageFile(bkimg);
  }
  
  //Carregar les llums per quan encerten la nota
  lightsGood = loadImage("goodeffect.png");
  lightsPerfect = loadImage("perfecteffect.png");
  
  hitSound = new SoundFile (this, "hitSound.wav");
  hitSound.amp(1.0);

  missSound = new SoundFile(this, "missSound.wav");
  missSound.amp(0.5);

  
  //Instància a l'objecte del joc
  levelScreen = new GameLevel(cancons, lightsGood, lightsPerfect);
  //serialPort = new Serial(this, "COM3", 9600);
}

void draw() {
  background(0);
  
  //Depenent de quin estat estem del joc, carrega la pantalla de selecció 
  //de cançons o la del joc
  switch (gameState) {
    //Estat de selecció de les cançons
    case 0:
      col = color(random(0, 255), random(0, 255), random(0, 255));
      startScreen = new GameStart(200, 200, 80, 5, selectedSong, col);
      startScreen.gameStart();
      break;

    //Estat on hi és la interfície del joc
    case 1:
      levelScreen.startAudio();
      levelScreen.handleBeatDetection();
      levelScreen.updateNotes();
      levelScreen.checkSongEnd();
      
      break;
  }
  
  if (serialPort.available() > 0) {
    serialValue = serialPort.readStringUntil('\n');  
    print(serialValue);
    if (serialValue != null) {
      processInput(serialValue.trim());
    }
  }
}  

//Funció per fer una acció o una altre depenent de quin botó s'ha press
void processInput(String input) {
  boolean noteHit = false;
  
  //Si estem en el estat 0, si es prem el botó de la més esquerra o el de la més dreta
  //es va canviant la cançó seleccionada i amb el boto del mig de l'esquerra
  //es selecciona aquella cançó per a jugar-la
  if (gameState == 0){
    switch (input) {
      case "d":
        selectedSong = (selectedSong - 1 + cancons.size()) % cancons.size();
        startScreen.selectedSong = selectedSong;
        break;
      case "k":
        selectedSong = (selectedSong + 1) % cancons.size();
        startScreen.selectedSong = selectedSong;
        break;
      case "f":
        levelScreen.loadSong(selectedSong);
        levelScreen.displayBckgImg(selectedSong);
        gameState = 1;
        break;
    }
  
  //En canvi, si estem en el estat 1, els botons només serveixen per jugar i si
  //es prem més de dos segons el botó del mig de la dreta et retorna a la pantalla 
  //principal
  } else if (gameState == 1 && !levelScreen.getDisplayImage()){
        switch(input) {
            case "d":
                fill(255, 0, 180, 80);
                circle(567, 450, 120);
                noteHit = levelScreen.checkNoteCollision(567);
                hitSound.play();
                break;
            case "j":
                fill(255, 255, 0, 80);
                circle(799, 450, 120);
                noteHit = levelScreen.checkNoteCollision(799);
                hitSound.play();
                break;
            case "f":
                fill(80, 255, 80, 80);
                circle(1039, 450, 120);
                noteHit = levelScreen.checkNoteCollision(1039);
                hitSound.play();
                break;
            case "k":
                fill(255, 255, 255, 50);
                circle(1269, 450, 120);
                noteHit = levelScreen.checkNoteCollision(1269);
                hitSound.play();
                break;
            case "r":
              levelScreen.resetValues();
              break;
               
    }
    
    //Mira si has encertat la nota, si no ho has fet et mostra el missatge "MISS"
    if (!noteHit) {
      levelScreen.displayText("MISS");
      levelScreen.combo = 0;
    }
     
    
    }
}
    
    
    
