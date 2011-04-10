public class TeaTime.Clock : GLib.Object {
    private GLib.Timer timer = new GLib.Timer();
	private int period;

	public signal void update();
	public signal void finish();
	
	public Clock(int minutes, int seconds) {
		this.period = minutes * 60 + seconds;
	}

    public void start() {
        this.timer.start();
		this.update();
        GLib.Timeout.add(1000, this.tick);
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

    private int time_left() {
        return this.period - (int)this.timer.elapsed();
    }

	public int minutes() {
		return this.time_left() / 60;
	}

	public int seconds() {
		return this.time_left() % 60;
	}

    public bool finished() {
        return this.time_left() <= 0;
    }
    
}
