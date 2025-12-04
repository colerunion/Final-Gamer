class Bow {
  float x, y;

  Bow(float x, float y) {
    this.x = x;
    this.y = y;
  }

  float getAngle() {
    float raw = atan2(mouseY - y, mouseX - x);
    float eps = 0.05;
    return constrain(raw, -HALF_PI + eps, HALF_PI - eps);
  }

  void display() {
    float ang = getAngle();
    pushMatrix();
    translate(x, y);
    rotate(ang);

    float bend = charging ? min(chargePower * 2, bowMaxBend) : 0;
    float arcWidth = 80 + bend;

    // Bow shaft
    stroke(139, 69, 19);
    strokeWeight(6);
    noFill();
    arc(0, 0, arcWidth, 150, -HALF_PI, HALF_PI);

    // Bow string
    stroke(0);
    strokeWeight(2);
    line(0, -75, -bend, 0);
    line(0, 75, -bend, 0);

    // Arrow on bow before shooting
    if (!arrowFlying && currentArrowsRemaining() > 0) {
      drawNockedArrow(bend);
    }

    popMatrix();
  }

  void drawNockedArrow(float bendAmount) {
    pushMatrix();
    translate(-bendAmount, 0);

    // Shaft
    stroke(139, 69, 19);
    strokeWeight(4);
    line(0, 0, -60, 0);

    // Tip
    noStroke();
    fill(130);
    beginShape();
    vertex(0, 0);
    vertex(-12, -6);
    vertex(-12, 6);
    endShape(CLOSE);

    // Feathers
    fill(255, 0, 0);
    pushMatrix();
    translate(-60, 0);
    rotate(radians(20));
    rect(0, -6, 18, 4);
    rotate(radians(-40));
    rect(0, 2, 18, 4);
    popMatrix();
    rect(-60, -2, 18, 4);

    popMatrix();
  }
}
