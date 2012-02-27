### The project name
PROJECT=raid-check

### Dependencies
DEP_BINS=grep cat sleep awk ps renice ionice

### Destination Paths
D_BIN=/usr/local/sbin
D_CNF=/etc

### Lists of files to be installed
F_CONF=raid-check.conf

###############################################################################

all: install

install: test bin config
	# install the actual script
	install -D --owner root --group root -m 0755 $(PROJECT).sh $(DESTDIR)$(D_BIN)/$(PROJECT)

test:
	@echo "==> Checking for required external dependencies"
	for bindep in $(DEP_BINS) ; do \
		which $$bindep > /dev/null || { echo "$$bindep not found"; exit 1;} ; \
	done

	@echo "==> Checking for valid script syntax"
	bash -n raid-check.sh

bin: $(PROJECT).sh test

config: $(F_CONF)
	# Install (without overwriting) configuration files
	for f in $(F_CONF) ; do \
		[[ -e $(DESTDIR)$(D_CNF)/$$f ]] || \
			install -D -m 0644 $$f $(DESTDIR)$(D_CNF)/$$f ; \
	done

uninstall:
	rm -f $(DESTDIR)$(D_BIN)/$(PROJECT)
	@echo "Leaving '$(DESTDIR)$(D_CNF)' untouched"
