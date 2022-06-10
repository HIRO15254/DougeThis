// ポーズ画面を描画する
public void Pause() {
    fill(0);
    textFont(title, 96);
    text("Pause", width / 2, height / 2 - 200);
    textFont(small, 30);
    text("Press Enter to go back to title", width / 2, height / 2 + 200);
    text("Press Ctrl to return game", width / 2, height / 2 + 240);
    if (KeyState.get(ENTER) == 1) {
        scene = "title";
    }
    if (KeyState.get((int)CONTROL) == 1) {
        scene = "play";
    }
}