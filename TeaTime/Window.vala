public class TeaTime.Window : Gtk.Window {
    private GLib.Timer timer = new GLib.Timer();
    private Gtk.Label label = new Gtk.Label(null);
    private int period_length;
    
    public Window(int period_length) {
        this.period_length = period_length;

        this.title = "Tea Timer";
        this.border_width = 20;
        this.set_keep_above(true);
        this.destroy.connect(Gtk.main_quit);
        this.add(this.label);

        GLib.Timeout.add(500, this.update);
        this.start();
        this.update();
    }

    private bool update() {
        if (this.tea_ready()) {
            this.finish();
            return false;
        } else {
            this.label.set_markup(this.format_time());       
            return true;        // Continue running timer.
        }
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
        var t = this.seconds_left();
        var m = t / 60;
        var s = t % 60;
        return "<span font='Monospace 50'>%u:%02u</span>".printf(m, s);
    }
}
