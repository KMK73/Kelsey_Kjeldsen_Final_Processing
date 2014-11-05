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
    h= 40;
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
    //allow rectangle to move on the bottom
    x = x + speedX;
    //moving box right
    if (x >=width-40) {
      x= 460;
      speedX *= -.1;
    }
    //moving box left
    if (x <=0) {
      x=0;
      speedX *= -.1;
    }
  }

  void keyPressed() {
    if (keyCode == RIGHT) {
      speedX= speedX + .2;
    } 
    if (keyCode == LEFT) {
      speedX= speedX - .2;
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

