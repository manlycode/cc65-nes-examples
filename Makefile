TEMPDIR := $(shell mktemp -d)
TOOLSDIR := /usr/local/bin
EXECUTABLE := example4.nes
BUILD_DIR := build
LIB_DIR := lib

.PHONY: clean all run

.PRECIOUS: *.o

all: main.nes

clean:
	@rm -fv main.s
	@rm -fv main.o
	@rm -fv main.nes
	@rm -fv crt0.o

crt0.o: crt0.s
	ca65 crt0.s

$(BUILD_DIR)/%.o: src/%.c
	cc65 -I $(LIB_DIR) -Oi $< -o $(BUILD_DIR)/$*.s --add-source
	ca65 $(BUILD_DIR)/$*.s
	rm $(BUILD_DIR)/$*.s

%.nes: %.o crt0.o
	ld65 -C nes.cfg -o $@ crt0.o $< nes.lib

run:
	java -jar tools/nintaco/Nintaco.jar $(EXECUTABLE)

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