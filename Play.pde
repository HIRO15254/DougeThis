public Player player;
public EnemyManager enemyManager;
public Stage nowStage;
int stage = 1;
int phaze = 1;
int time = 0;
boolean playerMove;
boolean enemyMove;

void InitializePlay() {
    player = new Player(320, 580);
    enemyManager = new EnemyManager();
    nowStage = new Stage1_2();
    playerMove = true;
    enemyMove = true;
}

public void Play() {
    if (playerMove) { player.update(nowStage); }
    if (enemyMove) {
        nowStage.update();
        enemyManager.update(player.x, player.y);
    }
    player.draw();
    enemyManager.draw();
    player.drawData();
    nowStage.draw();
    time++;
    if (KeyState.get(CONTROL) == 1) {
        scene = "pause";
    }
}
