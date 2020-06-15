include $(THEOS)/makefiles/common.mk

TARGET = iphone:clang:13.5
BUNDLE_NAME = youtubezoomprefs

youtubezoomprefs_FILES = YTZPrefsRootListController.m
youtubezoomprefs_INSTALL_PATH = /Library/PreferenceBundles
youtubezoomprefs_FRAMEWORKS = UIKit 
youtubezoomprefs_PRIVATE_FRAMEWORKS = Preferences
youtubezoomprefs_CFLAGS = -fobjc-arc -Wdeprecated-declarations -Wno-deprecated-declarations
youtubezoomprefs_EXTRA_FRAMEWORKS += Cephei CepheiPrefs

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/youtubezoomprefs.plist$(ECHO_END)
