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


