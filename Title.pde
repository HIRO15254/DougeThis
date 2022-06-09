public void Title() {
    fill(0);
    textFont(title, 96);
    text("Dodge This!", width / 2, height / 2 - 200);
    textFont(small, 30);
    text("made by HIRO", width / 2, height / 2 - 120);
    textFont(main, 48);
    int y = height / 2 + 100;
    for (int i = 0; i < LEVELS.length; i++) {
        fill(LEVEL_COLORS[i]);
        if (level == i) {
            textFont(title, 72);
            text(LEVELS[i], width / 2, y);
            y += 72;
            textFont(main, 48);
        } else {
            text(LEVELS[i], width / 2, y);
            y += 60;
        }
    }
    if (KeyState.get(DOWN) == 1) {
        if (level != LEVELS.length - 1) {
            level++;
        }
    } else if (KeyState.get(UP) == 1) {
        if (level != 0) {
            level--;
        }
    }

    if (KeyState.get(ENTER) == 1) {
        scene = "play";
        InitializePlay();
    }
}