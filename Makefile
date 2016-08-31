CFG		= kernel-$(VERSION)
CONFIGFILES	= $(CFG)-x86_64.config $(CFG)-x86_64-debug.config
TEMPFILES	= $(addprefix temp-, $(addsuffix -generic, x86_64))

configs: $(CONFIGFILES)
	@rm -f kernel-*-config
	@rm -f $(TEMPFILES)
	@rm -f temp-generic temp-*-generic temp-*-generic-tmp

# Augment the clean target to clean up our own cruft
clean ::
	@rm -fv $(CONFIGFILES) $(TEMPFILES) temp-generic kernel-$(VERSION)*config

temp-generic: config-generic config-nodebug
	cat $^ > temp-generic

temp-debug-generic: config-generic config-debug
	cat $^ > temp-debug-generic

temp-no-extra-generic: config-no-extra temp-generic
	perl merge.pl $^ > $@

temp-x86-64: config-x86_64-generic config-x86-generic
	perl merge.pl $^  > $@

temp-x86_64-generic: temp-x86-64 temp-generic
	perl merge.pl $^  > $@

temp-x86_64-debug-generic: temp-x86-64 temp-debug-generic
	perl merge.pl $^  > $@

$(CFG)-x86_64.config: temp-x86_64-generic
	perl merge.pl $^ x86_64 > $@

$(CFG)-x86_64-debug.config: temp-x86_64-debug-generic
	perl merge.pl $^ x86_64 > $@

local:
	fedpkg -v local
