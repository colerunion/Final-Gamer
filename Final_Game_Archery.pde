PImage backgroundPic;
import processing.sound.*;

SoundFile backgroundMusic;
SoundFile arrowSound;

final int MENU = 0;
final int HOWTO = 1;
final int PLAYING = 2;
final int TRANSITION = 3;
final int GAMEOVER = 4;

int state = MENU;

Bow bow;
Arrow currentArrow;
Target target;
Wind wind;
Buttons startBtn, howBtn, quitBtn, backBtn, menuBtn;

int roundNum = 1;
int arrowsPerRound = 10;
int arrowsUsedThisRound = 0;
int arrowsPerBonus = 7;
boolean bonusRound = false;

boolean charging = false;
float chargePower = 0;
float chargeMax = 18;
float bowMaxBend = 40;
boolean arrowFlying = false;

int score = 0;
int combo = 0;
float comboMultiplier = 1.0;
int comboTimer = 0;
int comboTimeLimit = 240;

void setup() {
  size(700, 600);
  rectMode(CORNER);
  textFont(createFont("Arial", 14));
  setupObjectsAndUI();

  wind.setForRound(roundNum);
  backgroundPic = loadImage("backgroundPic.jpg");
  //backgroundPic.resize(width, height);
  arrowSound = new SoundFile(this, "arrowWoosh.wav");
  backgroundMusic = new SoundFile(this, "background.mp3");
  backgroundMusic.loop();
}

void setupObjectsAndUI() {
  bow = new Bow(140, height/2);
  target = new Target(width - 150, height/2, 110);
  wind = new Wind();

  float cx = width/2;
  float cy = height/2;

  startBtn = new Buttons(cx, cy - 70, 260, 64, "START GAME");
  howBtn  = new Buttons(cx, cy + 0, 260, 64, "HOW TO PLAY");
  quitBtn = new Buttons(cx, cy + 80, 260, 64, "QUIT");

  backBtn = new Buttons(cx, height - 90, 200, 56, "BACK");
  menuBtn = new Buttons(cx, height - 90, 200, 56, "MENU");
}

void draw() {
  image(backgroundPic, 0, 0, width, height);
  wind.update();

  switch(state) {
    case MENU:
      drawMenu();
      break;
    case HOWTO:
      drawHowToPlay();
      break;
    case PLAYING:
      runGame();
      break;
    case TRANSITION:
      drawTransition();
      break;
    case GAMEOVER:
      drawGameOver();
      break;
  }
}

// -----------------------
// MENU
// -----------------------
void drawMenu() {
  background(70, 130, 200);
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(52);
  text("ARCHERY CHALLENGE", width/2, 140);

  startBtn.display();
  howBtn.display();
  quitBtn.display();
}

// -----------------------
// HOW TO PLAY
// -----------------------
void drawHowToPlay() {
  background(245);
  fill(10);
  textAlign(CENTER, CENTER);
  textSize(48);
  text("HOW TO PLAY", width/2, 80);

  textAlign(CENTER, TOP);
  textSize(20);
  fill(0);

  String instructions =
    "• Move the mouse to aim.\n\n" +
    "• HOLD MOUSE to draw the bow.\n" +
    "  Power increases and caps at maximum.\n\n" +
    "• RELEASE to fire.\n\n" +
    "• Wind affects arrow.\n\n" +
    "• Hits give points; center gives more.\n" +
    "• Consecutive hits increase COMBO MULTIPLIER.\n\n";

  text(instructions, width/2, 150);
  backBtn.display();
}

// -----------------------
// PLAY
// -----------------------
void runGame() {
  fill(255);
  textAlign(LEFT);
  textSize(16);
  text("Round: " + roundNum + (bonusRound ? " (BONUS)" : ""), 20, 26);
  text("Arrows left: " + currentArrowsRemaining(), 20, 52);
  text("Score: " + score, 20, 78);
  text("Wind: " + wind.getFormatted(), 20, 104);

  if (combo > 0) {
    fill(10, 120, 10);
    textSize(20);
    text("COMBO x" + nf(comboMultiplier, 1, 2), 20, 134);
  }

  if (!bonusRound) {
    if (roundNum == 1) target.still();
    else if (roundNum == 2) target.moveSlow();
    else target.moveFast();
  } else {
    target.moveFast();
  }

  target.display();
  bow.display();

  if (charging) {
    chargePower += 0.15; // slower charging
    chargePower = min(chargePower, chargeMax);
  }

  // Arrow flying
  if (arrowFlying && currentArrow != null) {
    currentArrow.update(wind.getStrength());
    currentArrow.display();

    int base = target.checkScore(currentArrow);
    if (base > 0) {
      combo++;
      comboMultiplier = 1.0 + combo * 0.25;
      comboTimer = comboTimeLimit;
      score += int(base * comboMultiplier);

      arrowFlying = false;
      currentArrow = null;

      if (isRoundOverAfterShot()) state = TRANSITION;
    }

    if (currentArrow != null &&
       (currentArrow.x > width || currentArrow.x < 0 ||
        currentArrow.y > height || currentArrow.y < 0)) {
      arrowFlying = false;
      currentArrow = null;
      combo = 0;
      comboMultiplier = 1.0;
      comboTimer = 0;
      if (isRoundOverAfterShot()) state = TRANSITION;
    }
  }

  if (combo > 0) {
    comboTimer--;
    if (comboTimer <= 0) {
      combo = 0;
      comboMultiplier = 1.0;
    }
  }
}

