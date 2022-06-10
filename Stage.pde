// 使いやすさの観点から、全体の半分(入るのにor出るのに)
final int TITLE_ANIMATION_DURATION = 80;
final int TITLE_ANIMATION_BRANK = 20;
final int TITLE_X_SIZE = 200;
final int STAGE_NAME_Y = 360;
final int STAGE_TITLE_Y = 420;
final int STAGE_BONUS_Y = 460;
final int STAGE_PROGRESS_X = 500;
final int STAGE_PROGRESS_Y = 820;

// ステージの共通処理を記述した基底クラス
public class Stage {
    protected int stageLength;
    protected String stageName;
    protected String stageTitle;

    protected int time;
    private boolean bonus;
    private Easing titleEase;

    private float bonusAmount;
    private Easing bonusEase;
    private float oldBonusEaseValue;

    // インスタンスの作成
    Stage() {
        time = -(TITLE_ANIMATION_DURATION * 2 + TITLE_ANIMATION_BRANK);
        titleEase = new Easing(EASE_OUT_EXPO, -TITLE_X_SIZE, (int)(width / 2) + TITLE_X_SIZE, TITLE_ANIMATION_DURATION);
        bonus = true;
        bonusAmount = 40 - level * 5;
    }

    // ボーナスの喪失
    void loseBonus() {
        bonus = false;
    }

    // 各フレームの数値更新処理
    void update() {
        time++;
        if (time < 0) {
            titleEase.update();
            if (time == -(TITLE_ANIMATION_DURATION + TITLE_ANIMATION_BRANK)) { 
                titleEase = new Easing(EASE_IN_CUBIC, (int)(width / 2), (int)(width / 2) + TITLE_X_SIZE, TITLE_ANIMATION_DURATION); 
            }
        }
        if (time >= stageLength) {
            if (time == stageLength) {
                enemyManager.reset();
                titleEase = new Easing(EASE_OUT_EXPO, -TITLE_X_SIZE, (int)(width / 2) + TITLE_X_SIZE, TITLE_ANIMATION_DURATION);
                if (bonus) { bonusEase = new Easing(EASE_OUT_CUBIC, 0, bonusAmount / 100, TITLE_ANIMATION_DURATION); }
            } 
            if (time == stageLength + TITLE_ANIMATION_DURATION) {
                titleEase = new Easing(EASE_IN_EXPO, (int)(width / 2), (int)(width / 2) + TITLE_X_SIZE, TITLE_ANIMATION_DURATION);
            }
            titleEase.update();
            if (bonus) {
                oldBonusEaseValue = bonusEase.get();
                bonusEase.update();
                player.bomb += bonusEase.get() - oldBonusEaseValue;
            }
        }
        // TODO: グローバル変数の変更はあまりよくない
        playerMove = time >= 0 && time <= stageLength;
    }

    // 各フレームのステージ情報描画処理
    void draw() {
        // 最初のタイトル表示
        if (time < 0) {
            textFont(small, 30);
            fill(0);
            text(stageName, titleEase.get(), STAGE_NAME_Y);
            textFont(main, 48);
            text(stageTitle, width - titleEase.get(), STAGE_TITLE_Y);
        }
        // ステージ中のステージ進捗表示
        else if (time < stageLength) {
            String progress = str((float)(time * 1000 / stageLength) / 10);
            fill(0);
            textFont(small, 30);
            text("progress: " + progress + "%", STAGE_PROGRESS_X, STAGE_PROGRESS_Y);
        }
        // ステージ終了時の表示
        else {
            fill(0);
            textFont(small, 30);
            text(stageName, titleEase.get(), STAGE_NAME_Y);
            textFont(main, 48);
            text("Clear", width - titleEase.get(), STAGE_TITLE_Y);
            if (bonus) {
                textFont(small, 30);
                text("Bonus bomb+" + str(bonusAmount) + "%", width - titleEase.get(), STAGE_BONUS_Y);
            }
        }
    }
}

public class Stage1_1 extends Stage {
    Stage1_1() {
        stageLength = 1060;
        stageName = "Stage1 Phase1";
        stageTitle = "Firefrower";
    }

