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

    void move(float xPos, float yPos){
        fill(myColor);
        noStroke();
        square(xPos, yPos, mySize);
        myX = xPos;
        myY = yPos;
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