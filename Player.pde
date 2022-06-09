final int PLAYER_SIZE = 30;
final int PLAYER_SPEED = 8;
final int PLAYER_HITBOX_SIZE = 4;
final int PLAYER_DATA_HEIGHT = 120;
final int PLAYER_BOMB_SPEED = 9;
final int PLAYER_BOMB_LENGTH = 100;
final float[] PLAYER_BOMB_PER_FRAME = {0.0007, 0.0005, 0.0004, 0.0003, 0.0002};

public class Player {
    float x, y, roll;
    float bomb = 2;
    float life = 2;
    float bombTime = -1;
    float bombX = 0;
    float bombY = 0;
    float inv = 0;
    float missAnimation = -1;
    Easing missAnimationEaseX;
    Easing missAnimationEaseY;

    Player(float xPos, float yPos) {
        x = xPos;
        y = yPos;
        roll = 0;
    }

    void update(Stage nowStage) {
        enemyMove = true;
        float moveX = 0;
        float moveY = 0;
        float speed = PLAYER_SPEED;
        if (missAnimation == -1) {
            if (KeyState.get(UP) != 0) { moveY -= 1; }
            if (KeyState.get(DOWN) != 0) { moveY += 1; }
            if (KeyState.get(LEFT) != 0) { moveX -= 1; }
            if (KeyState.get(RIGHT) != 0) { moveX += 1; }
            if (KeyState.get(SHIFT) != 0) { speed *= 0.3; }
            if (moveX != 0 || moveY != 0) {
                speed /= sqrt(abs(moveX) + abs(moveY));
                x = max(0, min(width, x + moveX * speed));
                y = max(0, min(height - PLAYER_DATA_HEIGHT, y + moveY * speed));
            }
            bomb += PLAYER_BOMB_PER_FRAME[level] * (max(min((float)(800 - y) / 800, 1), 0) + 1);
        }
        roll += 0.01 * speed;
        inv = max(0, inv - 1);
        if ((KeyState.get((int)'x') == 1 || KeyState.get((int)'X') == 1) && bomb >= 1 && inv < 100) {
            bomb -= bomb % 1 + 1;
            bombX = x;
            bombY = y;
            bombTime = 0;
            inv = PLAYER_BOMB_LENGTH;
            nowStage.loseBonus();
        }
        if (inv == 0 && enemyManager.hit(x, y)) {
            life--;
            bomb = 2;
            bombX = x;
            bombY = y;
            bombTime = 0;
            missAnimation = 0;
            inv = 120;
            nowStage.loseBonus();
        }
        if (bombTime != -1) {
            bombTime += 1;
            if (bombTime == PLAYER_BOMB_LENGTH) { bombTime = -1; }
            enemyManager.bomb(bombX, bombY, bombTime * PLAYER_BOMB_SPEED);
        }
        if (missAnimation != -1) {
            missAnimation += 1;
            if (missAnimation == 60) { missAnimation = -1; }
            enemyMove = false;
        }
    }

    void draw() {
        if (missAnimation == -1) {
            if (inv == 0 || (int)(inv / 10) % 2 != 0) {
                pushMatrix();
                    translate(x, y);
                    fill(#BBBBBB);
                    rotate(roll);
                    rect(-PLAYER_SIZE / 2, -PLAYER_SIZE / 2, PLAYER_SIZE, PLAYER_SIZE);
                    if (KeyState.get(SHIFT) != 0) {
                        fill(#333333);
                        ellipse(0, 0, PLAYER_HITBOX_SIZE, PLAYER_HITBOX_SIZE);
                    }
                popMatrix();
            }
        } else {
            if (missAnimation < 30) {
                fill(#BBBBBB);
                pushMatrix();
                    translate(x - missAnimation * 15, y - missAnimation * 15 + missAnimation * missAnimation);
                    rotate(roll);
                    rect(-PLAYER_SIZE / 4, -PLAYER_SIZE / 4, PLAYER_SIZE / 2, PLAYER_SIZE / 2);
                popMatrix();
                pushMatrix();
                    translate(x + missAnimation * 15, y - missAnimation * 15 + missAnimation * missAnimation);
                    rotate(roll);
                    rect(-PLAYER_SIZE / 4, -PLAYER_SIZE / 4, PLAYER_SIZE / 2, PLAYER_SIZE / 2);
                popMatrix();
                pushMatrix();
                    translate(x + missAnimation * 15, y + missAnimation * 15 + missAnimation * missAnimation);
                    rotate(roll);
                    rect(-PLAYER_SIZE / 4, -PLAYER_SIZE / 4, PLAYER_SIZE / 2, PLAYER_SIZE / 2);
                popMatrix();
                pushMatrix();
                    translate(x - missAnimation * 15, y + missAnimation * 15 + missAnimation * missAnimation);
                    rotate(roll);
                    rect(-PLAYER_SIZE / 4, -PLAYER_SIZE / 4, PLAYER_SIZE / 2, PLAYER_SIZE / 2);
                popMatrix();
            } else {
                if (missAnimation == 30) {
                    missAnimationEaseX = new Easing(EASE_OUT_CUBIC, width / 2, x - width / 2, 30);
                    missAnimationEaseY = new Easing(EASE_OUT_CUBIC, height, y - height, 30);
                }
                missAnimationEaseX.update();
                missAnimationEaseY.update();
                pushMatrix();
                    translate(missAnimationEaseX.get(), missAnimationEaseY.get());
                    fill(#BBBBBB);
                    rotate(roll);
                    rect(-PLAYER_SIZE / 2, -PLAYER_SIZE / 2, PLAYER_SIZE, PLAYER_SIZE);
                popMatrix();
            }
        }
        if (bombTime != -1) {
            stroke(#999999);
            noFill();
            ellipse(bombX, bombY, bombTime * PLAYER_BOMB_SPEED * 2, bombTime * PLAYER_BOMB_SPEED * 2);
            noStroke();
        }
    }

    void drawData() {
        fill(#f6d4d8);
        rect(0, height - PLAYER_DATA_HEIGHT, width, PLAYER_DATA_HEIGHT);
        fill(#000000);
        textFont(small, 30);
        text("Life", 70, height - 95);
        text("Bomb", 70, height - 55);
        fill(#BBBBBB);
        for (int i = 0; i < life; i++) {
            pushMatrix();
                translate(150 + PLAYER_SIZE * 1.2 * i, height - 95);
                rotate(-0.2);
                rect(-PLAYER_SIZE / 2, -PLAYER_SIZE / 2, PLAYER_SIZE, PLAYER_SIZE);
            popMatrix();
        }
        for (int i = 0; i <= bomb - 1; i++) {
            pushMatrix();
                translate(150 + PLAYER_SIZE * 1.2 * i, height - 55);
                rotate(-0.2);
                rect(-PLAYER_SIZE / 2, -PLAYER_SIZE / 2, PLAYER_SIZE, PLAYER_SIZE);
            popMatrix();
        }
        fill(#FFFFFF);
        rect(40, height - 30, width - 100, 20);
        fill(#BBBBBB);
        rect(40, height - 30, (width - 100) * (bomb % 1), 20);
    }
}