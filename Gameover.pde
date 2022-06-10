// ゲームオーバー画面を描画する
public void GameOver() {
    fill(0);
    textFont(title, 96);
    text("GameOver", width / 2, height / 2 - 200);
    textFont(small, 30);
    text("Press Enter to return title", width / 2, height / 2 + 200);
    text("Press Ctrl to continue", width / 2, height / 2 + 240);
    if (KeyState.get(ENTER) == 1) {
        scene = "title";
    }
    if (KeyState.get((int)CONTROL) == 1) {
        player.doContinue();
        scene = "play";
    }
}