// -----------------------
// TRANSITION
// -----------------------
void drawTransition() {
  background(50, 50, 50, 220);
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(40);
  text("Round Complete!", width/2, height/2 - 80);
  textSize(22);
  text("Score: " + score, width/2, height/2 - 30);

  if (combo > 1) {
    fill(160, 255, 160);
    text("Combo x" + nf(comboMultiplier, 1, 2), width/2, height/2 + 10);
  }

  fill(255);
  textSize(18);
  text("Click anywhere to continue", width/2, height/2 + 60);
}

// -----------------------
// GAME OVER
// -----------------------
void drawGameOver() {
  background(20);
  fill(255);
  textAlign(CENTER, CENTER);

  textSize(64);
  text("GAME OVER", width/2, height/4);

  textSize(28);
  fill(200);
  text("FINAL SCORE", width/2, height/2 - 40);

  fill(255, 200, 0);
  textSize(70);
  text(score, width/2, height/2 + 20);

  menuBtn.y = height/2 + 120;
  menuBtn.display();

  quitBtn.y = height/2 + 200;
  quitBtn.display();
}

// -----------------------
// INPUT
// -----------------------
void mousePressed() {
  if (state == TRANSITION) {
    proceedToNextRound();
    return;
  }

  if (state == MENU) {
    if (startBtn.isHovering()) { startNewGame(); return; }
    if (howBtn.isHovering()) { state = HOWTO; return; }
    if (quitBtn.isHovering()) { exit(); return; }
  }

  if (state == HOWTO) { if (backBtn.isHovering()) state = MENU; return; }
  if (state == GAMEOVER) { if (menuBtn.isHovering()) state = MENU; if (quitBtn.isHovering()) exit(); return; }

  if (state == PLAYING && !arrowFlying && currentArrowsRemaining() > 0) {
    if (mouseButton == LEFT) {
      charging = true;
      chargePower = 0;
    }
  }
}

void mouseReleased() {
  if (state == PLAYING && charging && !arrowFlying && mouseButton == LEFT) {
    charging = false;
    arrowsUsedThisRound++;
    float p = constrain(chargePower, 5, chargeMax);
    float a = bow.getAngle();
    currentArrow = new Arrow(bow.x, bow.y, p, a);
    arrowFlying = true;
    chargePower = 0;
    arrowSound.play();
  }
}

void mouseDragged() {
  if (charging) {
    chargePower += 0.15;
    chargePower = min(chargePower, chargeMax);
  }
}

// -----------------------
// ROUND MANAGEMENT
// -----------------------
int currentArrowsRemaining() {
  return bonusRound ? max(0, arrowsPerBonus - arrowsUsedThisRound) :
                      max(0, arrowsPerRound - arrowsUsedThisRound);
}

boolean isRoundOverAfterShot() {
  return currentArrowsRemaining() <= 0;
}

void proceedToNextRound() {
  arrowsUsedThisRound = 0;
  if (!bonusRound) {
    roundNum++;
    if (roundNum >= 4) {
      if (score >= 500) {
        bonusRound = true;
        arrowsUsedThisRound = 0;
        wind.setForBonus();
        target.resetPosition();
        state = PLAYING;
      } else {
        state = GAMEOVER;
      }
    } else {
      wind.setForRound(roundNum);
      target.resetPosition();
      state = PLAYING;
    }
  } else {
    state = GAMEOVER;
  }
}

void startNewGame() {
  score = 0;
  combo = 0;
  comboMultiplier = 1.0;
  comboTimer = 0;
  roundNum = 1;
  arrowsUsedThisRound = 0;
  bonusRound = false;
  wind.setForRound(roundNum);
  target.resetPosition();
  currentArrow = null;
  arrowFlying = false;
  charging = false;
  chargePower = 0;
  state = PLAYING;
}
