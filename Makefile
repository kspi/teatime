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
