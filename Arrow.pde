class Arrow {
  float x, y;
  float velX, velY;
  float angle;

  Arrow(float x, float y) {
    this.x = x;
    this.y = y;
    this.velX = 0;
    this.velY = 0;
    this.angle = 0;
  }

  Arrow(float x, float y, float power, float ang) {
    this.x = x;
    this.y = y;
    // Reduce initial speed for smoother flight
    this.velX = cos(ang) * power * 0.9;
    this.velY = sin(ang) * power * 0.9;
    this.angle = ang;
  }

  void update(float windStrength) {
    // Gravity
    velY += 0.08;

    // Wind effect
    velX += windStrength * 0.1;

    // Air resistance
    velX *= 0.995;
    velY *= 0.995;

    x += velX;
    y += velY;

    angle = atan2(velY, velX);
  }

  void display() {
    pushMatrix();
    translate(x, y);
    rotate(angle);

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

  float tipX() { return x + cos(angle) * -60; }
  float tipY() { return y + sin(angle) * -60; }
}
