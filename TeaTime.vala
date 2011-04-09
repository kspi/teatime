public class TeaTime : Gtk.Window {
	private GLib.Timer timer = new GLib.Timer();
	private Gtk.Label label = new Gtk.Label(null);
	private int period_length;
	
	public TeaTime(int period_length) {
		this.period_length = period_length;

		this.title = "Tea Timer";
		this.border_width = 20;
		this.hide.connect(Gtk.main_quit);
		this.add(label);

		GLib.Timeout.add_seconds(1, this.every_second);
		this.every_second();
	}

	private bool every_second() {
		label.set_markup(this.format_time());		
		return !this.tea_ready();
	}
	
	public void start() {
		this.timer.start();
	}

	public int seconds_left() {
		return this.period_length - (int)this.timer.elapsed();
	}

	public bool tea_ready() {
		return this.seconds_left() <= 0;
	}
	
	public string format_time() {
		if (this.tea_ready()) {
			return "<span font='Sans 30'>Tea is ready!</span>";
		} else {
			var t = this.seconds_left();
			var m = t / 60;
			var s = t % 60;
			return "<span font='Monospace 50'>%u:%02u</span>".printf(m, s);
		}
	}

	static void usage(string program) {
		GLib.stdout.printf("Usage: %s [ minutes | minutes:seconds ]\n", program);
	}
	
	static int main(string[] args) {
		Gtk.init(ref args);

		var minutes = 5;
		var seconds = 0;
		
		if (args.length > 1) {
			if ((args[1] == "--help") || (args[1] == "-h")) {
				TeaTime.usage(args[0]);
				return 0;
			} else {
				var str = args[1];
				var colon_index = str.index_of_char(':');
				if (colon_index > 0) {
					str.scanf("%d:%d", out minutes, out seconds);
				} else {
					str.scanf("%d", out minutes);
				}
			}
		}
		
		var teatime = new TeaTime(minutes * 60 + seconds);
		teatime.show_all();

		Gtk.main();

		return 0;
	}
}