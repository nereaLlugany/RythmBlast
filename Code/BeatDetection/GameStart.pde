Song s;
class GameStart {
    int rectWidth;
    int rectHeight;
    int spacing;
    int totalWidth;
    int startX;
    int selectedSong;
    color col;

    // Constructor
    GameStart(int rectWidth, int rectHeight, int spacing, int numSquares, int selectedSong, color colorNote) {
        this.rectWidth = rectWidth;
        this.rectHeight = rectHeight;
        this.spacing = spacing;
        this.totalWidth = (rectWidth + spacing) * numSquares;
        this.startX = (width - totalWidth) / 2;
        this.selectedSong = selectedSong;
        this.col = colorNote;
    }

    void gameStart() {
        fill(255);        
        for (int i = 0; i < 5; i++) {
            int rectX = startX + i * (rectWidth + spacing);
            if (i == selectedSong) {
                fill(0, 255,0 , 100);
                //rect(rectX - 11, height / 4 + rectHeight-60, rectWidth + 62, 15);
                circle(rectX + 7 * rectWidth / 12, height / 4 + rectHeight - 35, rectWidth/6);
                tint(255, 255, 255, 255);
                image(cancons.get(selectedSong).getImageFile(), rectX - 10, height / 4 - rectHeight / 2 - 20, rectWidth + 60, rectHeight + 60);
                
            } else {
                tint(255, 255, 255, 255);
                image(cancons.get(i).getImageFile(), rectX, height / 4 - rectHeight / 2, rectWidth, rectHeight);
            }
        }
    }
}
