VALAC := valac
VALAFLAGS := --pkg gtk+-2.0 --pkg glib-2.0 --pkg gdk-2.0 --pkg pango
SOURCES := $(wildcard */*.vala)

teatime: $(SOURCES)
	$(VALAC) $(VALAFLAGS) -o $@ $^

clean:
	rm -f teatime
