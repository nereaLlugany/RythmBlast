class Song {
  String songAudio;
  int delayNotes;
  float delay;
  SoundFile soundFile;
  BeatDetector beatDetector;
  SoundFile muteFile;
  BeatDetector muteBeatDetector;
  PImage imageFile;
  String image;
  
  // Constructor
  Song(String sa, int dn, float d, String i){
    songAudio = sa;
    delayNotes = dn;
    delay = d;
    image = i;
  }
  
  String getAudio(){
    return songAudio;
  }
  
  int getDelayNotes(){
    return delayNotes;
  }
  
  float getDelay(){
    return delay;
  }
  
  String getImg(){
    return image;
  }
  
  void setSoundFile(SoundFile sf) {
    soundFile = sf;
  }
  
  SoundFile getSoundFile() {
    return soundFile;
  }
  
  PImage getImageFile() {
    return imageFile;
  }
  
  void setBeatDetector(BeatDetector bd) {
    beatDetector = bd;
  }
  
  BeatDetector getBeatDetector() {
    return beatDetector;
  }
  
  void setMuteFile(SoundFile mf) {
    muteFile = mf;
  }
  
  SoundFile getMuteFile() {
    return muteFile;
  }
  
  void setMuteBeatDetector(BeatDetector bd) {
    muteBeatDetector = bd;
  }
  
  BeatDetector getMuteBeatDetector() {
    return muteBeatDetector;
  }
  
  void setImage(String im) {
    image = im;
  }
  
  void setImageFile(PImage imgFile){
    imageFile = imgFile;
  }
}
  
  
