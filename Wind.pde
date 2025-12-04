class Wind {
  float strength = 0;

  void setForRound(int round) {
    if (round == 1) strength = 0;
    else if (round == 2) strength = random(-0.10, -0.05);
    else if (round == 3) strength = random(-0.25, -0.10);
  }

  void setForBonus() {
    strength = random(-0.25, -0.15);
  }

  float getStrength() {
    return strength;
  }

  String getFormatted() {
    return nf(strength, 1, 2);
  }

  void update() {
  }
}
