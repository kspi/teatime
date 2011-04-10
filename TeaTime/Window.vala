public class TeaTime.Window : Gtk.Window {
    private Gtk.Label label = new Gtk.Label(null);
	private TeaTime.Clock clock;
    
    public Window(int minutes, int seconds) {
        this.title = "Tea Timer";
        this.border_width = 20;
        this.set_keep_above(true);
        this.destroy.connect(Gtk.main_quit);
        this.add(this.label);

		clock = new TeaTime.Clock(minutes, seconds);
		clock.update.connect(this.update);
		clock.finish.connect(this.finish);
		clock.start();
    }

    private void update() {
		this.label.set_markup(this.format_time());       
    }

    private void finish() {
        this.hide();
        var dialog = new Gtk.MessageDialog(this,
                                           0,
                                           Gtk.MessageType.INFO,
                                           Gtk.ButtonsType.CLOSE,
                                           "Tea is ready!");
        dialog.run();
        Gtk.main_quit();
    }
    
    public string format_time() {
        return "<span font='Monospace 50'>%u:%02u</span>"
		.printf(clock.minutes(),
				clock.seconds());
    }
}
