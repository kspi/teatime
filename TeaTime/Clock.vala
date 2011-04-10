public class TeaTime.Clock : GLib.Object {
    private GLib.Timer timer = new GLib.Timer();
    private int period;

    public signal void update();
    public signal void finish();
    
    public Clock(int period) {
        this.period = period;
    }

    public void start() {
        timer.start();
        update();
        GLib.Timeout.add(100, tick);
    }

    private bool tick() {
        if (finished()) {
            finish();
            return false;
        } else {
            update();
            return true;
        }
    }

    public int time_left() {
        return period - (int)timer.elapsed();
    }

    public bool finished() {
        return time_left() <= 0;
    }
}
