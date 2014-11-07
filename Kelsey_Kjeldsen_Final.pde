
Catcher catcher;    // One catcher object
Timer timer;        // One timer object
//Drop[] drops;       // An array of drop objects
ArrayList<Drop> drops;
int totalDrops = 0; // totalDrops
//setting the boxes
Box box1;
Box box2;
Box box3;
Box box4;

// A boolean to let us know if the game is over
boolean gameOver;

// Variables to keep track of score, level, lives left
int score;      // User's score
int level = 1;      // What level are we on
int lives;     // 5 lives per level 
int levelCounter = 0; //counting for the levels 

PFont f;

void setup() {
  size(500, 500);
  smooth();
  ellipseMode(CENTER);

  totalDrops = 0;
  gameOver = false;
  lives = 5;
  score = 0;

  /*code adapted from:
   // Learning Processing
   // Daniel Shiffman
   adapted by: Kelsey Kjeldsen
   ********************************************************/

  catcher = new Catcher(); // Create the catcher 
  //  drops = new Drop[1000];    // Create 1000 spots in the array (each level now just has 25 drops)
  drops = new ArrayList<Drop>();
  timer = new Timer(500);   // Create a timer that goes off every .5 second
  timer.start();             // Starting the timer

  f = createFont("Arial", 12, true); 
  box1 = new Box();
  box2 = new Box();
  box3 = new Box();
  box4 = new Box();
}

void draw() {
  background(255);

  // If the game is over
  if (gameOver) {
    textFont(f, 40);
    textAlign(CENTER);
    fill(0);
    text("GAME OVER", width/2, height/2);
    fill(255, 0, 0);
    textFont(f, 20);
    text("SCORE " +score, width/2, height/2+40);
    text("To play again press R", width/2, height/2+80);
  } else {

    //display boxes 
    box1.display();
    box2.display();
    box3.display();
    box4.display();

    // Display the catcher
    catcher.display(); 
    if (keyPressed) {
//      catcher.move();
        if (keyCode == LEFT) {
          catcher.x -= 2.5f;
        }
        if (keyCode == RIGHT) {
          catcher.x += 2.5f;
        }
    }
//    catcher.keyPressed();

    // Check the timer
    if (timer.isFinished()) {
      // if timer is finished send another drop
      // Initialize one drop
      //      drops[totalDrops] = new Drop();
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


    // Move and display all drops
    //    for (int i = 0; i < totalDrops; i++ ) {
    //      drops[i].move();
    //      drops[i].display();
    //      // Everytime you catch a drop, the score goes up
    //      if (catcher.isCollidingCircle(drops[i])) {
    //        drops[i].caught();
    //        levelCounter++; //count this in amount of drops before new level
    //        score++;
    //      }
    //    }

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

    // collision detection
    if (catcher.isCollidingBox(box1)) {
      lives--;
      box1.resetWhenCollisionDetected(); //allow the box to go back to the top
      //If lives reach 0 the game is over
      if (lives <= 0) {
        gameOver = true;
      }
    }
    if (catcher.isCollidingBox(box2)== true) {
      lives--;
      box2.resetWhenCollisionDetected();
      if (lives <= 0) {
        gameOver = true;
      }
    }
    if (catcher.isCollidingBox(box3)== true) {
      lives--;
      box3.resetWhenCollisionDetected();
      if (lives <= 0) {
        gameOver = true;
      }
    }
    if (catcher.isCollidingBox(box4)== true) {
      lives--;
      box4.resetWhenCollisionDetected();
      if (lives <= 0) {
        gameOver = true;
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
  if (gameOver) {
    if (key == 'r') {
      //      gameOver=false;
      setup();
    }
  }
}

