public class Player extends Movable{

    color myColor;
    int points = 0;
    int lives = 3;

    Player(float size, color playerColor){
        mySize = size;
        myColor = playerColor;
        myX = 250;
        myY = 400;
    }

    void move(float xStep, float yStep){
        fill(myColor);
        noStroke();
        myX += xStep;
        myY += yStep;
        square(myX, myY, mySize);
    }

    void damage(){
        lives -= 1;
    }
    
    void addPoint(){
        points += 1;
    }
    
}