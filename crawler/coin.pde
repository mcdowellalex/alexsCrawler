public class Coin extends Movable{

    Coin(float x, float y){
        myX = x;
        myY = y;
        mySize = 25;
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

    void setY(float newY){
        myY = newY;
    }
    void setX(float newX){
        myX = newX;
    }
}