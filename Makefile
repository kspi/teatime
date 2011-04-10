VALAC := valac

VALAFLAGS := --pkg gtk+-2.0 --pkg glib-2.0 --pkg gdk-2.0 --pkg pango

SOURCES := $(shell echo */*.vala)

teatime: $(SOURCES)
	valac $(VALAFLAGS) -o $@ $^

clean:
	rm -f teatime
