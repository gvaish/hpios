//
//  HPMainTabBarViewController.m
//  HighPerformance
//
//  Created by Gaurav Vaish on 8/22/14.
//  Copyright (c) 2014 Gaurav Vaish. All rights reserved.
//

#import "HPMainTabBarViewController.h"
#import "HPLogger.h"
#import "HPInstrumentation.h"
#import "HPAppDelegate.h"

extern CFAbsoluteTime startTime;

@interface HPMainTabBarViewController ()

-(GADRequest *)adRequest;
-(void)loadAds;

@property (nonatomic, strong) UIView *adViewContainer;
@property (nonatomic, strong) GADBannerView *adView;

@end

@implementation HPMainTabBarViewController

@synthesize adView;

-(id)initWithCoder:(NSCoder *)aDecoder {
	CFAbsoluteTime currentTime = CFAbsoluteTimeGetCurrent();
	CFTimeInterval timeTaken = currentTime - startTime;

	[HPLogger d:[NSString stringWithFormat:@"[HPMainTabBarViewController::initWithCoder] timeTaken: %lf", timeTaken]];
	return [super initWithCoder:aDecoder];
}

-(void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[HPInstrumentation logPageViewForTabBarController:self];
}

- (void)loadAds
{
	CGRect frame = self.tabBar.frame;
	CGFloat adHeight = kGADAdSizeBanner.size.height;

	frame.origin.y = frame.origin.y - adHeight;
	frame.size.height = frame.size.height;
	[self.tabBar setFrame:frame];
	//[self.view setBounds:self.tabBar.bounds];

	self.adView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
	self.adView.frame = CGRectMake(0, 0, kGADAdSizeBanner.size.width, adHeight);
	self.adView.delegate = self;

    self.adViewContainer = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height, kGADAdSizeBanner.size.width, adHeight)];
    self.adViewContainer.backgroundColor = [UIColor whiteColor];
    [self.adViewContainer addSubview:self.adView];

	//FIXME/TODO[gvaish] - Change the adUnitID
	self.adView.adUnitID = @"ca-app-pub-1072277527473909/6446752278";
	self.adView.rootViewController = self;
	[self.adView loadRequest:self.adRequest];

	[self.tabBar addSubview:self.adViewContainer];
}

- (void)viewDidLoad
{
	[super viewDidLoad];

    [self loadAds];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewDidLayoutSubviews
{
	[super viewDidLayoutSubviews];
//	for(UIView *view in self.view.subviews)
//	{
//		CGRect _rect = view.frame;
//		if(![view isKindOfClass:[UITabBar class]])
//		{
//			_rect.size.height = _rect.size.height - 50;
//			[view setFrame:_rect];
//		}
//	}
}

-(GADRequest *)adRequest
{
	GADRequest *rv = [[GADRequest alloc] init];
	rv.testDevices = [NSArray arrayWithObjects:GAD_SIMULATOR_ID, nil];

	return rv;
}

//*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	[HPLogger i:[NSString stringWithFormat:@"[prepareForSegue] sender: %@, destination: %@", sender, [segue destinationViewController]]];
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
//*/

#pragma mark - GADBannerViewDelegate

-(void)adViewDidReceiveAd:(GADBannerView *)view
{
	[HPInstrumentation logEvent:@"Ad_Success"];
}

-(void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error
{
	[HPInstrumentation logEvent:@"Ad_Failed" withParams:@{ @"error": error}];
}

#pragma mark --

@end
