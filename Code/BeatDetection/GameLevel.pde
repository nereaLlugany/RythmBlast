class GameLevel {
    ArrayList<Note> notes;
    ArrayList<Song> cancons;
    SoundFile sample_sound;
    SoundFile sample_mute;
    BeatDetector beatDetector_sound;
    BeatDetector beatDetector_mute;
    PImage lightsGood;
    PImage lightsPerfect;
    float delay;
    int score;
    int combo;
    boolean muteIsPlaying;
    boolean sampleIsPlaying;
    int lastBeatTime;
    int startPlaying;
    int songEndTime;
    boolean imageDisplayed;
    int imageDisplayTime;
    boolean imageState;
    
    float transparency;
    int imgTime;
    
    PImage currentEffectImage;
    boolean shouldDisplayEffect;
    
    float sampleStartTime;
    
    boolean drawImage;
    int comboMultiplyer;

    // Constructor
    GameLevel(ArrayList<Song> songs, PImage lightsGood, PImage lightsPerfect) {
        this.notes = new ArrayList<Note>();
        this.cancons = songs;
        this.lightsGood = lightsGood;
        this.lightsPerfect = lightsPerfect;
        this.delay = 3000;
        this.score = 0;
        this.combo = 0;
        this.muteIsPlaying = false;
        this.sampleIsPlaying = false;
        this.lastBeatTime = 0;
        
        this.transparency = 100;
        this.imgTime = 0;
        this.imageState = false;
        this.currentEffectImage = null;
        this.shouldDisplayEffect = false;
        this.drawImage = true;
        this.comboMultiplyer = 1;
    }

    void startAudio() {
        if (!muteIsPlaying) {
            sample_mute.play();
            sample_mute.amp(0.05);
            muteIsPlaying = true;
            startPlaying = millis();
            drawImage = true;
            tint(255, 255);
            image(readyText, 0, height/50, width, height/2);
        }

        if ((millis() - startPlaying) > delay && !sampleIsPlaying) {
            sample_sound.play();
            sampleIsPlaying = true;
            sampleStartTime = millis();
            drawImage = false;
        }
        
        if(drawImage) {
          tint(255, 255);
          image(readyText, 0, height/50, width, height/2);
        } else {
          //image(background, 0, 0, width, 540);
          drawInterface();
          tintImages();
        }
    }

    void handleBeatDetection() {
      if(sampleIsPlaying){
        if (beatDetector_mute.isBeat() && millis() - lastBeatTime >= 500) {
          //println(sampleIsPlaying);
            int x;
            int num = int(random(100));
            if (num < 25) {
                x = 567;
            } else if (num < 50) {
                x = 799;
            } else if (num < 75) {
                x = 1039;
            } else {
                x = 1269;
            }
            Note myNote = new Note(x, 160, 100, 100, 5.0);
            notes.add(myNote);
            lastBeatTime = millis();
        }
      }
    }

    void updateNotes() {
        for (int i = 0; i < notes.size(); i++) {
            Note note = notes.get(i);
            note.update();
            note.display();
            if (note.posY > height/2 - 80) {
                displayText("MISS");
                missSound.play();
                combo = 0;
                notes.remove(i);
                i--;
            }
        }
    }

    void resetValues() {
        gameState = 0; // Reset gameState
        timerKeyReset = 0; // Removed timerKeyReset
        sample_sound.stop();
        sample_mute.stop();
        sampleIsPlaying = false;
        muteIsPlaying = false;
        score = 0;
        combo = 0;
        songEndTime = 0;
        imageDisplayed = false;
        imageDisplayTime = 0;
        notes.clear();
        notes.clear();
    }

    void drawInterface() {
        displayBckgImg(selectedSong);
        stroke(255);
        
        //fill(255, 255, 255, 50);

        fill(255, 255, 255, 50);
        rect(480, 40, 180, 490, 20); //rectangle1 prova rodones  //color rectangle1 prova rodones
        
        fill(255, 255, 0, 50);
        rect(710, 40, 180, 490, 20); //rectangle2 prova rodones
        fill(80, 255, 80, 50);
        
        rect(950, 40, 180, 490, 20); //rectangle3 prova rodones
        
        fill(255, 0, 180, 50);
        rect(1180, 40, 180, 490, 20); //rectangle4 prova rodones

        fill(255, 255, 255, 60);

        circle(567, 450, 120); //cercle1
        circle(799, 450, 120); //cercle2
        circle(1039, 450, 120); //cercle3
        circle(1269, 450, 120); //cercle4
        
        displayCombo (combo);
        tint(255, 255);
        fill(255, 255, 255);
        
        int durationInterval = int(sample_sound.duration()) * 80/4;
        
        if (score >= durationInterval && score < durationInterval * 2) {
          image(note1,160,180,140,140);
        } else if (score >= durationInterval * 2 && score < durationInterval * 3) {
          image(note2,160,180,140,140);
        } else if (score >= durationInterval * 3 && score < durationInterval * 4) {
          image(note3,160,180,140,140);
       } else if (score >= durationInterval * 4) {
          image(note4,160,180,140,140);
        }
    }

    void checkSongEnd() {
        if (sampleIsPlaying && (millis() - startPlaying) > sample_sound.duration() * 1000) {
            songEndTime = millis(); 
            background(0);
            image(finishText, 0, height/50, width, height/2);
        }   
        
        if (!imageDisplayed && millis() - songEndTime >= 0 && millis() - songEndTime <= 3000) {
            imageDisplayTime = millis(); 
            imageDisplayed = true;
        }
        
        if (imageDisplayed && millis() - imageDisplayTime > 3000) {
            resetValues(); 
            gameState= 0;
        }
      }

    //Aquesta funcio serveix per saber si el jugador ha premut la tecla al mateix temps que
    //el beat, si es el cas l'elimina de l'ArrayList
    boolean checkNoteCollision(int circleX) {
        for (int i = 0; i < notes.size(); i++) {
            Note note = notes.get(i);
            if (note.posX == circleX && note.posY > height - 790 && note.posY < height - 690) {
                displayText("PERFECT");
                imgTime = millis();
                imageState = true;
                
                currentEffectImage = lightsPerfect;
                shouldDisplayEffect = true;
                imgTime = millis();
                
                if (combo < 5) {
                  comboMultiplyer = 1;
                } else if (combo >= 5) {
                  comboMultiplyer = 2;
                } else if (combo >= 10) {
                  comboMultiplyer = 3;
                } else if (combo >= 15) {
                  comboMultiplyer = 4;
                } else if (combo >= 20) {
                  comboMultiplyer = 5;
                } 
                  
                combo += 1;
                score += (100*comboMultiplyer);
                notes.remove(i);
                i--;
                return true; 
            } else if(note.posX == circleX && note.posY > height - 890 && note.posY < height - 650){
                displayText("GOOD");
                imgTime = millis();
                imageState = true;
                
                currentEffectImage = lightsGood;
                shouldDisplayEffect = true;
                imgTime = millis();
                
                if (combo < 5) {
                  comboMultiplyer = 1;
                } else if (combo >= 5) {
                  comboMultiplyer = 2;
                } else if (combo >= 10) {
                  comboMultiplyer = 3;
                } else if (combo >= 15) {
                  comboMultiplyer = 4;
                } else if (combo >= 20) {
                  comboMultiplyer = 5;
                }
                combo += 1;
                score += (50*comboMultiplyer);
                notes.remove(i);
                i--;
                return true; 
            } else {
              displayText("MISS");
              missSound.play();
            }
        }
        return false; 
    }

    // Aquesta funció serveix per mostrar el text depenent de com interactua el jugador amb
    // la interficie
    void displayText(String stingDisplay) {
        fill(255); 
        textSize(40); 
        textAlign(CENTER, CENTER); 
        text(stingDisplay.toString(), width / 2, height / 2); 
    }

    void displayCombo(int textCombo){
        fill (255, 255);
        textFont(font);
        text ("COMBO", 1650, 200);
        textSize(80);
        textAlign(CENTER, CENTER);
        text(textCombo, 1650, 290); 
    }

    void loadSong(int songIndex) {
        Song selectedSong = cancons.get(songIndex);
        sample_sound = selectedSong.getSoundFile();
        sample_mute = selectedSong.getMuteFile(); 
        beatDetector_sound = selectedSong.getBeatDetector();
        beatDetector_mute = selectedSong.getMuteBeatDetector(); 
    }
    
    //La funció principalment crea l'efecte de fade in fade out que busquem per a millorar estèticament la interfície i que el jugador rebi feedback
    void tintImages() {
    int fadeDuration = 150;
    
    if (!imageState && shouldDisplayEffect && currentEffectImage != null) {
        imageState = true;
        imgTime = millis();
        transparency = 0;
    }

    int timePassed = millis() - imgTime;

    if (imageState) {
      if (timePassed < fadeDuration) {
          if (timePassed <= fadeDuration / 2) {
              transparency = map(timePassed, 0, fadeDuration / 2, 0, 180);
          } 
          else {
              transparency = map(timePassed, fadeDuration / 2, fadeDuration, 180, 0);
          }
      } 
      else {
          imageState = false;
          shouldDisplayEffect = false;
          transparency = 0;  
          currentEffectImage = null;  
      }
      
      if (currentEffectImage != null) {
          tint(255, transparency); 
          image(currentEffectImage, 0, 0);
      }
    }
}

    void displayBckgImg(int songIndex){
        Song selectedSong = cancons.get(songIndex);
        PImage img = selectedSong.getImageFile();
        tint(255, 70);
        image(img, width/2.9, 50, 500, 500);
     }
     
     boolean getDisplayImage(){
       return drawImage;
     }
}