    void update() {
        super.update();
        switch (time) {
            case 1:
                enemyManager.add(new Enemy1(width / 2, -50, 180, 100, false, #6bbed5));
                enemyManager.add(new Enemy1(width / 2, -50, 320, 100, false, #6bbed5));
                enemyManager.add(new Enemy1(width / 2, -50, 460, 100, false, #6bbed5));
                break;
            case 15:
                if (level >= 4) {
                    enemyManager.add(new Enemy1(width / 2, -50, 220, 200, false, #6bbed5));
                    enemyManager.add(new Enemy1(width / 2, -50, 420, 200, false, #6bbed5));
                }
                break;
            case 30:
                if (level >= 2) {
                    enemyManager.add(new Enemy1(width / 2, -50, 80, 150, false, #6bbed5));
                    enemyManager.add(new Enemy1(width / 2, -50, 540, 150, false, #6bbed5));
                }
                break;
            case 120:
            case 260:
                enemyManager.add(new Enemy1(120, -50, 120, 150, false, #64c99b));
                break;
            case 130:
            case 250:
                enemyManager.add(new Enemy1(200, -50, 200, 150, false, #64c99b));
                break;
            case 140:
            case 240:
                enemyManager.add(new Enemy1(280, -50, 280, 150, false, #64c99b));
                break;
            case 150:
            case 230:
                enemyManager.add(new Enemy1(360, -50, 360, 150, false, #64c99b));
                break;
            case 160:
            case 220:
                enemyManager.add(new Enemy1(420, -50, 420, 150, false, #64c99b));
                break;
            case 170:
            case 210:
                enemyManager.add(new Enemy1(500, -50, 500, 150, false, #64c99b));
                break;
            case 360:
                enemyManager.add(new Enemy2(320, -50, 320, 150, false, #eda184));
                break;
            case 740:
                enemyManager.add(new Enemy1(280, -50, 280, 150, true, #6eb7db));
                if (level == 4) {
                    enemyManager.add(new Enemy1(280, -50, 200, 150, true, #6eb7db));
                }
                break;
            case 750:
                enemyManager.add(new Enemy3(320, -50, 100, 100, #e38692));
                enemyManager.add(new Enemy3(320, -50, 540, 100, #e38692));
                break;
            case 760:
                if (level >= 2) {
                    enemyManager.add(new Enemy1(280, -50, 280, 150, true, #6eb7db));
                }
                if (level == 4) {
                    enemyManager.add(new Enemy1(280, -50, 360, 150, true, #6eb7db));
                }
                break;
            case 770:
                if (level >= 4) {
                    enemyManager.add(new Enemy3(320, -50, 100, 100, #e38692));
                    enemyManager.add(new Enemy3(320, -50, 540, 100, #e38692));
                }
                break;
            case 780:
                enemyManager.add(new Enemy1(320, -50, 360, 150, true, #6eb7db));
                if (level == 4) {
                    enemyManager.add(new Enemy1(280, -50, 280, 150, true, #6eb7db));
                }
                break;
            case 790:
                enemyManager.add(new Enemy3(320, -50, 100, 100, #e38692));
                enemyManager.add(new Enemy3(320, -50, 540, 100, #e38692));
                break;
            case 800:
                if (level >= 2) {
                    enemyManager.add(new Enemy1(320, -50, 360, 150, true, #6eb7db));
                }
                if (level == 4) {
                    enemyManager.add(new Enemy1(280, -50, 440, 150, true, #6eb7db));
                }
                break;
            case 810:
                if (level >= 3) {
                    enemyManager.add(new Enemy3(320, -50, 100, 100, #e38692));
                    enemyManager.add(new Enemy3(320, -50, 540, 100, #e38692));
                }
                break;
            case 830:
                if (level >= 2) {
                    enemyManager.add(new Enemy3(320, -50, 100, 100, #e38692));
                    enemyManager.add(new Enemy3(320, -50, 540, 100, #e38692));
                }
                break;
            case 850:
                if (level >= 3) {
                    enemyManager.add(new Enemy3(320, -50, 100, 100, #e38692));
                    enemyManager.add(new Enemy3(320, -50, 540, 100, #e38692));
                }
                break;
            case 870:
                enemyManager.add(new Enemy3(320, -50, 100, 100, #e38692));
                enemyManager.add(new Enemy3(320, -50, 540, 100, #e38692));
                break;  
            default:
                break;
        }
        if (time == stageLength + TITLE_ANIMATION_DURATION * 2 + TITLE_ANIMATION_BRANK) {
            nowStage = new Stage1_2();
            println("asdasdasda");
        }
    }
}

public class Stage1_2 extends Stage {
    private int phase = -1;
    private int phaseCount = 0;
    Stage1_2() {
        stageLength = 1200;
        stageName = "Stage1 Phase2";
        stageTitle = "Sniper";
    }

    void update() {
        super.update();
        if (time == 0) { phase = 0; }
        if (0 <= time && time <= stageLength) {
            phaseCount++;
        }
        switch (phase) {
            case 0:
                if (phaseCount % 10 == 0) {
                    enemyManager.add(new Enemy3(320, -50, 600 - 80 * (phaseCount / 10), 50, #e38692));
                    if (level >= 2) {
                        enemyManager.add(new Enemy3(320, 890, 40 + 80 * (phaseCount / 10), 790, #e38692));
                    }
                    if (phaseCount == 60) {
                        phase++;
                        phaseCount = -60 + level * 10;
                    }
                }
                break;
            case 1:
                if (phaseCount >= 0 && phaseCount % 10 == 0) {
                    if (level >= 2 || int(phaseCount / 10) % 2 == 0) {
                        enemyManager.add(new Enemy3(-50, 420, 50, 50 + 80 * (phaseCount / 10), #e38692));
                    }
                    if (level >= 2 || int(phaseCount / 10) % 2 == 1) {
                        enemyManager.add(new Enemy3(690, 420, 590, 590 - 80 * (phaseCount / 10), #e38692));
                    }
                    if (phaseCount == 70) {
                        phase++;
                        phaseCount = -60 + level * 10;
                    }
                }
                break;
            case 2:
                if (phaseCount % 10 == 0) {
                    enemyManager.add(new Enemy3(320, -50, 600 - 80 * (phaseCount / 10), 50, #e38692));
                    if (level >= 2) {
                        enemyManager.add(new Enemy3(320, 890, 40 + 80 * (phaseCount / 10), 790, #e38692));
                    }
                    if (phaseCount == 60) {
                        phase++;
                        phaseCount = -60 + level * 10;
                    }
                }
                break;
            case 3:
                if (phaseCount >= 0 && phaseCount % 10 == 0) {
                    if (level >= 2 || int(phaseCount / 10) % 2 == 0) {
                        enemyManager.add(new Enemy3(-50, 420, 50, 50 + 80 * (phaseCount / 10), #e38692));
                    }
                    if (level >= 2 || int(phaseCount / 10) % 2 == 1) {
                        enemyManager.add(new Enemy3(690, 420, 590, 590 - 80 * (phaseCount / 10), #e38692));
                    }
                    if (phaseCount == 70) {
                        phase++;
                        phaseCount = -60 + level * 10;
                    }
                }
                break;
        }
    }
}