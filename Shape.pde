// x,yの位置に半径size,色col,角度roll,角の数numの正多角形を描画する
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

// x,yの位置に半径size,色colの円を描画する
public void circle(float x, float y, float size, color col) {
    fill(col);
    ellipse(x, y, size, size);
}