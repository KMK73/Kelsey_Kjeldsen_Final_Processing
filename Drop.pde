
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


