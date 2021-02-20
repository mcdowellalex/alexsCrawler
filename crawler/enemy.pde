public class Enemy {

    float mySize = 20;
    color myColor;
    float myX;
    float myY;
    float mySpeed;

    Enemy(float x, float y, float speed){
        myX = x;
        myY = y;
        mySpeed = speed;

        float r = random(255);
        float g = random(255);
        float b = random(255);
        myColor = color(r,g,b);
    }

    void drop(){
        //drop the enemy
        myY += mySpeed; 

        //redraw the enemy
        fill(myColor);
        stroke(200,100,0); //incase the color matches the background
        square(myX, myY, 20);
    }


    //myX and myY are the top left corner of the square
    float getX(){
        return myX;
    }
    float getY(){
        return myY;
    }
    float getSize(){
        return mySize;
    }

    //setters
    void setY(float newY){
        myY = newY;
    }
    void setX(float newX){
        myX = newX;
    }
    void setSpeed(float newSpeed){
        mySpeed = newSpeed;
    }
}