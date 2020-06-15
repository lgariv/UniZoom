INSTALL_TARGET_PROCESSES = SpringBoard

ARCHS = arm64 arm64e
TARGET = iphone:clang:13.5

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = AVZoom
AVZoom_FILES = Tweak.xm
AVZoom_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk

BUNDLE_NAME = AVZoomBundle
AVZoomBundle_INSTALL_PATH = /Library/Application Support

include $(THEOS)/makefiles/bundle.mk
