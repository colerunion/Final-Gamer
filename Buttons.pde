class Buttons {
  float x, y, w, h;
  String label;
  color bg, hoverC, txt;
  boolean hovered = false;

  Buttons(float x, float y, float w, float h, String label) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.label = label;
    bg = color(255);
    hoverC = color(230);
    txt = color(0);
  }

  void display() {
    hovered = isHovering();
    fill(hovered ? hoverC : bg);
    stroke(0);
    rectMode(CENTER);
    rect(x, y, w, h, 12);

    noStroke();
    fill(txt);
    textAlign(CENTER, CENTER);
    textSize(20);
    text(label, x, y);
  }

  boolean isHovering() {
    return mouseX > x - w/2 && mouseX < x + w/2 && mouseY > y - h/2 && mouseY < y + h/2;
  }
}
