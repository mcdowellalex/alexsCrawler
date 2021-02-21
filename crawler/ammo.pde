public class Ammo extends Movable{

    color myColor = color(255,0,0);

    boolean isActive = false;

    Ammo(){
        myX = -20;
        myY = 0;
        mySize = 5;
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