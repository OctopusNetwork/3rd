rootdir := $(shell pwd)/../..
project ?= ubuntu-base

include $(rootdir)/build/project/$(project).mk
include $(rootdir)/build/common/common.mk

3rdmodules = cJSON gperftools googletest
build3rdmodules = $(3rdmodules:%=build-%)
sync3rdmodules = $(3rdmodules:%=sync-%)
clean3rdmodules = $(3rdmodules:%=clean-%)
info3rdmodules = $(3rdmodules:%=info-%)

build-cJSON:
	mkdir -p $(intermediatedir)/3rd/cJSON
	cd $(intermediatedir)/3rd/cJSON; cmake $(rootdir)/source/3rd/cJSON		\
		-DCMAKE_INSTALL_PREFIX=$(outputdir) -DCMAKE_C_FLAGS="-fPIC"			\
		-DBUILD_SHARED_LIBS=OFF -DBUILD_STATIC_LIBS=ON
	cd $(intermediatedir)/3rd/cJSON; make; make install

build-gperftools:
	mkdir -p $(intermediatedir)/3rd/gperftools
	cd $(rootdir)/source/3rd/gperftools; ./autogen.sh
	cd $(intermediatedir)/3rd/gperftools; $(rootdir)/source/3rd/gperftools/configure	\
												--prefix=$(outputdir)					\
												--disable-static						\
												--enable-shared							\
												--host=$(crosshost)
	cd $(intermediatedir)/3rd/gperftools; make; make install

build-googletest:
	mkdir -p $(intermediatedir)/3rd/googletest
	cd $(rootdir)/source/3rd/googletest/googletest;										\
		cmake $(rootdir)/source/3rd/googletest -DCMAKE_INSTALL_PREFIX=$(outputdir)		\
		-DCMAKE_C_FLAGS="-fPIC" -DBUILD_SHARED_LIBS=OFF -DBUILD_STATIC_LIBS=ON
	cd $(rootdir)/source/3rd/googletest/googletest; make; make install

$(sync3rdmodules):
	@if ! test -d $(sourcedir)/3rd/$(@:sync-%=%); then						\
		cd $(sourcedir)/3rd; git clone $(repoprefix)/$(@:sync-%=%).git;		\
	else																	\
		cd $(sourcedir)/3rd/$(@:sync-%=%); git pull;						\
	fi

$(clean3rdmodules):
	if test -d $(intermediatedir)/3rd/$(@:clean-%=%); then					\
		cd $(intermediatedir)/3rd/$(@:clean-%=%); make clean;				\
		rm -rf $(intermediatedir)/3rd/$(@:clean-%=%);						\
	fi

$(info3rdmodules):
	@if test -d $(sourcedir)/3rd/$(@:info-%=%); then						\
		cd $(sourcedir)/3rd/$(@:info-%=%); git status;						\
	fi

all: $(build3rdmodules)
sync: $(sync3rdmodules)
clean: $(clean3rdmodules)
info: $(info3rdmodules)
install:
