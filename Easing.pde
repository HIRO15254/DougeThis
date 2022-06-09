public final int EASE_IN_SINE     = 0;
public final int EASE_OUT_SINE    = 1;
public final int EASE_INOUT_SINE  = 2;
public final int EASE_IN_QUAD     = 3;
public final int EASE_OUT_QUAD    = 4;
public final int EASE_INOUT_QUAD  = 5;
public final int EASE_IN_CUBIC    = 6;
public final int EASE_OUT_CUBIC   = 7;
public final int EASE_INOUT_CUBIC = 8;
public final int EASE_IN_QUART    = 9;
public final int EASE_OUT_QUART   = 10;
public final int EASE_INOUT_QUART = 11;
public final int EASE_IN_QUINT    = 12;
public final int EASE_OUT_QUINT   = 13;
public final int EASE_INOUT_QUINT = 14;
public final int EASE_IN_EXPO     = 15;
public final int EASE_OUT_EXPO    = 16;
public final int EASE_INOUT_EXPO  = 17;
public final int EASE_IN_CIRC     = 18;
public final int EASE_OUT_CIRC    = 19;
public final int EASE_INOUT_CIRC  = 20;
public final int EASE_IN_BACK     = 21;
public final int EASE_OUT_BACK    = 22;
public final int EASE_INOUT_BACK  = 23;
public final int EASE_LINEAR      = 24;

public class Easing {
    private int typ;
    private int d, now;
    private float b, c;

    Easing(int type, float beginning, float change, int duration) {
        typ = type;
        b = beginning;
        c = change;
        d = duration;
        now = 0;
    }

    public boolean update() {
        now += 1;
        return 0 <= now && now <= d;
    }

    public float get() {
        float p = max(min((float)now / d, 1), 0);
        float s = 1.70158f;
        switch (typ) {
            case EASE_IN_SINE:
                return -c * (float)Math.cos(p * (Math.PI / 2)) + c + b;
            case EASE_OUT_SINE:
                return c * (float)Math.sin(p * (Math.PI / 2)) + b;	
            case EASE_INOUT_SINE:
                return -c / 2 * ((float)Math.cos(Math.PI * p) - 1) + b;
            case EASE_IN_QUAD:
                return c * p * p + b;
            case EASE_OUT_QUAD:
                return -c * p * (p - 2) + b;
            case EASE_INOUT_QUAD:
                if ((p *= 2f) < 1) return c / 2 * p * p + b;
                return -c / 2 * ((--p) * (p - 2) - 1) + b;
            case EASE_IN_CUBIC:
                return c * p * p * p + b;
            case EASE_OUT_CUBIC:
                return c * ((p -= 1) * p * p + 1) + b;
            case EASE_INOUT_CUBIC:
                if ((p *= 2f) < 1) return c / 2 * p * p * p + b;
                return c / 2 * ((p -= 2) * p * p + 2) + b;
            case EASE_IN_QUART:
                return c * p * p * p * p + b;
            case EASE_OUT_QUART:
                return -c * ((p -= 1) * p * p * p - 1) + b;
            case EASE_INOUT_QUART:
                if ((p *= 2f) < 1) return c / 2 * p * p * p * p + b;
                return -c / 2 * ((p -= 2) * p * p * p - 2) + b;
            case EASE_IN_EXPO:
                return (p == 0) ? b : c * (float)pow(2, 10 * (p - 1)) + b;
            case EASE_OUT_EXPO:
                return (p == 1) ? b + c : c * (-(float)pow(2, -10 * p) + 1) + b;
            case EASE_INOUT_EXPO:
                if (p == 0) return b;
                if (p == 1) return b + c;
                if ((p *= 2f) < 1) return c / 2 * (float)Math.pow(2, 10 * (p - 1)) + b;
                return c/2 * (-(float)Math.pow(2, -10 * --p) + 2) + b;
            case EASE_IN_CIRC:
                return -c * ((float)Math.sqrt(1 - p * p) - 1) + b;
            case EASE_OUT_CIRC:
                return c * (float)Math.sqrt(1 - (p -= 1) * p) + b;
            case EASE_INOUT_CIRC:
                if ((p *= 2f) < 1) return -c / 2 * ((float)Math.sqrt(1 - p * p) - 1) + b;
		        return c / 2 * ((float)Math.sqrt(1 - (p -= 2) * p) + 1) + b;
            case EASE_IN_BACK:
                return c * p * p * ((s + 1) * p - s) + b;
            case EASE_OUT_BACK:
                return c * ((p -= 1) * p* ((s + 1) * p + s) + 1) + b;
            case EASE_INOUT_BACK:
                if ((p *= 2f) < 1) return c / 2 * (p * p * (((s *= (1.525f)) + 1) * p - s)) + b;
                return c / 2 * ((p -= 2) * p * (((s *= (1.525f)) + 1) * p + s) + 2) + b;
            case EASE_LINEAR:
                return c * p + b;
            default :
                return 0;
        }
    }
}
