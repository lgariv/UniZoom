#import <AVFoundation/AVPlayerLayer.h>
#import <AVFoundation/AVPlayer.h>
#import <AVFoundation/AVUtilities.h>
#import <QuartzCore/QuartzCore.h>

@class UIWindow, NSDictionary, AVSecondScreenConnection, AVPictureInPictureController, UIPopoverPresentationController, AVTransitionController, AVPlaybackControlsVisibilityController, AVPlaybackControlsController, AVPlayerView, NSValue, AVPlayer, NSMutableDictionary, AVPlayerController, AVContentOverlayView, NSNumber, AVObservationController, AVBehaviorStorage, UIGestureRecognizer, AVPlayerControllerVolumeAnimator, __AVPlayerLayerView, NSString, NSArray, UIView, NSView, UIViewController, AVPlayerViewControllerContentView, AVPresentationContext, AVFullScreenViewController, AVPlayerViewControllerCustomControlsView;

@interface AVButton : UIView 
@property (assign,getter=isRemoved,nonatomic) BOOL removed;                                                              //@synthesize removed=_removed - In the implementation block
@property (nonatomic,copy) NSString * imageName;                                                                         //@synthesize imageName=_imageName - In the implementation block
@end

@interface WebAVPlayerLayer : CALayer {
	CGSize _videoDimensions;
}
@property (assign) CGSize videoDimensions;                                                    //@synthesize videoDimensions=_videoDimensions - In the implementation block
-(CGSize)videoDimensions;
@end

//Netflix
@interface NFUIPlayerView : UIView {
	CGSize _videoDimensions;
}
@property (nonatomic, assign, readwrite) NSUInteger playerViewResizeMode;
@property (nonatomic, weak, readwrite) AVPlayer *player;
@property (assign) CGSize videoDimensions;                                                    //@synthesize videoDimensions=_videoDimensions - In the implementation block
//@property (assign,getter=isUserInteractionEnabled,nonatomic) BOOL userInteractionEnabled; 
-(CGSize)videoDimensions;

//%new
-(void)changeToggle;
-(void)changeToFill;
-(void)changeBack;
@end

@interface __AVPlayerLayerView : UIView 
@property (nonatomic, readonly) AVPlayerLayer * playerLayer;

// %new
@property (nonatomic, readonly) WebAVPlayerLayer * layer;
-(void)changeToFill;
-(void)changeBack;
-(void)changeToggle;
@end

@interface AVPlaybackControlsView : UIView
@property (nonatomic,readonly) AVButton * fullScreenButton;                                                              //@synthesize fullScreenButton=_fullScreenButton - In the implementation block
@property (nonatomic,readonly) AVButton * videoGravityButton;                                                              //@synthesize fullScreenButton=_fullScreenButton - In the implementation block
@end

@interface AVPlayerViewController : UIViewController {
	long long _videoGravity;
	CGRect _videoBounds;
}
@property (nonatomic,copy) NSString * videoGravity; 
@property (nonatomic,readonly) CGSize videoDisplaySize; 
@property (nonatomic,readonly) double videoDisplayScale; 
@property (nonatomic,readonly) AVPlayerViewControllerContentView * contentView; 
+(id)sharedInstance;
-(void)_togglePictureInPicture;
-(void)setVideoBounds:(CGRect)arg1 ;
-(void)updateVideoBounds;

// %new
-(void)changeToFill;
-(void)changeBack;
-(void)changeToggle;
@end

@protocol AVPlayerViewControllerContentViewDelegate, AVPlaybackContentContainer;
@class NSString, AVExternalPlaybackIndicatorView, UIImageView, UIView, AVPlaybackControlsView, AVTurboModePlaybackControlsPlaceholderView, __AVPlayerLayerView, NSMutableDictionary, AVCABackdropLayerView, AVStyleSheet, AVScrollViewObserver, NSNumber;

@interface AVPlayerViewControllerContentView : UIView {
	__AVPlayerLayerView* _playerLayerView;
}
@property (nonatomic,retain) __AVPlayerLayerView * playerLayerView;                                                                       //@synthesize playerLayerView=_playerLayerView - In the implementation block
@property (nonatomic,readonly) AVPlaybackControlsView * playbackControlsView;                                                             //@synthesize playbackControlsView=_playbackControlsView - In the implementation block
-(__AVPlayerLayerView *)playerLayerView;

