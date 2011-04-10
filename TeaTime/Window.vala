public class TeaTime.Window : Gtk.Window {
    private Gtk.HBox hbox = new Gtk.HBox(false, 10);
    
    private Gtk.Label colon_label = new Gtk.Label(":");

    private Gtk.VBox min_box = new Gtk.VBox(false, 0);
    private Gtk.Label min_label = new Gtk.Label(null);
    private Gtk.Button min_inc_button = new Gtk.Button.with_label("▲");
    private Gtk.Button min_dec_button = new Gtk.Button.with_label("▼");
    
    private Gtk.VBox sec_box = new Gtk.VBox(false, 0);
    private Gtk.Label sec_label = new Gtk.Label(null);
    private Gtk.Button sec_inc_button = new Gtk.Button.with_label("▲");
    private Gtk.Button sec_dec_button = new Gtk.Button.with_label("▼");
    
    private Gtk.Button go_button = new Gtk.Button.with_label("Go!");
    
    private TeaTime.Clock clock;
    private int period;
    private bool started = false;
    
    public Window(int m, int s) {
        period = m * 60 + s;
        
        title = "Tea Time";
        border_width = 20;
        set_keep_above(true);
        destroy.connect(Gtk.main_quit);
        key_press_event.connect(key_press);
        setup_style();
        add(hbox);

        hbox.pack_start(min_box);
        hbox.pack_start(colon_label);
        hbox.pack_start(sec_box);
        hbox.pack_start(go_button);

        min_box.pack_start(min_inc_button);
        min_box.pack_start(min_label);
        min_box.pack_start(min_dec_button);

        min_inc_button.clicked.connect(() => modify_minutes(1));
        min_dec_button.clicked.connect(() => modify_minutes(-1));

        sec_box.pack_start(sec_inc_button);
        sec_box.pack_start(sec_label);
        sec_box.pack_start(sec_dec_button);

        sec_inc_button.clicked.connect(() => modify_seconds(15));
        sec_dec_button.clicked.connect(() => modify_seconds(-15));

        go_button.clicked.connect(start);
        go_button.is_focus = true;
        go_button.leave.connect(() => go_button.is_focus = true);
        
        update();
    }

    private static uint K_LEFT = Gdk.keyval_from_name("Left");
    private static uint K_RIGHT = Gdk.keyval_from_name("Right");
    private static uint K_UP = Gdk.keyval_from_name("Up");
    private static uint K_DOWN = Gdk.keyval_from_name("Down");
    private static uint K_RETURN = Gdk.keyval_from_name("Return");
    private static uint K_SPACE = Gdk.keyval_from_name("Space");
    
    public bool key_press(Gdk.EventKey e) {
        if (e.keyval == K_LEFT) {
            modify_seconds(-15);
            return true;
        } else if (e.keyval == K_RIGHT) {
            modify_seconds(15);
            return true;
        } else if (e.keyval == K_UP) {
            modify_minutes(1);
            return true;
        } else if (e.keyval == K_DOWN) {
            modify_minutes(-1);
            return true;
        } else if (e.keyval == K_RETURN || e.keyval == K_SPACE) {
            start();
            return true;
        } else {
            return false;
        }
    }

    private void modify_minutes(int diff) {
        modify_seconds(diff * 60);
    }

    private void modify_seconds(int diff) {
        if (diff.abs() != 1 && period == 1) period = 0;
        period += diff;
        if (period <= 0) period = 1;
        update();
    }

    public int minutes() {
        var t = started ? clock.time_left() : period;
        return t / 60;
    }
    
    public int seconds() {
        var t = started ? clock.time_left() : period;
        return t % 60;
    }

    public void start() {
        if (!started) {
            go_button.hide();
            min_inc_button.hide();
            min_dec_button.hide();
            sec_inc_button.hide();
            sec_dec_button.hide();
            resize(1, 1);
            
            started = true;
            clock = new TeaTime.Clock(period);
            clock.update.connect(update);
            clock.finish.connect(finish);
            clock.start();
        }
    }

    private void setup_style() {
        Gdk.Color bg;
        Gdk.Color.parse("black", out bg);

        Gdk.Color button_bg;
        Gdk.Color.parse("gray40", out button_bg);

        Gdk.Color dark_fg;
        Gdk.Color.parse("gray60", out dark_fg);
        
        Gdk.Color fg;
        Gdk.Color.parse("gray90", out fg);

        modify_bg(Gtk.StateType.NORMAL, bg);
        Gtk.Widget[] ws = { min_label, colon_label, sec_label };
        foreach (var w in ws) {
            w.modify_fg(Gtk.StateType.NORMAL, fg);
            w.modify_font(Pango.FontDescription.from_string("Sans 36"));
        }
        colon_label.modify_fg(Gtk.StateType.NORMAL, dark_fg);

        Gtk.Button[] bs = { go_button,
                            min_inc_button, min_dec_button,
                            sec_inc_button, sec_dec_button };
        foreach (var b in bs) {
            b.relief = Gtk.ReliefStyle.NONE;
            b.modify_bg(Gtk.StateType.PRELIGHT, bg);
            b.child.modify_fg(Gtk.StateType.NORMAL, dark_fg);
            b.child.modify_fg(Gtk.StateType.PRELIGHT, fg);
            b.child.modify_font(Pango.FontDescription.from_string("Sans 26"));
        }
}

    private void update() {
        min_label.set_label("%d".printf(minutes()));
        sec_label.set_label("%02d".printf(seconds()));
    }

    private void finish() {
        hide();
        var dialog = new Gtk.MessageDialog(this,
                                           0,
                                           Gtk.MessageType.INFO,
                                           Gtk.ButtonsType.CLOSE,
                                           "Tea is ready!");
        dialog.run();
        Gtk.main_quit();
    }
}
