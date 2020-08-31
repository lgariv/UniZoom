#import <AVFoundation/AVPlayerLayer.h>
#import <AVFoundation/AVPlayer.h>
#import <AVFoundation/AVUtilities.h>
#import <QuartzCore/QuartzCore.h>

@class UIWindow, NSDictionary, AVSecondScreenConnection, AVPictureInPictureController, UIPopoverPresentationController, AVTransitionController, AVPlaybackControlsVisibilityController, AVPlaybackControlsController, AVPlayerView, NSValue, AVPlayer, NSMutableDictionary, AVPlayerController, AVContentOverlayView, NSNumber, AVObservationController, AVBehaviorStorage, UIGestureRecognizer, AVPlayerControllerVolumeAnimator, __AVPlayerLayerView, NSString, NSArray, UIView, NSView, UIViewController, AVPlayerViewControllerContentView, AVPresentationContext, AVFullScreenViewController, AVPlayerViewControllerCustomControlsView;

static BOOL TweakisEnabled = YES;
static BOOL YouTubeisEnabled = YES;

static void loadPrefsYouTube();
static void enableForYouTube();

%group enableTweak
%hook YTVideoZoomOverlayController
- (void)resetForVideoWithAspectRatio:(double)arg1 {
    if (arg1 < 2.0) arg1 = (((((18/9)+(19.5/9))/2)+arg1)/2);
    %orig(arg1);
}
%end

%hook YTVideoZoomOverlayView
- (void)setSnapIndicatorVisible:(bool)arg1 {
    %orig(NO);
}
%end
%end

static void loadPrefs() {
    NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.miwix.youtubezoomprefs.plist"];
    if ( [prefs objectForKey:@"TweakisEnabled"] ? [[prefs objectForKey:@"TweakisEnabled"] boolValue] : TweakisEnabled ) {
        enableForYouTube();
    }
}

static void enableForYouTube() {
    NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.miwix.youtubezoomprefs.plist"];
    if ( [prefs objectForKey:@"YouTubeisEnabled"] ? [[prefs objectForKey:@"YouTubeisEnabled"] boolValue] : YouTubeisEnabled ) {
        %init(enableTweak);
    }
}

%ctor {
    loadPrefs();
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("com.miwix.youtubezoomprefs/settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
}