// %new
-(void)changeToFill;
-(void)changeBack;
-(void)changeToggle;
@end

@interface AVFullscreenViewController : UIViewController

// %new
-(void)changeToFill;
-(void)changeBack;
-(void)changeToggle;
@end

int changeToggleState = 0;

@interface AVPlayerLayerAndContentOverlayContainerView : UIView
@end

CGRect videoBoundsOrig;
CGRect videoBoundsToFill;

@interface WebAVPlayerController : NSObject
@end

CGSize originBoundsSize;

NSString *fitImageName;
NSString *fillImageName;
BOOL isPortrait = 1;

double netflixZoomBy;

%group enableNetflixTweak
%hook NFUIPlayerControlsRefreshViewController
-(void)didPinchWithGestureRecognizer:(id)arg1 {
	//%orig;
	[[NSNotificationCenter defaultCenter] 
	postNotificationName:@"Toggle" 
	object:self];

    //[self changeToggle];
}
%end

%hook NFUIPlayerView
/*-(void)initWithFrame:(CGRect)arg1 {
	%orig;

	//self.userInteractionEnabled = YES;

	[[NSNotificationCenter defaultCenter] addObserver:self
    selector:@selector(ToggleScale:) 
    name:@"Toggle"
    object:nil];
}*/
-(void)setPlayer:(id)arg1 {
	%orig;

	[[NSNotificationCenter defaultCenter] addObserver:self
	    selector:@selector(ToggleScale:) 
	    name:@"Toggle"
	    object:nil];
}

-(void)setPlayerViewResizeMode:(NSUInteger)arg1 {
	arg1 = 0;
}

%new
- (void) ToggleScale:(NSNotification *) notification {
    [self changeToggle];
}

%new
-(void)changeToggle {
		if (changeToggleState == 0) {
		[self changeToFill];
	} else if (changeToggleState == 1) {
		[self changeBack];
	} else if (changeToggleState == 2) {
		[self changeToFill];
	}
}

%new
-(void)changeToFill {
	changeToggleState = 1;
	NSLog(@"should zoom to fill");

	originBoundsSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height);

	netflixZoomBy = 2/(originBoundsSize.width/originBoundsSize.height);

	[UIView animateWithDuration:0.3 animations:^{
		self.superview.transform = CGAffineTransformScale(CGAffineTransformIdentity, netflixZoomBy, netflixZoomBy);
	}
	completion:nil];
}

%new
-(void)changeBack {
	changeToggleState = 2;
	NSLog(@"should zoom back");

	[UIView animateWithDuration:0.3 animations:^{
		self.superview.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
	}
	completion:nil];
}
%end
%end

%group enableSafariTweak
%hook AVPlayerViewController
-(void)_handleDoubleTapGesture:(id)arg1 {
	originBoundsSize = CGSizeMake(self.contentView.playerLayerView.bounds.size.width, self.contentView.playerLayerView.bounds.size.height);

	double aspectCheck = originBoundsSize.width/originBoundsSize.height;
	if (aspectCheck < 2) {
	[self.contentView changeToggle];
	} else if (aspectCheck > 2) {
	[self.contentView changeToggle];
	} else if (aspectCheck == 2) {
	[self.contentView changeToggle];
	}
}

-(void)videoGravityButtonTapped:(id)arg1 {

	//-(void)setVideoGravity:(NSString *)arg1 ;
	//AVPlayerViewController *AVP = [%c(AVPlayerViewController) sharedInstance];
	
	NSLog(@"videoBoundsTest");
	
	videoBoundsOrig = MSHookIvar<CGRect>(self, "_videoBounds"); // getter לכל המכשירים

	NSLog(@"%@ : videoBoundsOrig\n", NSStringFromCGRect(videoBoundsOrig));
	//NSLog(@"%@ : videoFrame\n", NSStringFromCGRect(videoFrame));

	//return %orig(arg1);

    [self.contentView changeToggle];
}
%end

double zoomBy;
double aspectCheck;
CGSize defaultReturnPortrait;
CGSize defaultReturnLandscape;
bool quick;
UIDeviceOrientation lastRot;
UIDeviceOrientation lastKnown = UIDeviceOrientationUnknown;

