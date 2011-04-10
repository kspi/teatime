class TeaTime.Main : GLib.Object {
    static int main(string[] args) {
        Gtk.init(ref args);

        var context = new GLib.OptionContext("[MINUTES | MINUTES:SECONDS | :SECONDS] ");
        context.set_description("If time is not given on the commandline, ask" +
                                " interactively. Otherwise start countdown immediately.");
        try {
            context.parse(ref args);
        } catch (GLib.OptionError e) {
            // We don't care if we fail to parse an option.
        }

        int minutes = 5;
        int seconds = 0;
        var interactive = true;

        if (args.length > 1) {
            var str = args[1];

            var colon_index = str.index_of_char(':');
            if (colon_index > 0) {
                if (str.scanf("%u:%u", out minutes, out seconds) == 2) {
                    interactive = false;
                }
            } else if (colon_index == 0) {
                if (str.scanf(":%u", out seconds) == 1) {
                    minutes = 0;
                    interactive = false;
                }
            } else {            // no colon
                if (str.scanf("%u", out minutes) == 1) {
                    seconds = 0;
                    interactive = false;
                }
            }
        }

        if (minutes == 0 && seconds == 0) {
            seconds = 1;
        }
        
        var teatime = new TeaTime.Window(minutes, seconds);
        teatime.show_all();
        if (!interactive) teatime.start();

        Gtk.main();

        return 0;
    }
}