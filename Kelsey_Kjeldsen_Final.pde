Catcher catcher;    // One catcher object
Timer timer;        // One timer object

//load start screen image
PImage startScreen;
int stage; //stage for game

// An array of drop objects
ArrayList<Drop> drops;
int totalDrops = 0; // totalDrops

final int GAME_WAITING = 0;
final int GAME_PLAYING = 1;
final int GAME_OVER = 2;

//setting the boxes
//Box box1;
//Box box2;
//Box box3;
//Box box4;
ArrayList<Box> boxes;

//dynamic screen size variables 
int displayX;
int displayY;

// A variable to start/end game 
//boolean gameOver;
int gameState;

// Variables to keep track of score, level, lives left
int score;      // User's score
int level = 1;      // What level are we on
int lives;     // 5 lives per level 
int levelCounter = 0; //counting for the levels 

PFont f;

void setup() {
  //make a dynamic screen size and needs to round because it has to be an int
  //  start screen image load
  startScreen = loadImage("startScreen.jpg");

  displayX = round(displayWidth*.8);
  displayY = round(displayHeight*.8); //have to round to make an int
  int startImageWidth = int(displayWidth * .8);
  startScreen.resize(startImageWidth, 0);

  size(displayX, displayY);

  image(startScreen, 0, 0);

  //start of game, when it ends value is 2 (game actually over)
  gameState = GAME_WAITING;

  smooth();
  ellipseMode(CENTER);

  totalDrops = 0;
  //  gameOver = false;
  lives = 5;
  score = 0;

  /*code adapted from:
   // Learning Processing
   // Daniel Shiffman
   adapted by: Kelsey Kjeldsen
   ********************************************************/

  catcher = new Catcher(); // Create the catcher 
  drops = new ArrayList<Drop>();
  timer = new Timer(750);   // Create a timer that goes off every .5 second
  timer.start();             // Starting the timer

  f = createFont("font", 12, true); 

  //array of boxes
  boxes = new ArrayList<Box>();
}

void draw() {

  // If the game is over
  if (gameState==GAME_OVER) {
    background(255);
    textFont(f, 40);
    textAlign(CENTER);
    fill(0);
    text("GAME OVER", width/2, height/2);
    fill(255, 0, 0);
    textFont(f, 20);
    text("SCORE " +score, width/2, height/2+40);
    text("To play again press SPACEBAR", width/2, height/2+80);

    //    //key to start game 
    //    if (keyPressed == true) {
    //      gameOver= 1;
    //    }
  }
  if (gameState==GAME_PLAYING) {
    background(255);

    //    // Display the catcher
    //    if (keyPressed) {
    //      //      catcher.move();
    //      if (keyCode == LEFT) {
    //        catcher.x -= 3.5f;
    //        if (catcher.x <= 0) {
    //          catcher.x =0;
    //        }
    //      }
    //      if (keyCode == RIGHT) {
    //        catcher.x += 3.5f;
    //        if (catcher.x >= width- catcherImage.width) {
    //          catcher.x =width-catcherImage.width;
    //        }
    //      }
    //    }

    //display catcher
    catcher.display(); 
    catcher.move();

    // Check the timer
    if (timer.isFinished()) {
      // if timer is finished send another drop
      // Initialize one drop
      Box box = new Box();
      boxes.add(box);
      Drop drop = new Drop();
      drops.add(drop);
      totalDrops++;
      if (totalDrops >= 1000) { 
        // start array over
        totalDrops=0;
      }
      timer.start();
    } 
    println(drops.size());

    for (int i = 0; i < drops.size (); i++ ) {
      drops.get(i).move();
      drops.get(i).display();

      // Everytime you catch a drop, the score goes up
      if (catcher.isCollidingCircle(drops.get(i))) {
        drops.get(i).caught();
        levelCounter++; //count this in amount of drops before new level
        score++;
      }
    }


    for (int i = 0; i < boxes.size (); i++ ) {
      boxes.get(i).display();
      // collision detection
      if (catcher.isCollidingBox(boxes.get(i))) {
        lives--;
        //        boxes.get(i).resetWhenCollisionDetected(); //allow the box to go back to the top
        boxes.remove(i);
        //If lives reach 0 the game is over
        if (lives <= 0) {
          gameState = GAME_OVER; //2 is the game end value
        }
      }
    }

    // If 25 drops are caught, that level is over!
    if (levelCounter >= 25) { 
      // Go up a level
      level++;
      // Reset all game elements
      levelCounter = 0;
      //lives++; //add a life every level 
      totalDrops = 0;
    }


    // Display number of lives left
    textFont(f, 14);
    fill(0);
    textAlign(LEFT);
    text("Lives left: " + lives, 10, 20);
    fill(#989898);
    stroke(1);
    rect(10, 24, lives*20, 20); //line showing levels and the width is adjusted everytime you lose a life
    fill(0);
    text("Level: " + level, 300, 20);
    text("Score: " + score, 300, 40);
  }
}

void keyPressed() {
  switch(gameState) {
  case GAME_WAITING:
    //check keys when waiting for game
    if (key == ' ') {
      //do something for space 
      gameState = GAME_PLAYING;
    }
    break;

  case GAME_PLAYING:
    break;

  case GAME_OVER:
    if (key == ' ') {
      restart();
    }
    //        if( gameState == GAME_OVER) {
    //          if (key == UP) {
    //          setup();
    //          }
    //        }
    break;
  }
}  
//
//if (gameState == GAME_OVER) {
//  if (key == UP) {
//    setup();
//  }
//}
//}


void restart() {
  gameState = GAME_WAITING;

  totalDrops = 0;
  //  gameOver = false;
  lives = 5;
  score = 0;

  /*code adapted from:
   // Learning Processing
   // Daniel Shiffman
   adapted by: Kelsey Kjeldsen
   ********************************************************/

  catcher = new Catcher(); // Create the catcher 
  drops = new ArrayList<Drop>();
  timer = new Timer(750);   // Create a timer that goes off every .5 second
  timer.start();             // Starting the timer

  //array of boxes
  boxes = new ArrayList<Box>();
}

