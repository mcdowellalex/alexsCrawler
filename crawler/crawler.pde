
/**
    this is the main crawler file
    run this to start the game
    @author: Alex McDowell
    February 2021
**/


import processing.serial.*;
Serial port;

//constants
int WIDTH = 500;
int HEIGHT = 500;
color gameBlue = color(66, 135, 245);

//menu variables
boolean optionMenu = false;
int menuSelection;
int optionSelection;
color unselectedColor = color(180); //white
color selectedColor = color(255); //light grey
color startGameColor = unselectedColor;
color optionsColor = unselectedColor;
//player color options
color color0 = color(15, 53, 115);
color color1 = color(70, 163, 44);
color color2 = color(245, 245, 110);
color color3 = color(204, 18, 34);


//player variables
float playerSize = 20;
Player player = new Player(playerSize, color0);
float xPos = 250;
float yPos = 400;
float newXstep = 0;
float newYstep = 0;
FloatList lastStepX = new FloatList();
FloatList lastStepY = new FloatList();
float smoothedX = 0;
float smoothedY = 0;
int ammo = 3;
boolean isPlayerDead = true;
int lastGameScore = -1;

//enemy variables
float enemySpeed = 1;
ArrayList<Enemy> enemies = new ArrayList<Enemy>();
int numEnemies = 75;

//coin variables
ArrayList<Coin> coins = new ArrayList<Coin>();
int numCoins = 10;

//lazer beamz
ArrayList<Ammo> beams = new ArrayList<Ammo>(); 
int numBeams = 5;


void setup(){
    //initiate smoothing lists with 0s
    lastStepX.append(0);lastStepX.append(0);lastStepX.append(0);lastStepX.append(0);lastStepX.append(0);
    lastStepY.append(0);lastStepY.append(0);lastStepY.append(0);lastStepY.append(0);lastStepY.append(0);

    //create board
    size(500,500);

    //start player in middle bottom
    xPos = width/2;
    yPos = height * (3/4);

    //create a list of enemy objects
    createEnemies();

    //create a list of coin objects
    createCoins();

    //create list of beams
    createBeams();

    //print out coms
    printArray(Serial.list());

    //create port to read from controller
    port = new Serial(this, Serial.list()[0], 115200);
    port.bufferUntil(10);
}

void draw(){
    if (isPlayerDead) { //go to main menu
        if (optionMenu){ //in option menu
            background(30);
            fill(255);
            textSize(24);
            text("Choose your color", 150, 50);
            textSize(16);

            //color 0
            text("Color 0: ", 100, 150);
            if (optionSelection == 0){
                stroke(255);
                line(95,160, 170,160);
            }
            fill(color0);
            noStroke();
            square(200, 135, 20);

            //color 1
            fill(255);
            text("Color 1: ", 100, 250);
            if (optionSelection == 1){
                stroke(255);
                line(95,260, 170,260);
            }
            fill(color1);
            noStroke();
            square(200, 235, 20);

            //color 2
            fill(255);
            text("Color 2: ", 100, 350);
            if (optionSelection == 2){
                stroke(255);
                line(95,360, 170,360);
            }
            fill(color2);
            noStroke();
            square(200, 335, 20);

            //color 3
            fill(255);
            text("Color 3: ", 100, 450);
            if (optionSelection == 3){
                stroke(255);
                line(95,460, 170,460);
            }
            fill(color3);
            noStroke();
            square(200, 435, 20);

        }else{ //main menu
            //map pitch to option select
            if (menuSelection == 0){ //highlight start game
                startGameColor = selectedColor;
                optionsColor = unselectedColor;
            }else if (menuSelection == 1){ //hightlight options
                startGameColor = unselectedColor;
                optionsColor = selectedColor;
            }

            background(30);
            noStroke();
            textSize(40);
            //start game
            fill(startGameColor);
            rect(100,100,300,100,10);
            if (menuSelection == 0){
                stroke(gameBlue);
                line(130,180, 370,180);
            }
            //options
            fill(optionsColor);
            rect(100,250,300,100,10);
            if (menuSelection == 1){
                stroke(gameBlue);
                line(130,330, 370,330);
            }
            fill(gameBlue);
            text("Start Game", 150, 165);
            text("Options", 175, 315);
            
            if (lastGameScore >= 0){ //default is -1
                fill(255,0,0);
                textSize(24);
                text("Your Score: " + lastGameScore, 170, 400);
            }
        }
        
    } else { //continue the game
        // clear the previous frame,
        background(30);

        //draw enemies
        moveEnemies();

        //draw coins
        moveCoins();
        
        //fire them lazer beams
        letTheBeamsTravel();
        
        //draw player
        player.move(newXstep, newYstep);

        //draw player points and current ammo
        fill(220);
        rect(0,0, 70, 50);
        fill(0);
        textSize(12);
        text("Points: "+player.points, 5,15);
        text("Ammo: "+ammo, 5,30);
        text("Lives: "+player.lives, 5, 45);

        //check collisions with enemy, coins, and ammo
        checkCollisions();
        

        //move any enemies that fell off the bottom back to the top
        replaceEnemies();
        replaceCoins();
        replaceBeams();
    }
    
}

