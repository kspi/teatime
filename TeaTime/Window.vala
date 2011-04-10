public class TeaTime.Window : Gtk.Window {
    private Gtk.Table table = new Gtk.Table(3, 4, false);
    
    private Gtk.Label colon_label = new Gtk.Label(":");

    private Gtk.Label min_label = new Gtk.Label(null);
    private Gtk.Button min_inc_button = new Gtk.Button.with_label("▲");
    private Gtk.Button min_dec_button = new Gtk.Button.with_label("▼");
    
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
        border_width = 15;
        set_keep_above(true);
        destroy.connect(Gtk.main_quit);
        key_press_event.connect(key_press);
        setup_style();
        add(table);

        const Gtk.AttachOptions attach_opts = Gtk.AttachOptions.SHRINK;
        
        table.attach(min_inc_button, 0, 1, 0, 1, attach_opts, attach_opts, 0, 0);
        table.attach(sec_inc_button, 2, 3, 0, 1, attach_opts, attach_opts, 0, 0);

        table.attach(min_label,   0, 1, 1, 2, attach_opts, attach_opts, 0, 2);
        table.attach(colon_label, 1, 2, 1, 2, attach_opts, attach_opts, 0, 0);
        table.attach(sec_label,   2, 3, 1, 2, attach_opts, attach_opts, 0, 2);
        table.attach(go_button,   3, 4, 1, 2, attach_opts, attach_opts, 0, 0);
        table.set_col_spacing(2, 20);

        table.attach(min_dec_button, 0, 1, 2, 3, attach_opts, attach_opts, 0, 0);
        table.attach(sec_dec_button, 2, 3, 2, 3, attach_opts, attach_opts, 0, 0);


        min_inc_button.clicked.connect(() => modify_minutes(1));
        min_dec_button.clicked.connect(() => modify_minutes(-1));

        sec_inc_button.clicked.connect(() => modify_seconds(15));
        sec_dec_button.clicked.connect(() => modify_seconds(-15));

        go_button.clicked.connect(start);
        
        update();
    }

    public bool key_press(Gdk.EventKey e) {
        switch (Gdk.keyval_name(e.keyval)) {
        case "Left":
            modify_seconds(-15);
            return true;
        case "Right":
            modify_seconds(15);
            return true;
        case "Up":
            modify_minutes(1);
            return true;
        case "Down":
            modify_minutes(-1);
            return true;
        case "Return":
        case "space":
            start();
            return true;
        default:
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
            table.set_col_spacing(2, 0);
            border_width = 30;
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
            w.modify_font(Pango.FontDescription.from_string("Sans 40"));
        }
        colon_label.modify_fg(Gtk.StateType.NORMAL, dark_fg);

        Gtk.Button[] bs = { go_button,
                            min_inc_button, min_dec_button,
                            sec_inc_button, sec_dec_button };
        foreach (var b in bs) {
            b.can_focus = false;
            b.relief = Gtk.ReliefStyle.NONE;
            b.modify_bg(Gtk.StateType.PRELIGHT, bg);
            b.child.modify_fg(Gtk.StateType.NORMAL, dark_fg);
            b.child.modify_fg(Gtk.StateType.PRELIGHT, fg);
            b.child.modify_font(Pango.FontDescription.from_string("Sans 20"));
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
