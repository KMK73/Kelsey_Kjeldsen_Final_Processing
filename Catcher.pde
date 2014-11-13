class Catcher {
  PShape catcherImage;
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
    catcherImage = loadShape("Game_character.svg");
    //    col = color(255, 0, 0);
    x = width/2;
    y = displayY - 80;
    //need to fix width/height percentages
    w = catcherImage.width* (displayWidth*.075);
    h = catcherImage.height* (displayHeight*.1);
    speedX = 0;
  }

  void display() {
    stroke(0);
    fill(col);
    //    rect(x, y, w, h);
    shape(catcherImage, x, y, w, h);
    if (level ==2) {
      catcherImage.scale(1.5);
//      w=30;
//      h=30;
    }
    if (level >=3) { //make the player catcher smaller as levels go up
      catcherImage.scale(1.5);
//      w=20;
//      h=20;
    }
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
    float myX2 = x+ catcherImage.width; // box x and width
//    float myX2 = x + w; // box x and width
    float myY2 = y + catcherImage.height; //box y and height
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