void killPlayer(){
    isPlayerDead = true;
    
    //reset everything in the game

    //reset difficulty
    enemySpeed = 1;
    //reset enemies - cant clear and create new enemies bc this
    //  causes a concurrent modification error 
    for (Enemy enemy : enemies){
        enemy.setY(random(-1000, -50));
        enemy.setX(random(width - 20));
        enemy.setSpeed(enemySpeed);
    }
    //reset coins - same issue with coins as with enemies (see 4 lines up)
    for (Coin coin : coins){
        coin.setY(random(-1000, -50));
        coin.setX(random(width - 20));
    }
    //reset ammo
    ammo = 1;
    //reset player pos
    player.myX = 250;
    player.myY = 400;    
    //reset points
    lastGameScore = player.points;
    player.points = 0;
    //reset player lives
    player.lives = 3;

}

//player is at the menu and hit the a button
void menuClick(){
    if (optionMenu){ //in options menu
        if (optionSelection == 0){
            player.myColor = color0;
        }else if (optionSelection == 1){
            player.myColor = color1;
        }else if (optionSelection == 2){
            player.myColor = color2;
        }else if (optionSelection == 3){
            player.myColor = color3;
        }
        optionMenu = false;
    }else if (!optionMenu){ //in main menu
        if (menuSelection == 0){ //start game is highlighted
            isPlayerDead = false;
        }else if (menuSelection == 1){ //options is highlighted
            optionMenu = true;
        }
    }
    
}

void addPoint(){
    player.addPoint();
    updateAmmo();
    updateDifficulty();

}

void updateDifficulty(){
    if (player.points > 0){
        if ((player.points % 2) == 0){
            enemySpeed += 0.1;
            for (Enemy enemy : enemies){
                enemy.setSpeed(enemySpeed);
            }
        }
    }
}

void updateAmmo(){
    if (player.points > 0){
        if ((player.points % 5) == 0){
            if (ammo < numBeams){
                ammo += 1;
            }
        }
    }
}

void letTheBeamsTravel(){
    for (Ammo beam: beams){
        if (beam.isActive){
            beam.fire(); //moves it up 1
        }
        
    }
}
void replaceBeams(){
    for (Ammo beam: beams){
        if (beam.getY() < 0){
            beam.makeInactive();
        }   
    }
}
void replaceEnemies(){
    for (Enemy enemy: enemies){
        if (enemy.getY() > height){
            enemy.setY(random(-1000, -50));
            enemy.setX(random(width - 20));
        }   
    }
}
void replaceCoins(){
    for (Coin coin : coins){
        if (coin.getY() > height){
            coin.setY(random(-1000, -50));
            coin.setX(random(width - 20));
        }
    }
}

void moveEnemies(){
    for (Enemy enemy: enemies){
        enemy.drop();
    }
}

//add ammo objects to list of beams
void createBeams(){
    for (int i=0; i<numBeams; i++){
        beams.add(new Ammo());
    }
}

//add enemies to array list of enemies
void createEnemies(){
    float enemyStartX = 0;
    float enemyStartY = 0;
    for (int i=0; i<numEnemies; i++){
        enemyStartX = random(width - 20);
        enemyStartY = random(-1000, -50);
        enemies.add(new Enemy(enemyStartX, enemyStartY, enemySpeed));
    }
}

void moveCoins(){
    for (Coin coin: coins){
        coin.drop();
    }
}

//add coins to array list of coins
void createCoins(){
    float coinStartX = 0;
    float coinStartY = 0;
    for (int i=0; i<numCoins; i++){
        coinStartX = random(width - 20);
        coinStartY = random(-1000, -50);
        coins.add(new Coin(coinStartX, coinStartY));
    }
}



void makeSound(){
   port.write(" ");
}

