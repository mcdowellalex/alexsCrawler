public class Coin{

    float myX;
    float myY;
    float mySize = 25;

    Coin(float x, float y){
        myX = x;
        myY = y;
    }

    void drop(){
        //drop the coin
        myY += 1; 

        //redraw the coin
        stroke(255,255,255);
        fill(255, 255, 0);
        circle(myX, myY, mySize);
        fill(30);
        circle(myX, myY, mySize-10);
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
    void setY(float newY){
        myY = newY;
    }
    void setX(float newX){
        myX = newX;
    }
}