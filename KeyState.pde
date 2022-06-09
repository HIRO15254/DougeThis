public static class KeyState {
    private static int[] states = new int[256]; 

    private KeyState() {}

    public static int get(int code) {
        return states[code];
    }

    public static void put(int code, int state) {
        states[code] = state;
    }

    public static void update() {
        for (int i = 0; i < 256; i++) {
            if (states[i] != 0) {
                states[i]++;
            }
        }
    }
}

void keyPressed() {
    if (key == CODED) {
        KeyState.put(keyCode, 1);
    } else {
        KeyState.put((int)key, 1);
    }
}

void keyReleased() {
    if (key == CODED) {
        KeyState.put(keyCode, 0);
    } else {
        KeyState.put((int)key, 0);
    }
}