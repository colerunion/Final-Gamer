class Target {
  float x, y, size;
  float speed = 2.0;
  int direction = 1;

  Target(float x, float y, float size) {
    this.x = x;
    this.y = y;
    this.size = size;
  }

  void display() {
    noStroke();
    fill(0, 40);
    ellipse(x + 6, y + 6, size * 0.9, size * 0.9);

    stroke(0);
    strokeWeight(3);
    fill(255, 0, 0);
    ellipse(x, y, size, size);

    fill(255);
    ellipse(x, y, size * 0.6, size * 0.6);

    fill(0, 0, 255);
    ellipse(x, y, size * 0.3, size * 0.3);
  }

  void still() {
  }

  void moveSlow() {
    y += speed * 0.6 * direction;
    bounce();
  }

  void moveFast() {
    y += speed * 1.6 * direction;
    bounce();
  }

  void bounce() {
    if (y < size/2 + 10 || y > height - size/2 - 10) direction *= -1;
  }

  void resetPosition() {
    y = random(size/2 + 20, height - size/2 - 20);
  }

  int checkScore(Arrow a) {
    if (a == null) return 0;
    float tx = a.tipX();
    float ty = a.tipY();
    float d = dist(tx, ty, x, y);
    if (d < size * 0.15) return 50;
    if (d < size * 0.30) return 20;
    if (d < size * 0.50) return 10;
    return 0;
  }
}
