import ddf.minim.*; //for sound library
Catcher catcher;    // One catcher object
Timer timer;  // Timer for drops
BoxTimer boxTimer; //timer for bricks

//sound library coin sound
Minim minim;
AudioSample coin; 
AudioSample boxSound;

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
ArrayList<Box> boxes;
int totalBoxes = 0; // total boxes

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
  //  int startImageWidth = int(displayHeight * .8);
  //  startScreen.resize(0, startImageWidth);

  size(displayX, displayY);

  image(startScreen, 0, 0, displayX, displayY);

  //sound import
  minim = new Minim(this);

  coin = minim.loadSample("coin-04.wav", 512);
  boxSound = minim.loadSample("collision.wav", 512);
  // if a file doesn't exist, loadSample will return null
  if ( coin == null ) println("Didn't get coin sample music!");
  if ( boxSound == null ) println("Didn't get collision box sound!");

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
  boxTimer = new BoxTimer (1000);   // Create a timer for bricks, goes off every .5 second
  boxTimer.start();  // Starting the timer for bricks
  totalBoxes = 0;
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
  }
  if (gameState==GAME_PLAYING) {
    background(255);


    //display catcher
    catcher.display(); 
    catcher.move();

    // Check the drops timer
    if (timer.isFinished()) {
      // if timer is finished send another drop
      // Initialize one drop
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

    // Check the box timer
    if (boxTimer.isFinished()) {
      // if timer is finished send another box
      // Initialize one drop
      Box box = new Box();
      boxes.add(box);
      totalBoxes++;
      if (totalBoxes >= 1000) { 
        // start array over
        totalBoxes=0;
      }
      boxTimer.start();
    } 
    println(drops.size());

    for (int i = 0; i < drops.size (); i++ ) {
      drops.get(i).move();
      drops.get(i).display();

      // Everytime you catch a drop, the score goes up
      if (catcher.isCollidingCircle(drops.get(i))) {
        drops.get(i).caught();
        coin.trigger(); //trigger playing sound when collision occurs
        levelCounter++; //count this in amount of drops before new level
        score++;
      }
    }


    for (int i = 0; i < boxes.size (); i++ ) {
      boxes.get(i).display();
      // collision detection
      if (catcher.isCollidingBox(boxes.get(i))) {
        boxSound.trigger(); //trigger playing sound when collision occurs
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
    if (levelCounter >= 10) { 
      // Go up a level
      level++;
      // Reset all game elements
      levelCounter = 0;
      //lives++; //add a life every level 
      totalDrops = 0;
      totalBoxes = 0;
    }


    // Display number of lives left
    textFont(f, 14);
    fill(0);
    textAlign(LEFT); //need to reset this to keep it aligned after CENTER is called
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
    //check keys when waiting for game and spacebar to start
    if (key == ' ') {
      gameState = GAME_PLAYING;
    }
    break;

  case GAME_PLAYING:
    break;

  case GAME_OVER:
    if (key == ' ') {
      //call restart function to start game again with spacebar
      restart();
    }
    break;
  }
}  

void restart() {
  gameState = GAME_WAITING;

  //reset variables
  totalBoxes = 0;
  totalDrops = 0;
  lives = 5;
  score = 0;

  //restarting the arrays and timer
  catcher = new Catcher(); // Create the catcher 
  drops = new ArrayList<Drop>();
  timer = new Timer(750);   // Create a timer that goes off every .5 second
  timer.start();             // Starting the timer

  //array of boxes
  boxes = new ArrayList<Box>();
  boxTimer= new BoxTimer(1000);
  boxTimer.start();
}

