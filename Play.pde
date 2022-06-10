public Player player;
public EnemyManager enemyManager;
public Stage nowStage;
boolean playerMove;
boolean enemyMove;

// プレイに関する変数を初期化する
void InitializePlay() {
    player = new Player(320, 580);
    enemyManager = new EnemyManager();
    nowStage = new Stage1_1();
    playerMove = true;
    enemyMove = true;
}

// プレイ画面を描画する
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
    if (KeyState.get(CONTROL) == 1) {
        scene = "pause";
    }
}
