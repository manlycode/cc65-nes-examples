TEMPDIR := $(shell mktemp -d)
TOOLSDIR := /usr/local/bin

.PHONY: clean all

.PRECIOUS: *.o

all: example1.nes example2.nes example3.nes example4.nes example5.nes

clean:
	@rm -fv example1.s example2.s example3.s example4.s example5.s
	@rm -fv example1.o example2.o example3.o example4.o example5.o
	@rm -fv example1.nes example2.nes example3.nes example4.nes example5.nes
	@rm -fv crt0.o

crt0.o: crt0.s
	ca65 crt0.s

%.o: %.c
	cc65 -Oi $< --add-source
	ca65 $*.s
	rm $*.s

%.nes: %.o crt0.o
	ld65 -C nes.cfg -o $@ crt0.o $< nes.lib


tools:
	mkdir tools

# FCEUX
tools/fceux: tools
	- mkdir tools/fceux

tools/fceux/fceux.exe: tools/fceux
	curl http://sourceforge.net/projects/fceultra/files/Binaries/2.2.3/fceux-2.2.3-win32.zip/download -L -o $(TEMPDIR)/fceux.zip
	cd $< && unzip $(TEMPDIR)/fceux.zip

# nintaco
tools/nintaco: tools
	- mkdir tools/nintaco

tools/nintaco/Nintaco.jar: tools/nintaco
	curl https://nintaco.com/Nintaco_bin_2019-02-10.zip -L -o $(TEMPDIR)/nintaco.zip
	open $(TEMPDIR)
	cd $< && unzip $(TEMPDIR)/nintaco.zip

# NESST
tools/nesst: tools
	- mkdir tools/nesst

tools/nesst/nesst.exe: tools/nesst
	curl https://shiru.untergrund.net/files/nesst.zip -L -o $(TEMPDIR)/nesst.zip
	open $(TEMPDIR)
	cd $< && unzip $(TEMPDIR)/nesst.zip
	open tools




.PHONY: bootstrap
bootstrap: tools/fceux/fceux.exe tools/nesst/nesst.exe tools/nintaco/Nintaco.jar

.PHONY: clean-tools
clean-tools:
	rm -rf tools