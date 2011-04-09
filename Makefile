VALAC := valac

VALAFLAGS := --pkg gtk+-2.0 --pkg glib-2.0

teatime: TeaTime.vala
	valac $(VALAFLAGS) -o $@ $^

clean:
	rm -f teatime
