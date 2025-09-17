PACKAGE_NAME := $(shell awk -F': *' '/Package/ {print $$2}' manifest.txt)
PACKAGE_VERSION :=$(shell awk '/Version/ {print $$2}' manifest.txt)
ARTIFACT=$(PACKAGE_NAME)-$(PACKAGE_VERSION)
BUILD_ROOT=build
BUILD_DIR=$(BUILD_ROOT)/$(ARTIFACT)
MAN_PATH=$(BUILD_DIR)/usr/local/share/man/man1

deb: bin man
	mkdir -p $(BUILD_DIR)/DEBIAN
	cp manifest.txt $(BUILD_DIR)/DEBIAN/control
	cd build; \
	dpkg-deb --root-owner-group --build $(ARTIFACT)
	dpkg -c $(BUILD_ROOT)/$(ARTIFACT).deb

man: doc/graba.org
	mkdir -p $(MAN_PATH)
	pandoc -s -t man doc/graba.org -V section=1 -o $(MAN_PATH)/graba.1

bin: src/graba.pl
	mkdir -p $(BUILD_DIR)/usr/local/bin
	install -m 755 src/graba.pl $(BUILD_DIR)/usr/local/bin/graba

clean:
	$(RM) -r $(BUILD_ROOT)

.PHONY: deb man bin clean 