%hook AVPlayerViewControllerContentView
-(void)loadPlaybackControlsViewIfNeeded {
	%orig;

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRotate:) name:UIDeviceOrientationDidChangeNotification object:nil];

	aspectCheck = originBoundsSize.width/originBoundsSize.height;
	if (aspectCheck < 2) {
		[self.playbackControlsView.videoGravityButton setRemoved:NO];
		[self.playbackControlsView.fullScreenButton self];
	} else if (aspectCheck > 2) {
		[self.playbackControlsView.videoGravityButton setRemoved:NO];
		[self.playbackControlsView.fullScreenButton self];
	} else if (aspectCheck == 2) {
		[self.playbackControlsView.videoGravityButton setRemoved:YES];
		[self.playbackControlsView.fullScreenButton self];
	}
}

%new
- (void) didRotate:(NSNotification *)notification {

    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];

	if (lastRot == orientation) {
    	if (changeToggleState == 1) {
			changeToggleState = 0;
			//self.playerLayerView.playerLayer.videoGravity = AVLayerVideoGravityResize;
			self.playerLayerView.superview.frame = AVMakeRectWithAspectRatioInsideRect(self.playerLayerView.layer.videoDimensions, self.bounds);
			quick = YES;
			[self changeToFill];
			[self changeBack];
			quick = NO;
			[self.playerLayerView.superview self];
		}
    } else if (lastRot == UIDeviceOrientationPortrait) {
    	if (orientation == UIDeviceOrientationLandscapeLeft) {
	    	if (changeToggleState == 1) {
				changeToggleState = 0;
				//self.playerLayerView.playerLayer.videoGravity = AVLayerVideoGravityResize;
				self.playerLayerView.superview.frame = AVMakeRectWithAspectRatioInsideRect(self.playerLayerView.layer.videoDimensions, self.bounds);
				quick = YES;
				[self changeToFill];
				[self changeBack];
				quick = NO;
				[self.playerLayerView.superview self];
			}
		} else if (orientation == UIDeviceOrientationLandscapeRight) {
			if (changeToggleState == 1) {
				changeToggleState = 0;
				//self.playerLayerView.playerLayer.videoGravity = AVLayerVideoGravityResize;
				self.playerLayerView.superview.frame = AVMakeRectWithAspectRatioInsideRect(self.playerLayerView.layer.videoDimensions, self.bounds);
				quick = YES;
				[self changeToFill];
				[self changeBack];
				quick = NO;
				[self.playerLayerView.superview self];
			}
		}
    } else if (lastRot == UIDeviceOrientationLandscapeLeft || UIDeviceOrientationLandscapeRight) {
    	if (orientation == UIDeviceOrientationPortrait) {
	    	if (changeToggleState == 1) {
				changeToggleState = 0;
				//self.playerLayerView.playerLayer.videoGravity = AVLayerVideoGravityResize;
				self.playerLayerView.superview.frame = AVMakeRectWithAspectRatioInsideRect(self.playerLayerView.layer.videoDimensions, self.bounds);
				quick = YES;
				[self changeToFill];
				[self changeBack];
				quick = NO;
				[self.playerLayerView.superview self];
			}
		}
	}

	if (orientation == UIDeviceOrientationLandscapeLeft){
        NSLog(@"Landscape Left");
        isPortrait = NO;
        NSLog(@"isPortrait : No\n");
        lastRot = orientation;
		lastKnown = orientation;
    } else if (orientation == UIDeviceOrientationLandscapeRight) {
    	NSLog(@"Landscape Right");
		isPortrait = NO;
		NSLog(@"isPortrait : No\n");
        lastRot = orientation;
		lastKnown = orientation;
    } else if (orientation == UIDeviceOrientationPortrait) {
        NSLog(@"Now Portrait");
        isPortrait = YES;
        NSLog(@"isPortrait : Yes\n");
        lastRot = orientation;
		lastKnown = orientation;
    } else {
        lastRot = UIDeviceOrientationUnknown;
    }
}

