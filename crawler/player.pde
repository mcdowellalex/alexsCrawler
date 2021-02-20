public class Player {

    float mySize = 10;
    color myColor;
    float myX = 250;
    float myY = 400;
    int points = 0;
    int lives = 3;

    Player(float size, color playerColor){
        mySize = size;
        myColor = playerColor;
    }

    void move(float xStep, float yStep){
        fill(myColor);
        noStroke();
        myX += xStep;
        myY += yStep;
        square(myX, myY, mySize);
        // square(xPos, yPos, mySize);
        // myX = xPos;
        // myY = yPos;
    }

    //myX and myY 
    float getX(){
        return myX;
    }
    float getY(){
        return myY;
    }
    float getSize(){
        return mySize;
    }

    void damage(){
        lives -= 1;
    }
    
    void addPoint(){
        points += 1;
    }
    
}