void checkCollisions(){
    //check for collisions between player and enemy
    for (Enemy enemy : enemies){
        if (checkCollisionWithEnemy(enemy)){
            //move enemy back to top
            enemy.setY(random(-1000, -50));
            enemy.setX(random(width - 20));
            //damage the player and check if they're dead
            player.damage();
            makeSound();
            if (player.lives <= 0){
                killPlayer();
            }
        }
    }
    //check for collisions with lazer beams and enemy
    for (Ammo beam : beams){
        for (Enemy enemy : enemies){
            if (enemyHitByBeam(beam, enemy)){
                //remove beam
                beam.makeInactive();
                //move it back off screen so it doesn't hit enemies
                beam.setX(-20); 
                //move enemy back to top
                enemy.setY(random(-1000, -50));
                enemy.setX(random(width - 20));
                addPoint();
            }
        }
    }
    //check for collisions with player and enemy
    for (Coin coin : coins){
        if (checkCollisionWithCoin(coin)){
            coin.setY(random(-1000, -50)); //move coin back to the top
            coin.setX(random(width - 20));
            addPoint();

        }
    }
    
}

boolean enemyHitByBeam(Ammo beam, Enemy enemy){
    float radius = beam.getSize() / 2;
    float beamTop = beam.getY() - radius;
    float beamBottom = beam.getY() + radius;
    float beamLeft = beam.getX() - radius;
    float beamRight = beam.getX() + radius;

    float enemyTop = enemy.getY();
    float enemyBottom = enemy.getY() + enemy.getSize();
    float enemyLeft = enemy.getX();
    float enemyRight = enemy.getX() + enemy.getSize();

    if (beamTop <= enemyBottom){
        if (beamBottom >= enemyTop){
            if (beamRight >= enemyLeft){
                if (beamLeft <= enemyRight){
                    return true;
                }
            }
        }
    }
    return false;
}

boolean checkCollisionWithCoin(Coin c){
    float playerTop = player.getY();
    float playerBottom = player.getY() + player.getSize();
    float playerLeft = player.getX();
    float playerRight = player.getX() + player.getSize();

    float radius = c.getSize() / 2;
    float coinTop = c.getY() - radius;
    float coinBottom = c.getY() + radius;
    float coinLeft = c.getX() - radius;
    float coinRight = c.getX() + radius;

    if (playerTop <= coinBottom){
        if (playerBottom >= coinTop){
            if (playerRight >= coinLeft){
                if (playerLeft <= coinRight){
                    return true;
                }
            }
        }
    }
    return false;
}
boolean checkCollisionWithEnemy(Enemy e){
    float playerTop = player.getY();
    float playerBottom = player.getY() + player.getSize();
    float playerLeft = player.getX();
    float playerRight = player.getX() + player.getSize();

    float enemyTop = e.getY();
    float enemyBottom = e.getY() + e.getSize();
    float enemyLeft = e.getX();
    float enemyRight = e.getX() + e.getSize();

    if (playerTop <= enemyBottom){
        if (playerBottom >= enemyTop){
            if (playerRight >= enemyLeft){
                if (playerLeft <= enemyRight){
                    return true;
                }
            }
        }

    }
    return false;
}

void fireALazerBeam(){
    if (ammo > 0){
        for(Ammo beam : beams){
            if (ammo > 0){
                if (!beam.isActive){
                    beam.setX(player.getX() + (player.getSize() / 2));
                    beam.setY(player.getY());
                    beam.makeActive();
                    ammo -= 1; //update visual
                    break;
                }
            }else{
                break;
            }
            
        }
    } 
}

void serialEvent(Serial port) {
    String data = port.readString();

    //update movement
    if (data.charAt(0) == 'm'){
        // println(data.substring(1));
        String[] dataList = split(data.substring(1), " ");
        newYstep = float(dataList[0]);
        menuSelection = int(map(newYstep, -180, 180, 0, 2));
        optionSelection = int(map(newYstep, -180, 180, 0, 4));
        newYstep = map(newYstep, -180, 180, -8, 8);
        newXstep = float(dataList[1]);
        newXstep = map(newXstep, -180, 180, -8, 8);
        smoothMovement(newXstep, newYstep);
    }

    //shoot lazzzzerrrr
    if (data.charAt(0) == 'l'){
        if (isPlayerDead){ //player is at menu
            menuClick();
        }else if (!isPlayerDead){ //player is playing
            fireALazerBeam();
        }
        
    }
}

void smoothMovement(float stepX, float stepY){
    //smooth the steps
    smoothedX = 0; //reset smoothedX
    lastStepX.append(stepX);
    lastStepX.remove(0);
    for (float x : lastStepX){
        smoothedX += x;
    }
    smoothedX = smoothedX / 5;

    smoothedY = 0;
    lastStepY.append(stepY);
    lastStepY.remove(0);
    for (float y : lastStepY){
        smoothedY += y;
    }
    smoothedY = smoothedY / 5;

    this.newXstep = smoothedX;
    this.newYstep = smoothedY;

}