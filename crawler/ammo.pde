public class Ammo {

    float mySize = 5;
    color myColor = color(255,0,0);
    float myX=-20; //default off screen
    float myY=0;

    boolean isActive = false;

    Ammo(){
    }

    void fire(){
        if (isActive){
            //shoot lazer beaaaaam
            myY -= 1; 

            //redraw the enemy
            fill(myColor);
            noStroke();
            circle(myX, myY, mySize);
        }else{
            
        }
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
    void setX(float x){
        myX = x;
    }
    void setY(float y){
        myY = y;
    }
    void makeInactive(){
        isActive = false;
    }
    void makeActive(){
        isActive = true;
    }
}