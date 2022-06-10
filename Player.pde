final int PLAYER_SIZE = 30;
final int PLAYER_SPEED = 8;
final float PLAYER_ROLL_SPEED = 0.01;
final int PLAYER_HITBOX_SIZE = 4;
final int PLAYER_DATA_HEIGHT = 120;
final int PLAYER_BOMB_SPEED = 15;
final int PLAYER_BOMB_DURATION = 60;
final int PLAYER_BOMB_INVINCIBLE_DURATION = 120;
final int PLAYER_MISS_ANIMATION_DURATION = 60;
final int PLAYER_MISS_ANIMATION_SPEED = 7;
final float PLAYER_MISS_ANIMATION_GRAVITY = 0.5;
final int PLAYER_REBORN_ANIMATION_DURATION = 60;
final int PLAYER_REBORN_INVINCIBLE_DURATION = 60;
final float[] PLAYER_BOMB_PER_FRAME = {0.0007, 0.0005, 0.0004, 0.0003, 0.0002};

// プレイヤーの動きを管理するクラス
public class Player {
    float x, y, roll;
    float bomb = 2;
    float life = 2;
    float bombTime = -1;
    float bombX = 0;
    float bombY = 0;
    float invincible = 0;
    float missAnimation = -1;
    int continueCount = 0;
    Easing missAnimationEaseX;
    Easing missAnimationEaseY;

    Player(float xPos, float yPos) {
        x = xPos;
        y = yPos;
        roll = 0;
    }

    // 各フレームの数値の更新を行うクラス
    void update(Stage nowStage) {
        enemyMove = true;
        // TODO: グローバル変数の変更はよくない
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
            // 前にいるほどボムが早くたまる
            bomb += PLAYER_BOMB_PER_FRAME[level] * (max(min((float)(800 - y) / 800, 1), 0) + 1);
        }
        roll += PLAYER_ROLL_SPEED * speed;
        invincible = max(0, invincible - 1);
        // ボム
        if ((KeyState.get((int)'z') == 1 || KeyState.get((int)'Z') == 1) && bomb >= 1 && invincible == 0) {
            bomb = floor(bomb - 1);
            bombX = x;
            bombY = y;
            bombTime = 0;
            invincible = PLAYER_BOMB_DURATION;
            // TODO: グローバル変数の変更はよくない
            nowStage.loseBonus();
        }
        // 被弾
        if (invincible == 0 && enemyManager.hit(x, y)) {
            life--;
            bomb = 2;
            bombX = x;
            bombY = y;
            bombTime = 0;
            missAnimation = 0;
            invincible = PLAYER_MISS_ANIMATION_DURATION + PLAYER_REBORN_ANIMATION_DURATION + PLAYER_REBORN_INVINCIBLE_DURATION;
            nowStage.loseBonus();
        }
        // ボム中
        if (bombTime != -1) {
            bombTime += 1;
            if (bombTime == PLAYER_BOMB_DURATION) { bombTime = -1; }
            enemyManager.bomb(bombX, bombY, bombTime * PLAYER_BOMB_SPEED);
        }
        // ミス演出中
        if (missAnimation != -1) {
            missAnimation += 1;
            if (missAnimation == PLAYER_MISS_ANIMATION_DURATION + PLAYER_REBORN_ANIMATION_DURATION) { missAnimation = -1; }
            enemyMove = false;
        }
    }

    // 各フレームの自機関係描画処理
    void draw() {
        // ミス演出中でないときの自機描画
        if (missAnimation == -1) {
            if (invincible == 0 || (int)(invincible / 10) % 2 != 0) {
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
        }
        // ミス演出中の自機描画 
        else {
            // 砕ける段階
            if (missAnimation <= PLAYER_MISS_ANIMATION_DURATION) {
                int[] particle_speed_x = {1, 1, -1, -1};
                int[] particle_speed_y = {1, -1, 1, -1};
                fill(#BBBBBB);
                for (int i = 0; i < 4; i++) {
                    pushMatrix();
                        translate(
                            x + (missAnimation * PLAYER_MISS_ANIMATION_SPEED) * particle_speed_x[i],
                            y + (missAnimation * PLAYER_MISS_ANIMATION_SPEED) * particle_speed_y[i] + missAnimation * missAnimation * PLAYER_MISS_ANIMATION_GRAVITY
                        );
                        rotate(roll);
                        rect(-PLAYER_SIZE / 4, -PLAYER_SIZE / 4, PLAYER_SIZE / 2, PLAYER_SIZE / 2);
                    popMatrix();
                }
                if (missAnimation == PLAYER_MISS_ANIMATION_DURATION) {
                    if (life == -1) { scene = "gameover"; }
                    missAnimationEaseX = new Easing(EASE_OUT_CUBIC, width / 2, x - width / 2, PLAYER_REBORN_ANIMATION_DURATION);
                    missAnimationEaseY = new Easing(EASE_OUT_CUBIC, height, y - height, PLAYER_REBORN_ANIMATION_DURATION);
                }
            }
            // 元の位置まで戻る段階
            else {
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
        // ボムか被弾に関わる弾消しの演出
        if (bombTime != -1) {
            stroke(#999999);
            noFill();
            ellipse(bombX, bombY, bombTime * PLAYER_BOMB_SPEED * 2, bombTime * PLAYER_BOMB_SPEED * 2);
            noStroke();
        }
    }

    // 各フレームの画面下部情報の描画
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

    void doContinue() {
        life = 2;
        bomb = 2;
        continueCount++;
    }
}