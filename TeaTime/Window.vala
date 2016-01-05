public class TeaTime.Window : Gtk.Window {
    private Gtk.Grid grid = new Gtk.Grid();
    
    private Gtk.Label colon_label = new Gtk.Label(":");

    private const Gtk.IconSize ICON_SIZE = Gtk.IconSize.LARGE_TOOLBAR;

    private Gtk.Label min_label = new Gtk.Label(null);
    private Gtk.Button min_inc_button = new Gtk.Button();
    private Gtk.Image min_inc_arrow = new Gtk.Image.from_icon_name("pan-up-symbolic", ICON_SIZE);
    private Gtk.Button min_dec_button = new Gtk.Button();
    private Gtk.Image min_dec_arrow = new Gtk.Image.from_icon_name("pan-down-symbolic", ICON_SIZE);
    
    private Gtk.Label sec_label = new Gtk.Label(null);
    private Gtk.Button sec_inc_button = new Gtk.Button();
    private Gtk.Image sec_inc_arrow = new Gtk.Image.from_icon_name("pan-up-symbolic", ICON_SIZE);
    private Gtk.Button sec_dec_button = new Gtk.Button();
    private Gtk.Image sec_dec_arrow = new Gtk.Image.from_icon_name("pan-down-symbolic", ICON_SIZE);
    
    private Gtk.Button start_button = new Gtk.Button.with_label("Start");

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
        add(grid);

        grid.attach(min_inc_button, 0, 0, 1, 1);
        min_inc_button.add(min_inc_arrow);
        min_inc_button.halign = Gtk.Align.CENTER;
        grid.attach(sec_inc_button, 2, 0, 1, 1);
        sec_inc_button.add(sec_inc_arrow);
        sec_inc_button.halign = Gtk.Align.CENTER;

        grid.attach(min_label,   0, 1, 1, 1); //, attach_opts, attach_opts, 0, 2);
        grid.attach(colon_label, 1, 1, 1, 1); //, attach_opts, attach_opts, 0, 0);
        grid.attach(sec_label,   2, 1, 1, 1); //, attach_opts, attach_opts, 0, 2);
        grid.attach(start_button,   3, 1, 1, 1); //, attach_opts, attach_opts, 0, 0);
        start_button.halign = Gtk.Align.CENTER;
        start_button.margin_start = 20;

        grid.attach(min_dec_button, 0, 2, 1, 1); //, attach_opts, attach_opts, 0, 0);
        min_dec_button.add(min_dec_arrow);
        min_dec_button.halign = Gtk.Align.CENTER;
        grid.attach(sec_dec_button, 2, 2, 1, 1); //, attach_opts, attach_opts, 0, 0);
        sec_dec_button.add(sec_dec_arrow);
        sec_dec_button.halign = Gtk.Align.CENTER;


        min_inc_button.clicked.connect(() => modify_minutes(1));
        min_dec_button.clicked.connect(() => modify_minutes(-1));

        sec_inc_button.clicked.connect(() => modify_seconds(15));
        sec_dec_button.clicked.connect(() => modify_seconds(-15));

        start_button.clicked.connect(start);
        
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
            start_button.hide();
            min_inc_button.hide();
            min_dec_button.hide();
            sec_inc_button.hide();
            sec_dec_button.hide();
            border_width = 25;
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
GtkGrid GtkLabel {
    font: Sans 40;
}

GtkGrid .button * {
    font: Sans 16;
}
""";

        var css_provider = new Gtk.CssProvider();
        try {
            css_provider.load_from_data(style, style.length);
        } catch (Error e) {
            error("Bad CSS.");
        }

        Gtk.StyleContext.add_provider_for_screen(Gdk.Screen.get_default(),
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
