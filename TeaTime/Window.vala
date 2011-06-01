public class TeaTime.Window : Gtk.Window {
    private Gtk.Table table = new Gtk.Table(3, 4, false);
    
    private Gtk.Label colon_label = new Gtk.Label(":");

    private Gtk.Label min_label = new Gtk.Label(null);
    private Gtk.Button min_inc_button = new Gtk.Button();
    private Gtk.Arrow min_inc_arrow = new Gtk.Arrow(Gtk.ArrowType.UP,
                                                    Gtk.ShadowType.NONE);
    private Gtk.Button min_dec_button = new Gtk.Button();
    private Gtk.Arrow min_dec_arrow = new Gtk.Arrow(Gtk.ArrowType.DOWN,
                                                    Gtk.ShadowType.NONE);
    
    private Gtk.Label sec_label = new Gtk.Label(null);
    private Gtk.Button sec_inc_button = new Gtk.Button();
    private Gtk.Arrow sec_inc_arrow = new Gtk.Arrow(Gtk.ArrowType.UP,
                                                    Gtk.ShadowType.NONE);
    private Gtk.Button sec_dec_button = new Gtk.Button();
    private Gtk.Arrow sec_dec_arrow = new Gtk.Arrow(Gtk.ArrowType.DOWN,
                                                    Gtk.ShadowType.NONE);
    
    private Gtk.Button go_button = new Gtk.Button.with_label("Go!");

    private TeaTime.Clock clock;
    private int period;
    private bool started = false;
    
    public Window(int m, int s) {
        period = m * 60 + s;
        
        title = "Tea Time";
        border_width = 15;
        resizable = false;
        destroy.connect(Gtk.main_quit);
        key_press_event.connect(key_press);
        setup_style();
        add(table);

        const Gtk.AttachOptions attach_opts = Gtk.AttachOptions.SHRINK;
        
        table.attach(min_inc_button, 0, 1, 0, 1, attach_opts, attach_opts, 0, 0);
        min_inc_button.add(min_inc_arrow);
        table.attach(sec_inc_button, 2, 3, 0, 1, attach_opts, attach_opts, 0, 0);
        sec_inc_button.add(sec_inc_arrow);

        table.attach(min_label,   0, 1, 1, 2, attach_opts, attach_opts, 0, 2);
        table.attach(colon_label, 1, 2, 1, 2, attach_opts, attach_opts, 0, 0);
        table.attach(sec_label,   2, 3, 1, 2, attach_opts, attach_opts, 0, 2);
        table.attach(go_button,   3, 4, 1, 2, attach_opts, attach_opts, 0, 0);
        table.set_col_spacing(2, 20);

        table.attach(min_dec_button, 0, 1, 2, 3, attach_opts, attach_opts, 0, 0);
        min_dec_button.add(min_dec_arrow);
        table.attach(sec_dec_button, 2, 3, 2, 3, attach_opts, attach_opts, 0, 0);
        sec_dec_button.add(sec_dec_arrow);


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

    private int time() {
        return started ? clock.time_left() : period;
    }
    
    public int minutes() {
        return time() / 60;
    }
    
    public int seconds() {
        return time() % 60;
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
        // Setup CSS style
        const string style = """
.background {
    background-image: -gtk-gradient(linear,
                                    0 0, 0 1,
                                    from(@bg_color),
                                    to(lighter(@bg_color)));
}

GtkTable GtkLabel {
    font: Sans 40;
}

GtkTable .button * {
    font: Sans 20;
}
""";

        var css_provider = new Gtk.CssProvider();
        try {
            css_provider.load_from_data(style, style.length);
        } catch (Error e) {
            error("Bad CSS.");
        }

        var context = get_style_context();
        context.add_provider_for_screen(Gdk.Screen.get_default(),
                                        css_provider,
                                        600);

        // Set arrow button behavior
        Gtk.Button[] arrows = { min_inc_button, min_dec_button,
                                sec_inc_button, sec_dec_button };
        foreach (var b in arrows) {
            b.set_relief(Gtk.ReliefStyle.NONE);
            b.can_focus = false;
        }
    }

    private void update() {
        min_label.set_label("%d".printf(minutes()));
        sec_label.set_label("%02d".printf(seconds()));
    }

    private void finish() {
        update();
        present();
        var dialog = new Gtk.MessageDialog(this,
                                           0,
                                           Gtk.MessageType.INFO,
                                           Gtk.ButtonsType.CLOSE,
                                           "Tea is ready!");
        dialog.run();
        Gtk.main_quit();
    }
}
