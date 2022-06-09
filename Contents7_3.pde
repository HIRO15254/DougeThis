PFont title, main, small;
String scene = "title";
int level = 0;

final String[] LEVELS = {"basic", "advanced", "expart", "master", "lunatic"};
final color[] LEVEL_COLORS = {#5ec84e, #f3c759, #da6272, #9d73bb, #717171};

void setup() {
    size(640, 960);
    textAlign(CENTER, CENTER);
    smooth();
    noStroke();
    title = loadFont("mgenplus-1mn-thin-96.vlw");
    main = loadFont("mgenplus-1mn-thin-48.vlw");
    small = loadFont("mgenplus-1mn-thin-30.vlw");
}

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
