LATEST=minivmac200315.src.tgz

MAC_PLUS=minivmac-plus.app
MAC_II=minivmac-ii.app
MAC_OUT=out/$(MAC_PLUS) out/$(MAC_II)
MAC_DIST=dist/$(MAC_PLUS).zip dist/$(MAC_II).zip

.PHONY: all
all: mac

.PHONY: mac
mac: $(MAC_OUT)

.PHONY: macdist
macdist: $(MAC_DIST)

XCODE=-D cur_ide_xcd=1
MAC64=-t mc64
LOCALTALK=-lt -lto udp
PLUS=-m Plus
II=-m II -speed z

tgz/$(LATEST):
	mkdir -p tgz
	curl -o $@ https://www.gryphel.com/d/minivmac/c/$(LATEST)

out/$(MAC_PLUS): tgz/$(LATEST)
	rm -rf minivmac
	tar xzf $<
	clang minivmac/setup/tool.c -o minivmac/setup.out $(XCODE)
	minivmac/setup.out $(MAC64) $(PLUS) $(LOCALTALK) > minivmac/setup.sh
	cd minivmac && bash ./setup.sh && xcodebuild
	mkdir -p out
	cp -r minivmac/minivmac.app $@

dist/$(MAC_PLUS).zip: out/$(MAC_PLUS)
	codesign --force --sign "Developer ID Application" $<
	mkdir -p dist
	ditto -ck --keepParent $< $@

out/$(MAC_II): tgz/$(LATEST)
	rm -rf minivmac
	tar xzf $<
	clang minivmac/setup/tool.c -o minivmac/setup.out $(XCODE)
	minivmac/setup.out $(MAC64) $(II) $(LOCALTALK) > minivmac/setup.sh
	cd minivmac && bash ./setup.sh && xcodebuild
	mkdir -p out
	cp -r minivmac/minivmac.app $@

dist/$(MAC_II).zip: out/$(MAC_II)
	codesign --force --sign "Developer ID Application" $<
	mkdir -p dist
	ditto -ck --keepParent $< $@
