VALAC := valac

VALAFLAGS := --pkg gtk+-2.0 --pkg glib-2.0

SOURCES := $(shell echo */*.vala)

teatime: $(SOURCES)
	valac $(VALAFLAGS) -o $@ $^

clean:
	rm -f teatime
