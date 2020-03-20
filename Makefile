.PHONY: all
all: mac

.PHONY: mac
mac: out/minivmac-plus.app.tgz \
	 out/minivmac-ii.app.tgz

XCODE=-D cur_ide_xcd=1
MAC=-t mc64
LOCALTALK=-lt -lto udp
PLUS=-m Plus
II=-m II

.PHONY: out/minivmac-plus.app.tgz
out/minivmac-plus.app.tgz:
	rm -rf minivmac
	tar xzf tgz/latest.tgz
	clang minivmac/setup/tool.c -o minivmac/setup.out $(XCODE)
	minivmac/setup.out $(MAC) $(PLUS) $(LOCALTALK) > minivmac/setup.sh
	cd minivmac && bash ./setup.sh
	cd minivmac && xcodebuild
	mkdir -p out
	cd minivmac && tar czf ../$@ minivmac.app

.PHONY: out/minivmac-ii.app.tgz
out/minivmac-ii.app.tgz:
	rm -rf minivmac
	tar xzf tgz/latest.tgz
	clang minivmac/setup/tool.c -o minivmac/setup.out $(XCODE)
	minivmac/setup.out $(MAC) $(II) $(LOCALTALK) > minivmac/setup.sh
	cd minivmac && bash ./setup.sh
	cd minivmac && xcodebuild
	mkdir -p out
	cd minivmac && tar czf ../$@ minivmac.app