%new
-(void)changeToggle {
	if (isPortrait == YES) {
		fitImageName = @"ScaleToFitLetterboxButton";
		fillImageName = @"ScaleToFillLetterboxButton";
	} else if (isPortrait == NO) {
		fitImageName = @"ScaleToFitPillarboxButton";
		fillImageName = @"ScaleToFillPillarboxButton";
	}

	if (changeToggleState == 0) {
		[self changeToFill];
		[self.playbackControlsView.videoGravityButton setImageName:fitImageName];
	} else if (changeToggleState == 1) {
		[self changeBack];
		[self.playbackControlsView.videoGravityButton setImageName:fillImageName];
	} else if (changeToggleState == 2) {
		[self changeToFill];
		[self.playbackControlsView.videoGravityButton setImageName:fitImageName];
	}
}

%new
-(void)changeToFill {
	changeToggleState = 1;
	NSLog(@"should zoom to fill");

	originBoundsSize = CGSizeMake(self.playerLayerView.bounds.size.width, self.playerLayerView.bounds.size.height);
	
	CGSize rotationCheckVal = CGSizeMake(self.bounds.size.width, self.bounds.size.height);
	double rotationCheck = rotationCheckVal.width/rotationCheckVal.height;
	if (rotationCheck < 1) {
		zoomBy = (2/(19.5/9))*(rotationCheckVal.height/originBoundsSize.height);
	} else if (rotationCheck > 1) {
		zoomBy = 2/(originBoundsSize.width/originBoundsSize.height);
	}

	if (quick == YES) {
		self.playerLayerView.superview.transform = CGAffineTransformScale(CGAffineTransformIdentity, zoomBy, zoomBy);
	} else if (quick == NO) {
		[UIView animateWithDuration:0.3 animations:^{
			self.playerLayerView.superview.transform = CGAffineTransformScale(CGAffineTransformIdentity, zoomBy, zoomBy);
		}
		completion:nil];
	}

	/*[self.playerLayerView.superview setBounds:CGRectMake(self.playerLayerView.frame.origin.x, self.playerLayerView.frame.origin.y, self.playerLayerView.frame.size.width+16, self.playerLayerView.frame.size.height+9)];
	self.playerLayerView.superview.frame = self.playerLayerView.superview.bounds;*/
	//self.playerLayerView.superview.frame.size = self.playerLayerView.superview.bounds.size;
	//self.playerLayerView.superview.frame.size = self.playerLayerView.superview.bounds.size;
}

%new
-(void)changeBack {
	changeToggleState = 2;
	NSLog(@"should zoom back");

	if (quick == YES) {
		self.playerLayerView.superview.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
	} else if (quick == NO) {
		[UIView animateWithDuration:0.3 animations:^{
			self.playerLayerView.superview.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
		}
		completion:nil];
	}

	//self.playerLayerView.frame = originBounds;
}

/*%new
-(void)setVideoBounds:(CGRect)arg1 {
	arg1 = CGRectMake(0, 0, 375, 211);
	[self updateVideoBounds];
	//{{0, 0}, {375, 211}} = 16:9 Portrait
}*/
%end
%end

static BOOL TweakisEnabled = YES;
static BOOL SafariIsEnabled = YES;
static BOOL NetflixisEnabled = YES;

static void loadPrefsWebAVPlayer();
static void loadPrefsNetflix();
static void enableForWebAVPlayer();
static void enableForNetflix();

static void loadPrefs() {
    NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.miwix.youtubezoomprefs.plist"];
    if ( [prefs objectForKey:@"TweakisEnabled"] ? [[prefs objectForKey:@"TweakisEnabled"] boolValue] : TweakisEnabled ) {
        loadPrefsWebAVPlayer();
        loadPrefsNetflix();
        }
}

static void loadPrefsWebAVPlayer() {
    enableForWebAVPlayer();
}

static void enableForWebAVPlayer() {
    NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.miwix.youtubezoomprefs.plist"];
    if ( [prefs objectForKey:@"SafariIsEnabled"] ? [[prefs objectForKey:@"SafariIsEnabled"] boolValue] : SafariIsEnabled ) {
        %init(enableSafariTweak);
        }
}

static void loadPrefsNetflix() {
    enableForNetflix();
}

static void enableForNetflix() {
    NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.miwix.youtubezoomprefs.plist"];
    if ( [prefs objectForKey:@"NetflixisEnabled"] ? [[prefs objectForKey:@"NetflixisEnabled"] boolValue] : NetflixisEnabled ) {
        %init(enableNetflixTweak);
        }
}

%ctor {
    loadPrefs();
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("com.miwix.youtubezoomprefs/settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
}
