//
//  HPChapter04_ScreenViewController.m
//  HighPerformance
//
//  Created by Gaurav Vaish on 9/28/14.
//  Copyright (c) 2014 Gaurav Vaish. All rights reserved.
//

#import "HPChapter04_ScreenViewController.h"
#import "HPInstrumentation.h"
#import "HPLogger.h"
#import "HPChapter04_Screen2ndViewController.h"

@interface HPChapter04_ScreenViewController ()

@property (nonatomic, strong) CABasicAnimation *rotateAnimation;
@property (nonatomic, assign) BOOL paused;

@property (nonatomic, strong) UIWindow *secondWindow;

-(void)screensChanged:(NSNotification *)n;
-(void)updateScreenCount;

-(void)appDidEnterBackground:(NSNotification *)n;
-(void)appDidBecomeActive:(NSNotification *)n;

-(void)startAnimation;
-(void)pauseAnimation;
-(void)resumeAnimation;
-(void)stopAnimation;

@end

@implementation HPChapter04_ScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	[[NSNotificationCenter defaultCenter] addObserver:self
					selector:@selector(screensChanged:) name:UIScreenDidConnectNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
					selector:@selector(screensChanged:) name:UIScreenDidDisconnectNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
					selector:@selector(appDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
	 				selector:@selector(appDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

-(void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[HPInstrumentation logEvent:@"SCR_04Screen"];

	[self updateScreenCount];
	[self updateScreens];
	[self stopAnimation];
	self.btnStart.enabled = YES;
	self.btnStop.enabled = NO;
	self.btnPauseResume.enabled = NO;
}

-(void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	if(self.secondWindow != nil) {
		self.secondWindow.hidden = YES;
		self.secondWindow = nil;
	}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)updateScreenCount
{
	NSArray *screens = [UIScreen screens];
	self.screenCountLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)screens.count];
}

#pragma mark - Tasks

-(void)startAnimation
{
	if(self.rotateAnimation == nil) {
		self.rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
		self.rotateAnimation.toValue = [NSNumber numberWithFloat:M_PI * 2];
		self.rotateAnimation.duration = 2;
		self.rotateAnimation.cumulative = YES;
		self.rotateAnimation.removedOnCompletion = NO;
		self.rotateAnimation.repeatCount = HUGE_VALF;

		[self.iv.layer addAnimation:self.rotateAnimation forKey:@"ra"];
		[self resumeAnimation];
	}
	self.btnStart.enabled = NO;
	self.btnStop.enabled = YES;
	self.btnPauseResume.enabled = YES;
	[self.btnPauseResume setTitle:@"Pause Animation" forState:UIControlStateNormal];
}

-(void)resumeAnimation
{
	CFTimeInterval pausedTime = self.iv.layer.timeOffset;
	self.iv.layer.speed = 1.0;
	self.iv.layer.timeOffset = 0;
	self.iv.layer.beginTime = 0;

	CFTimeInterval timeSincePause = [self.iv.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
	self.iv.layer.beginTime = timeSincePause;
	self.paused = NO;
	self.btnStart.enabled = NO;
	self.btnStop.enabled = YES;
	self.btnPauseResume.enabled = YES;
	[self.btnPauseResume setTitle:@"Pause Animation" forState:UIControlStateNormal];
}

-(void)pauseAnimation
{
	CFTimeInterval pausedTime = [self.iv.layer convertTime:CACurrentMediaTime() fromLayer:nil];
	self.iv.layer.speed = 0;
	self.iv.layer.timeOffset = pausedTime;
	self.paused = YES;

	self.btnStart.enabled = NO;
	self.btnStop.enabled = YES;
	self.btnPauseResume.enabled = YES;
	[self.btnPauseResume setTitle:@"Resume Animation" forState:UIControlStateNormal];
}

-(void)stopAnimation
{
	[self.iv.layer removeAnimationForKey:@"ra"];
	self.rotateAnimation = nil;

	self.btnStart.enabled = YES;
	self.btnStop.enabled = NO;
	self.btnPauseResume.enabled = NO;
	[self.btnPauseResume setTitle:@"Pause Animation" forState:UIControlStateNormal];
}

-(void)updateScreens
{
	NSArray *screens = [UIScreen screens];
	if(screens.count > 1) {
		UIScreen *secondScreen = (UIScreen *)[screens objectAtIndex:1];
		CGRect rect = secondScreen.bounds;
		if(self.secondWindow == nil) {
			self.secondWindow = [[UIWindow alloc] initWithFrame:rect];
			self.secondWindow.screen = secondScreen;

			HPChapter04_Screen2ndViewController *svc = [[HPChapter04_Screen2ndViewController alloc] init];
			self.secondWindow.rootViewController = svc;
		}
		self.secondWindow.hidden = NO;
	} else {
		if(self.secondWindow != nil) {
			self.secondWindow.hidden = YES;
			self.secondWindow = nil;
		}
	}
}

#pragma mark - Event Handlers

-(void)screensChanged:(NSNotification *)n
{
	[self updateScreenCount];
	[self updateScreens];
}

-(void)startAnimationTapped:(id)sender
{
	[HPLogger d:[NSString stringWithFormat:@"[startAnimationTapped] anim: %@", self.rotateAnimation]];
	[self startAnimation];
}

-(void)pauseResumeAnimationTapped:(id)sender
{
	if(self.paused) {
		[self resumeAnimation];
	} else {
		[self pauseAnimation];
	}
}

-(void)stopAnimationTapped:(id)sender
{
	[HPLogger d:[NSString stringWithFormat:@"[stopAnimationTapped] anim: %@", self.rotateAnimation]];
	[self stopAnimation];
}

-(void)appDidEnterBackground:(NSNotification *)n
{
	[HPLogger d:[NSString stringWithFormat:@"[appDidEnterBackground] anim: %@", self.rotateAnimation]];
	[self pauseAnimation];
}

-(void)appDidBecomeActive:(NSNotification *)n
{
	[HPLogger d:[NSString stringWithFormat:@"[appDidBecomeActive] anim: %@", self.rotateAnimation]];
	[self resumeAnimation];
}

#pragma mark - Cleanup

-(void)dealloc
{
	[self pauseAnimation];
	self.rotateAnimation = nil;
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
