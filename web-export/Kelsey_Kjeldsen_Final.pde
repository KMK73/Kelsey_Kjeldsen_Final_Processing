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

    if (keyPressed) {
      //      catcher.move();
      if (keyCode == LEFT) {
        catcher.x -= 2.5f;
        if(catcher.x <= 0) {
         catcher.x =0;
        }
      }
      if (keyCode == RIGHT) {
        catcher.x += 2.5f;
        if(catcher.x >= width-40) {
         catcher.x =460;
        }
      }
    }

    catcher.display(); 
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

class Box {

  float speedY; //speed down for rect
  float boxWidth;
  float boxHeight;
  float boxX;
  float boxY;

  Box () {
    boxHeight = random (10, 30);
    boxWidth = random (40, 200);
    boxX= random (0, width);
    boxY= random (-boxHeight, boxHeight);
    speedY= random(1, 4);
  }

  void display () {
    fill (#00FF39);
    stroke(1);
    rect(boxX, boxY, boxWidth, boxHeight);
    boxY= boxY + speedY;
    reset();
  }

  void reset() {
    if (boxY > height) {
      boxY=-10;
      boxX = random(width); //change x position at the top
      speedY = random(1, 2.5);
    }
  }

  //needed to reset after a collision so lives dont reduce all at once
  void resetWhenCollisionDetected() {
    boxY=-10;
    boxX = random(width); //change x position at the top
    speedY = random(1, 2.5);
  }
}


class Catcher {
  float w;   // width
  float h; //height
  color col; // color
  float x, y; // location
  float speedX;

  /*code adapted from:
   // Learning Processing
   // Daniel Shiffman
   adapted by: Kelsey Kjeldsen
   ********************************************************/
  Catcher() {
    col = color(255, 0, 0);
    x = 20;
    y = 460;
    w = 40;
    h = 40;
    speedX = 0;
  }

  void display() {
    stroke(0);
    fill(col);
    rect(x, y, w, h);
    if (level ==2) {
      w=30;
      h=30;
    }
    if (level >=3) { //make the player catcher smaller as levels go up
      w=20;
      h=20;
    }
  }

  void move() {
    // Check to see if a key is pressed
    
    //allow rectangle to move on the bottom
    x += speedX;
    //moving box right
    if (x >=width-40) {
      x= 460;
      speedX = 0;
    }
    //moving box left
    if (x <= 0) {
      x=0;
      speedX = 0;
    }
    
    println("Speed X " + speedX);
  }

  void keyPressed() {
    if (keyCode == RIGHT) {
      speedX = 2.5f;
    }
    if (keyCode == LEFT) {
      speedX = -2.5f;
    }
    if (key == ' ') { //that means spacebar to stop car
      speedX= 0;
    }
  }

  /*code adapted from:
   http://stackoverflow.com/questions/401847/circle-rectangle-collision-detection-intersection
   adapted by: Kelsey Kjeldsen
   ********************************************************/
  boolean isCollidingCircle(Drop d) {
    //calculate the distance in absolute value of the drops and the rectangle
    float circleDistanceX = abs(d.x - x - w/2);
    float circleDistanceY = abs(d.y - y - h/2);

    if (circleDistanceX > (w/2 + d.r)) { 
      return false;
    }
    if (circleDistanceY > (h/2 + d.r)) { 
      return false;
    }

    if (circleDistanceX <= (w/2)) { 
      return true;
    } 
    if (circleDistanceY <= (h/2)) { 
      return true;
    }

    float cornerDistance_sq = pow(circleDistanceX - w/2, 2) +
      pow(circleDistanceY - h/2, 2);

    return (cornerDistance_sq <= pow(d.r, 2));
  }

  //Box b is made for a temporary reference of either box1 or box2 when they pass through the boolean
  boolean isCollidingBox(Box b) {
    float myX2 = x + w; // box x and width
    float myY2 = y + h; //box y and height
    float otherX2 = b.boxX + b.boxWidth;
    float otherY2 = b.boxY + b.boxHeight;  

    //checking if the boxes hit each other by returning false when they are not touching 
    if ( x < b.boxX && myX2 < b.boxX) { //totally to the left not touching
      return false;
    }

    if ( x > otherX2 && myX2 > otherX2) { //totally right not touching 
      return false;
    }

    if ( y < b.boxY && myY2 < b.boxY) { //totally above not touching 
      return false;
    }

    if ( y > otherY2 && myY2 > otherY2) { //totally below not touching 
      return false;
    }

    return true; //because if all are false then they are colliding BOOM
  }
}


/*code adapted from:
 // Learning Processing
 // Daniel Shiffman
 adapted by: Kelsey Kjeldsen
 ********************************************************/

class Drop {
  float x, y;   
  float speed; 
  color c;
  float r;     

  // New variable to keep track of whether drop is caught
  boolean caught = false;

  Drop() {
    r = 20;               
    x = random(width);    
    y = -r*4;              // Start a little above the window
    speed = random(3, 6);   // Pick a random speed
    c = color(50, 100, 150);
  }

  // Move the drop down
  void move() {
    y += speed;
  }

  // Check if it hits the bottom
  boolean reachedBottom() {
    if (y > height + r*4) { 
      return true;
    } else {
      return false;
    }
  }

  // Display the drop
  void display() {
    // Display the drop
    if (level <=1) {
      fill(c);
    }
    if (level==2) {
      fill(#7600FF);
    }
    if (level >=3) {
      fill(#FF9F0D);
    }
    noStroke();
    for (int i = 2; i < r; i++ ) {
      ellipse(x, y, r, r);
    }
  }

  // If the drop is caught
  void caught() {
    speed =0; //stop drop from moving and set location far off screen
    y = -1000;
  }
}


/*code adapted from:
 // Learning Processing
 // Daniel Shiffman
 adapted by: Kelsey Kjeldsen
 ********************************************************/

class Timer {

  int savedTime; // When Timer started
  int totalTime; // How long Timer should last

  Timer(int tempTotalTime) {
    totalTime = tempTotalTime;
  }

  void setTime(int t) {
    totalTime = t;
  }

  // Starting the timer
  void start() {
    // When the timer starts it stores the current time in milliseconds.
    savedTime = millis();
  }

  // The function isFinished() returns true if 1000ms pass
  boolean isFinished() { 
    // Check how much time has passed
    int passedTime = millis()- savedTime;
    if (passedTime > totalTime) {
      return true;
    } else {
      return false;
    }
  }
}


