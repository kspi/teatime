public class TeaTime.Clock : GLib.Object {
    private GLib.Timer timer = new GLib.Timer();
    private int period;

    public signal void update();
    public signal void finish();
    
    public Clock(int period) {
        this.period = period;
    }

    public void start() {
        this.timer.start();
        this.update();
        GLib.Timeout.add(100, this.tick);
    }

    private bool tick() {
        if (this.finished()) {
            this.finish();
            return false;
        } else {
            this.update();
            return true;
        }
    }

    public int time_left() {
        return this.period - (int)this.timer.elapsed();
    }

    public bool finished() {
        return this.time_left() <= 0;
    }
    
}
