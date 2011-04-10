class TeaTime.Main : GLib.Object {
	static void usage(string program) {
        GLib.stdout.printf("Usage: %s [ minutes | minutes:seconds ]\n", program);
    }
    
    static int main(string[] args) {
        Gtk.init(ref args);

        var minutes = 5;
        var seconds = 0;
        
        if (args.length > 1) {
            if ((args[1] == "--help") || (args[1] == "-h")) {
                usage(args[0]);
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
        
        var teatime = new TeaTime.Window(minutes * 60 + seconds);
        teatime.show_all();

        Gtk.main();

        return 0;
    }
}