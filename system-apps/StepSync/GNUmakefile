#
# GNUmakefile - Generated by ProjectCenter
#
ifeq ($(GNUSTEP_MAKEFILES),)
 GNUSTEP_MAKEFILES := $(shell gnustep-config --variable=GNUSTEP_MAKEFILES 2>/dev/null)
  ifeq ($(GNUSTEP_MAKEFILES),)
    $(warning )
    $(warning Unable to obtain GNUSTEP_MAKEFILES setting from gnustep-config!)
    $(warning Perhaps gnustep-make is not properly installed,)
    $(warning so gnustep-config is not in your PATH.)
    $(warning )
    $(warning Your PATH is currently $(PATH))
    $(warning )
  endif
endif
ifeq ($(GNUSTEP_MAKEFILES),)
 $(error You need to set GNUSTEP_MAKEFILES before compiling!)
endif

include $(GNUSTEP_MAKEFILES)/common.make

#
# Application
#
VERSION = 0.1
PACKAGE_NAME = StepSync
APP_NAME = StepSync
StepSync_APPLICATION_ICON = 


#
# Resource files
#
StepSync_RESOURCE_FILES = \
Resources/MainMenu.gorm \


#
# Header files
#
StepSync_HEADER_FILES = \
AppController.h \
FileMap.h \
FileObject.h

#
# Objective-C Class files
#
StepSync_OBJC_FILES = \
AppController.m \
FileMap.m \
FileObject.m

#
# Other sources
#
StepSync_OBJC_FILES += \
main.m 

#
# Makefiles
#
-include GNUmakefile.preamble
include $(GNUSTEP_MAKEFILES)/aggregate.make
include $(GNUSTEP_MAKEFILES)/application.make
-include GNUmakefile.postamble
