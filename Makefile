
3rdmodules += cJSON
build3rdmodules = $(3rdmodules: %=build-%)
sync3rdmodules = $(3rdmodules: %=sync-%)
clean3rdmodules = $(3rdmodules: %=clean-%)
info3rdmodules = $(3rdmodules: %=info-%)

$(build3rdmodules):

$(sync3rdmodules):
	@if ! test -d $(sourcedir)/3rd/$(@:sync-%=%); then						\
		cd $(sourcedir)/3rd; git clone $(repoprefix)/$(@:sync-%=%).git;		\
	else																	\
		cd $(sourcedir)/3rd/$(@:sync-%=%); git pull;						\
	fi

$(clean3rdmodules):
	@if test -d $(sourcedir)/3rd/$(@:sync-%=%); then						\
		cd $(sourcedir)/3rd/$(@:sync-%=%); make clean;						\
	fi

$(info3rdmodules):
	@if test -d $(sourcedir)/3rd/$(@:sync-%=%); then						\
		cd $(sourcedir)/3rd/$(@:sync-%=%); git status;						\
	fi

all: $(build3rdmodules)
sync: $(sync3rdmodules)
clean: $(clean3rdmodules)
info: $(info3rdmodules)
