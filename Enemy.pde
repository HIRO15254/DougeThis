// 敵の管理をするクラス
// 敵を生成するときに1つだけ作ったこのクラスのインスタンスに登録する
// 敵すべてに関する処理などをまとめて行う他、画面外に出た弾を消したりする
class EnemyManager {
  private ArrayList<Enemy> enemies;

  EnemyManager() {
    enemies = new ArrayList<Enemy>();
  }

  public void add(Enemy enemy) {
    enemies.add(enemy);
  }

  public void update(float playerX, float playerY) {
    int i = 0;
    while (i < enemies.size()) {
      if(enemies.get(i).update(playerX, playerY)) {
        i++;
      } else {
        enemies.remove(i);
      }
    }
  }

  public void draw() {
    for (int i = 0; i < enemies.size(); i++) {
      enemies.get(i).draw();
    }
  }

  public void bomb(float bombX, float bombY, float bombSize) {
    int i = 0;
    while (i < enemies.size()) {
      if(!enemies.get(i).erase(bombX, bombY, bombSize)) {
        i++;
      } else {
        enemies.remove(i);
      }
    }
  }

  public boolean hit(float x, float y) {
    boolean ret = false;
    for (int i = 0; i < enemies.size(); i++) {
      ret = ret || enemies.get(i).collision(x, y);
    }
    return ret;
  }

  public void reset() {
    enemies = new ArrayList<Enemy>();
  }
}

// 敵を表す抽象クラス
// 前述の敵管理クラスに登録するにはこれを継承する必要がある
abstract public class Enemy {
    abstract public boolean update(float playerX, float playerY);
    abstract public void draw();
    abstract public boolean erase(float bombX, float bombY, float bombSize);
    abstract public boolean collision(float colX, float colY);
}

// 加減速しない普通の敵弾
class NormalBullet extends Enemy {
  private float x, y;
  private float size;
  private float direction;
  private float speed;
  private color col;

  NormalBullet(float _x, float _y, float _size, float _direction, float _speed, color _col) {
    x = _x;
    y = _y;
    direction = _direction;
    size = _size;
    speed = _speed;
    col = _col;
  }

  boolean update(float playerX, float playerY) {
    x += cos(direction) * speed;
    y += sin(direction) * speed;
    return 0 < x + size || x - size < width || 0 < y + size || y - size < height;
  }

  void draw() {
    circle(x, y, size, col);
  }

  boolean collision(float colX, float colY) {
    return mag(x - colX, y - colY) < size * 0.8;
  }

  boolean erase(float bombX, float bombY, float bombSize) {
    return mag(x - bombX, y - bombY) < size + bombSize;
  }
}

// 花火
class Enemy1 extends Enemy {
  private Easing xEase, yEase;
  private float x = 0;
  private float y = 0;
  private int life = 60;
  private boolean random;
  private color col;
  Enemy1(float _x, float _y, float _endX, float _endY, boolean _random, color _color) {
    xEase = new Easing(EASE_OUT_QUART, _x, _endX - _x, 60);
    yEase = new Easing(EASE_OUT_QUART, _y, _endY - _y, 60);
    random = _random;
    col = _color;
  }

  boolean update(float playerX, float playerY) {
    xEase.update();
    yEase.update();
    x = xEase.get();
    y = yEase.get();
    life -= 1;
    float rand = PI / 2;
    if (random) {
      rand = random(0, 2 * PI);
    }
    if (life == 0) {
      int bulCount = 12 + level * 3;
      for (int i = 0; i < bulCount; i++) {
        enemyManager.add(new NormalBullet(x, y, 15 + level * 2, PI * 2 / bulCount * i + rand, 5, col));
        if (level >= 3)
          enemyManager.add(new NormalBullet(x, y, 10 + level, PI * 2 / bulCount * i + rand, 3, col));
        if (level >= 1)
          enemyManager.add(new NormalBullet(x, y, 12 + level * 1.5, PI * 2 / bulCount * i + rand, 4, col));
      }
    }
    return life > 0;
  }

  void draw() {
    polygon(x, y, 20, col, life * 0.005, 6);
  }

  boolean collision(float colX, float colY) {
    return mag(x - colX, y - colY) < 15;
  }

  boolean erase(float bombX, float bombY, float bombSize) {
    return false;
  }
}

