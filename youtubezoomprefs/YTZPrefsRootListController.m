#include "YTZPrefsRootListController.h"

@implementation YTZPrefsRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
		
	}

	return _specifiers;
}

- (instancetype)init {
    self = [super init];

    if (self) {
		self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAlways;
		
		self.respringButton = [[UIBarButtonItem alloc] initWithTitle:@"Respring"
                                    style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(respring)];
        self.respringButton.tintColor = [UIColor blackColor];
        self.navigationItem.rightBarButtonItem = self.respringButton;
        self.navigationItem.titleView = [[UIView alloc] initWithFrame:CGRectMake(0,0,64,40)];

		NSString *_title = @"UniZoom";
		NSString *_subtitle = @"Version 2.1.1";

		UIStackView *text = [[UIStackView alloc] initWithFrame:CGRectMake(0,0,64,16)];
		text.axis = 1;
		text.distribution = 0;
		text.alignment = UIStackViewAlignmentCenter;
		text.layoutMarginsRelativeArrangement = 0;
		text.spacing = 0;

		UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,64,8)];
		titleLabel.text = _title;
        titleLabel.font = [UIFont boldSystemFontOfSize:16];
		titleLabel.textColor = [UIColor colorWithWhite:0 alpha:1];
		titleLabel.adjustsFontSizeToFitWidth = YES;
        titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
		titleLabel.textAlignment = NSTextAlignmentCenter;
		titleLabel.numberOfLines = 1;

		UILabel *subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,64,8)];
		subtitleLabel.text = _subtitle;
        subtitleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightUltraLight];
		subtitleLabel.textColor = [UIColor colorWithWhite:0 alpha:0.7];
		subtitleLabel.adjustsFontSizeToFitWidth = YES;
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
		subtitleLabel.textAlignment = NSTextAlignmentCenter;
		subtitleLabel.numberOfLines = 1;

		[text addArrangedSubview:titleLabel];
		[text addArrangedSubview:subtitleLabel];

        self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,32,40)];
        self.iconView.contentMode = UIViewContentModeScaleAspectFit;
        self.iconView.image = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/youtubezoomprefs.bundle/icon.png"];
        self.iconView.translatesAutoresizingMaskIntoConstraints = NO;

		UIStackView *titleStackView = [[UIStackView alloc] initWithFrame:CGRectMake(0,0,64,80)];
		titleStackView.axis = 1;
		titleStackView.distribution = 0;
		titleStackView.alignment = UIStackViewAlignmentCenter;
		titleStackView.layoutMarginsRelativeArrangement = 0;
		titleStackView.spacing = 1;

		[titleStackView addArrangedSubview:self.iconView];
		[titleStackView addArrangedSubview:text];

        [self.navigationItem.titleView addSubview:titleStackView];
		
		//self.navigationItem.titleView = titleView;

		HBAppearanceSettings *appearanceSettings = [[HBAppearanceSettings alloc] init];
		//appearanceSettings.navigationBarBackgroundColor = [UIColor colorWithRed:204.f / 255.f green:34.f / 255.f blue:34.f / 255.f alpha:1];
		appearanceSettings.navigationBarTintColor = [UIColor colorWithWhite:0 alpha:1];
		appearanceSettings.navigationBarTitleColor = [UIColor colorWithWhite:0 alpha:1];

		self.hb_appearanceSettings = appearanceSettings;
    }

    return self;
}

- (void)loadView {
	[super loadView];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];

	if (@available(iOS 11, *)) {
		self.navigationController.navigationBar.prefersLargeTitles = false;
		self.navigationController.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
	}
}

-(void)viewDidLoad {
	[super viewDidLoad];
	
	if (@available(iOS 13, *)) {}
	else {
		NSMutableArray *array = [[NSMutableArray alloc] init];

		NSArray *chosenTags = @[@"toBeHidden"];
		for (PSSpecifier *specifier in _specifiers) {
			if ([chosenTags containsObject:[specifier propertyForKey:@"tag"]]) {
				[array addObject:specifier];
			}
		}

		[self removeContiguousSpecifiers:array animated:NO];
	}
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {

    CGFloat offsetY = scrollView.contentOffset.y;
    //CGFloat offsetY = scrollView.minimumContentOffset.y;

    if (offsetY > (scrollView.minimumContentOffset.y+1)) {
        [UIView animateWithDuration:0.133 animations:^{
			self.navigationItem.titleView.frame = CGRectMake(self.navigationItem.titleView.frame.origin.x, -40, self.navigationItem.titleView.frame.size.width, self.navigationItem.titleView.frame.size.height);
            //self.iconView.alpha = 0.0;
            //self.titleLabel.alpha = 1.0;

        }];
    } else {
        [UIView animateWithDuration:0.133 animations:^{
			self.navigationItem.titleView.frame = CGRectMake(self.navigationItem.titleView.frame.origin.x, 0, self.navigationItem.titleView.frame.size.width, self.navigationItem.titleView.frame.size.height);
			//self.iconView.alpha = 1.0;
            //self.titleLabel.alpha = 0.0;

        }];
    }
}
@end
