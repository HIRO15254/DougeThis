PFont title, main, small;
String scene = "title";
int level = 0;

// 起動時処理
void setup() {
    size(640, 960);
    textAlign(CENTER, CENTER);
    smooth();
    noStroke();
    title = loadFont("mgenplus-1mn-thin-96.vlw");
    main = loadFont("mgenplus-1mn-thin-48.vlw");
    small = loadFont("mgenplus-1mn-thin-30.vlw");
}

// 各フレームの描画処理
void draw() {
    background(255);
    switch (scene) {
        case "title":
            Title();
            break;
        case "play":
            Play();
            break;
        case "pause":
            Pause();
            break;
    }
    KeyState.update();
}
