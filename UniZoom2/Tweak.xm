#import <AVFoundation/AVPlayerLayer.h>
#import <AVFoundation/AVPlayer.h>
#import <AVFoundation/AVUtilities.h>
#import <QuartzCore/QuartzCore.h>

@class UIWindow, NSDictionary, AVSecondScreenConnection, AVPictureInPictureController, UIPopoverPresentationController, AVTransitionController, AVPlaybackControlsVisibilityController, AVPlaybackControlsController, AVPlayerView, NSValue, AVPlayer, NSMutableDictionary, AVPlayerController, AVContentOverlayView, NSNumber, AVObservationController, AVBehaviorStorage, UIGestureRecognizer, AVPlayerControllerVolumeAnimator, __AVPlayerLayerView, NSString, NSArray, UIView, NSView, UIViewController, AVPlayerViewControllerContentView, AVPresentationContext, AVFullScreenViewController, AVPlayerViewControllerCustomControlsView;

/*@interface YTPlayerView : UIView
@property (assign,nonatomic) BOOL zoomToFill;
- (void)setZoomToFill:(BOOL)arg1;
@end*/

static BOOL TweakisEnabled = YES;
static BOOL YouTubeisEnabled = YES;
//static BOOL SnapisEnabled = YES;

static double aspectRatioToZoom = 1.93; //Aspect ratio when zoomed on an iPhone

//static void snapByDefault();

static void loadPrefsYouTube();
static void enableForYouTube();

%group enableTweak
%hook YTVideoZoomOverlayController
- (void)resetForVideoWithAspectRatio:(double)arg1 {
    arg1 = aspectRatioToZoom;
    %orig;
}
%end
%hook YTVideoZoomOverlayView
- (void)setSnapIndicatorVisible:(bool)arg1 {
    arg1 = NO;
    %orig;
}
%end
%end

/*%group enableDefault
- (void)setZoomToFill:(BOOL)arg1 {
    %orig(YES);
}
%end

%hook YTVideoZoomOverlayController
- (void)setSnappedToFillByDefault:(bool)arg1 {
    %orig;
    arg1 = YES;
}
%end
%end*/ //disabled as YouTube implemented a switch in the app settings.

static void loadPrefs() {
    NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.miwix.youtubezoomprefs.plist"];
    if ( [prefs objectForKey:@"TweakisEnabled"] ? [[prefs objectForKey:@"TweakisEnabled"] boolValue] : TweakisEnabled ) {
        loadPrefsYouTube();
        }
}

static void loadPrefsYouTube() {
    enableForYouTube();
    //snapByDefault();
}

static void enableForYouTube() {
    NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.miwix.youtubezoomprefs.plist"];
    if ( [prefs objectForKey:@"YouTubeisEnabled"] ? [[prefs objectForKey:@"YouTubeisEnabled"] boolValue] : YouTubeisEnabled ) {
        %init(enableTweak);
        }
}

/*static void snapByDefault() {
    NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.miwix.youtubezoomprefs.plist"];
    if ( [prefs objectForKey:@"SnapisEnabled"] ? [[prefs objectForKey:@"SnapisEnabled"] boolValue] : SnapisEnabled ) {
        %init(enableDefault);
        }
}*/

%ctor {
    loadPrefs();
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("com.miwix.youtubezoomprefs/settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
}