// 渦巻
class Enemy2 extends Enemy {
  private Easing xEase, yEase;
  private float x = 0;
  private float y = 0;
  private int life = 300;
  private float rollSpeed = 0.005;
  private float roll = 0;
  private boolean rev = true;
  private color col;

  Enemy2(float _x, float _y, float _endX, float _endY, boolean reverse, color _color) {
    xEase = new Easing(EASE_OUT_QUART, _x, _endX - _x, 60);
    yEase = new Easing(EASE_OUT_QUART, _y, _endY - _y, 60);
    rev = reverse;
    if (rev) { rollSpeed -= 1; }
    col = _color;
  }

  boolean update(float playerX, float playerY) {
    xEase.update();
    yEase.update();
    x = xEase.get();
    y = yEase.get();
    life -= 1;
    if (life < 240) {
      if (life % (16 - (int)(level * 2.5)) == 0) {
        int bulCount = 12 + level * 3;
        for (int i = 0; i < bulCount; i++) {
          enemyManager.add(new NormalBullet(x, y, 15 + level, PI * 2 / bulCount * i + roll, 5, col));
        }
      }
      if (rev) { rollSpeed -= 0.0002; }
      else { rollSpeed += 0.0002; }
    }
    roll += rollSpeed;
    return life > 0;
  }

  void draw() {
    polygon(x, y, 20, col, roll, 6);
  }

  boolean collision(float colX, float colY) {
    return mag(x - colX, y - colY) < 15;
  }

  boolean erase(float bombX, float bombY, float bombSize) {
    return false;
  }
}

// 爆発自機狙い
class Enemy3 extends Enemy {
  private Easing xEase, yEase;
  private float x = 0;
  private float y = 0;
  private int life = 60;
  private color col;

  Enemy3(float _x, float _y, float _endX, float _endY, color _color) {
    xEase = new Easing(EASE_OUT_QUART, _x, _endX - _x, 60);
    yEase = new Easing(EASE_OUT_QUART, _y, _endY - _y, 60);
    col = _color;
  }

  boolean update(float playerX, float playerY) {
    xEase.update();
    yEase.update();
    x = xEase.get();
    y = yEase.get();
    life -= 1;
    if (life == 0) {
      int bulCount = 5 + level * 2;
      float ang = atan2(playerY - y, playerX - x);
      for (int i = 0; i < bulCount; i++) {
        enemyManager.add(new NormalBullet(x, y, 10 + i * 2, ang + random(-PI * (2 + level) / 180, PI * (2 + level) / 180), 6 + 0.3 * (bulCount - i), col));
      }
    }
    return life > 0;
  }

  void draw() {
    polygon(x, y, 20, col, life * 0.005, 3);
  }

  boolean collision(float colX, float colY) {
    return mag(x - colX, y - colY) < 15;
  }

  boolean erase(float bombX, float bombY, float bombSize) {
    return false;
  }
}

// とどまるタイプの自機狙い
class Enemy4 extends Enemy {
  private Easing xEase, yEase;
  private float x = 0;
  private float y = 0;
  private int life;
  private color col;
  private int count;
  private float roll;

  Enemy4(float _x, float _y, float _endX, float _endY, int _life, color _color) {
    xEase = new Easing(EASE_OUT_QUART, _x, _endX - _x, 60);
    yEase = new Easing(EASE_OUT_QUART, _y, _endY - _y, 60);
    life = _life;
    col = _color;
  }

  boolean update(float playerX, float playerY) {
    xEase.update();
    yEase.update();
    x = xEase.get();
    y = yEase.get();
    count += 1;
    if (count > 60) {
      if (count % (14 - (int)(level * 1.5)) == 0) {
        float ang = atan2(playerY - y, playerX - x) + random(-1, 1) * (level * 0.5 + 1) / 180 * PI;
        enemyManager.add(new NormalBullet(x, y, 15 + level, ang, 5 + level, col));
      }
    }
    roll -= 0.005;
    return count <= life;
  }

  void draw() {
    polygon(x, y, 20, col, roll, 3);
  }

  boolean collision(float colX, float colY) {
    return mag(x - colX, y - colY) < 15;
  }

  boolean erase(float bombX, float bombY, float bombSize) {
    return false;
  }
}