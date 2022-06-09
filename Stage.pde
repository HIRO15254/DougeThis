public class Stage {
    protected int time = -180;
    protected boolean bonus;
    protected Easing ease;
    protected float oldBonusEase;
    protected Easing bonusEase;
    protected int stageLength;
    protected String stageName;
    protected String stageTitle;

    Stage() {
        time = -180;
        ease = new Easing(EASE_OUT_EXPO, -200, 520, 80);
        bonus = true;
    }

    void loseBonus() {
        bonus = false;
    }

    boolean update() {
        time++;
        if (time < 0) {
            ease.update();
            if (time == -100) {
                ease = new Easing(EASE_IN_CUBIC, 320, 520, 80);
            }
        }
        if (time >= stageLength) {
            if (time == stageLength) {
                enemyManager.reset();
                ease = new Easing(EASE_OUT_EXPO, -200, 520, 80);
                if (bonus) { bonusEase = new Easing(EASE_OUT_CUBIC, 0, 0.40 - level * 0.05, 80); }
            } if (time == stageLength + 80) {
                ease = new Easing(EASE_IN_EXPO, 320, 520, 80);
            }
            ease.update();
            if (bonus) {
                oldBonusEase = bonusEase.get();
                bonusEase.update();
                player.bomb += bonusEase.get() - oldBonusEase;
            }
        }
        return time >= 0 && time <= stageLength;
    }

    void draw() {
        if (time < 0) {
            textFont(small, 30);
            fill(0);
            text(stageName, ease.get(), 360);
            textFont(main, 48);
            text(stageTitle, 640 - ease.get(), 420);
            playerMove = false;
        } else if (time < stageLength) {
            fill(0);
            textFont(small, 30);
            text("progress: " + str((float)(time * 1000 / stageLength) / 10) + "%", 500, 820);
            playerMove = true;
        } else {
            textFont(small, 30);
            fill(0);
            text(stageName, ease.get(), 360);
            textFont(main, 48);
            text("Clear", 640 - ease.get(), 420);
            if (bonus) {
                textFont(small, 30);
                text("Bonus bomb+" + str(40 - level * 5) + "%", 640 - ease.get(), 460);
            }
            playerMove = false;
        }
    }
}

public class Stage1_1 extends Stage {
    Stage1_1() {
        stageLength = 1060;
        stageName = "Stage1 Phase1";
        stageTitle = "Firefrower";
    }

    boolean update() {
        boolean ret = super.update();
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
        if (time >= stageLength + 180) {
            nowStage = new Stage1_2();
        }
        return ret;
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

    boolean update() {
        boolean ret = super.update();
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
        return ret;
    }
}