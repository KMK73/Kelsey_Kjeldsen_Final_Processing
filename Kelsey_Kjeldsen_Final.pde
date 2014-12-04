import ddf.minim.*; //for sound library
Catcher catcher;    // One catcher object
Timer timer;  // Timer for drops
BoxTimer boxTimer; //timer for bricks


int timeLimit = 30000;
int timeStart = millis();
int timeRemaining;
int timePassed;

//sound library coin sound
Minim minim;
AudioSample coin; 
AudioSample boxSound;

//load start screen image
PImage startScreen;

// An array of drop objects
ArrayList<Drop> drops;
int totalDrops = 0; // totalDrops

/*GAME STATES VARIABLES
   *********************************************************************/
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
//boolean gamePause;
int gameState;

// Variables to keep track of score, level, lives left
int score;      // User's score
int level = 1;      // What level are we on
int lives;     // 5 lives per level 
int levelCounter = 0; //counting for the levels 

PFont f;

/* VOID SETUP 
   *********************************************************************/
void setup() {

  //  start screen image load
  startScreen = loadImage("startScreen.jpg");
  println ("timeStart1 " + timeStart);

  displayX = round(displayWidth*.8);
  displayY = round(displayHeight*.8); //have to round to make an int
  size(displayX, displayY);

  image(startScreen, 0, 0, displayX, displayY);

  //timer for until game ends
  int timeLimit = 30000;
  timeStart = millis();


  //sound import
  minim = new Minim(this);
  coin = minim.loadSample("coin-04.wav", 512);
  boxSound = minim.loadSample("collision.wav", 512);
  
  //start of game, when it ends value is 2 (game actually over)
  gameState = GAME_WAITING;

  smooth();
  ellipseMode(CENTER);
  f = createFont("font", 12, true); 

  totalDrops = 0;
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
  boxTimer = new BoxTimer (1000);   // Create a timer for bricks, goes off every .5 second
  boxTimer.start();  // Starting the timer for bricks
  totalBoxes = 0;
}

/*VOID DRAW 
   ********************************************************/
void draw() {

/*GAME OVER FUNCTION
   ********************************************************/
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

/*PLAYING GAME
   ********************************************************/
  if (gameState==GAME_PLAYING) {
    //background white
    background(255);

    //display catcher
    catcher.display(); 
    catcher.move();

/*COUNTDOWN TIMER for time remaining in game
   ********************************************************/
    timePassed = (millis() - timeStart);
    timeRemaining = (timeLimit - timePassed);
    println ("timeRemaining"+ timeRemaining); 
    println ("timePassed" + timePassed);
    println ("timeStart2 " + timeStart);
    println ("timeLimit" + timeLimit); 
    
    //when timer hits 0 seconds game over 
    if (timeRemaining <=0) {
      gameState = GAME_OVER;
      timeStart = 0; //reseting the timer start     
    }
      

/*DROP TIMER
   ********************************************************/
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

/*BRICKS TIMER
   ********************************************************/
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

/*DROPS COLLISION and DISPLAY
   ********************************************************/
    for (int i = 0; i < drops.size (); i++ ) {
      drops.get(i).move();
      drops.get(i).display();

      // Everytime you catch a drop, the score goes up
      if (catcher.isCollidingCircle(drops.get(i))) {
        drops.get(i).caught();
        coin.trigger(); //trigger playing sound when collision occurs
        //        levelCounter++; //count this in amount of drops before new level
        score++;
      }
    }


/*BRICKS COLLISION and DISPLAY
   ********************************************************/
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
          gameState = GAME_OVER; 
        }
      }
    }


/*TOP ELEMENTS on game screen. Lives left, time remaining, game score
   ********************************************************/
    // Display number of lives left
    textFont(f, 14);
    fill(0);
    textAlign(LEFT); //need to reset this to keep it aligned after CENTER is called
    text("Lives left: " + lives, 10, 20);
    fill(#989898);
    stroke(1);
    rect(10, 24, lives*20, 20); //line showing levels and the width is adjusted everytime you lose a life
    fill(0);
    text("Time Left: " + (timeRemaining)/1000, 300, 20); 
    text("Score: " + score, 300, 40);
  }
}

/*KEYS FOR CHANGING GAME STATES
   ********************************************************/
void keyPressed() {
  switch(gameState) {
  case GAME_WAITING:
    //check keys when waiting for game and spacebar to start
    if (key == ' ') {
      timeStart = 0; //want to make sure it starts at 0
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

/*RESETING THE GAME AFTER GAME ENDS
   ********************************************************/
void restart() {
  gameState = GAME_WAITING;

  //reset variables
  totalBoxes = 0;
  totalDrops = 0;
  lives = 5;
  score = 0;
  timeStart = 0;
  timeRemaining = 30000;

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


