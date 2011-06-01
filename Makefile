VERSION := 1

VALAC := valac

PACKAGES := gtk+-3.0 gdk-3.0 pango

VALAFLAGS := $(shell for p in $(PACKAGES); do echo --pkg $$p; done)
CFLAGS := $(shell pkg-config --cflags $(PACKAGES))
LDFLAGS := $(shell pkg-config --libs $(PACKAGES))

SOURCES := $(wildcard */*.vala)
CSOURCES := $(patsubst %.vala,%.c,$(SOURCES))
OBJS := $(patsubst %.c,%.o,$(CSOURCES))

teatime: $(OBJS)
	$(CC) $(LDFLAGS) -o $@ $^

%.c: %.vala
	$(VALAC) $(VALAFLAGS) -C $(SOURCES)
	touch $@

.PHONY: csources
csources: $(CSOURCES)

.PHONY: clean
clean:
	rm -f $(CSOURCES) teatime $(OBJS)

.PHONY: cdist
cdist: clean csources
	rm -rf teatime-c-$(VERSION).tar.bz2 teatime-c-$(VERSION)
	mkdir teatime-c-$(VERSION)
	cp -r Makefile README.org TeaTime teatime-c-$(VERSION)
	tar -jcvf teatime-c-$(VERSION).tar.bz2 teatime-c-$(VERSION)
	@echo "teatime-c-$(VERSION).tar.bz2 is ready!"
