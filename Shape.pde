public void polygon(float x, float y, float size, color col, float roll, int num) {
    pushMatrix();
    translate(x, y);
    rotate(roll);
    fill(col);
    beginShape();
    for (int i = 0; i < num; i++) {
        vertex(size*cos(radians(360*i/num)), size*sin(radians(360*i/num)));
    }
    endShape(CLOSE);
    popMatrix();
}

public void circle(float x, float y, float size, color col) {
    fill(col);
    ellipse(x, y, size, size);
}