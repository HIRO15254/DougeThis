public void Pause() {
    fill(0);
    textFont(title, 96);
    text("Pause", width / 2, height / 2 - 200);
    textFont(small, 30);
    text("Press Ctrl to Title", width / 2, height / 2 + 200);
    text("Press Enter to return game", width / 2, height / 2 + 240);
    if (KeyState.get((int)CONTROL) == 1) {
        scene = "title";
    }
    if (KeyState.get(ENTER) == 1) {
        scene = "play";
    }
}