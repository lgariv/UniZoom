export ARCHS = arm64 arm64e

export TARGET = iphone:clang:13.5:12.2

GO_EASY_ON_ME = 1
FINALPACKAGE=1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = YouTubeZoom

YouTubeZoom_FILES = Tweak.xm
YouTubeZoom_CFLAGS = -fobjc-arc
YouTubeZoom_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += YouTubeZoomprefs AVZoom 
include $(THEOS_MAKE_PATH)/aggregate.mk
