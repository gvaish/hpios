//
//  HPAppDelegate.m
//  HighPerformance
//
//  Created by Gaurav Vaish on 8/17/14.
//  Copyright (c) 2014 Gaurav Vaish. All rights reserved.
//

#import "HPAppDelegate.h"
#import "HPConstants.h"
#import "HPInstrumentation.h"
#import "HPLogger.h"
#import "HPMainTabBarViewController.h"
#import "HPCounterThread.h"

#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "HPChapterViewController.h"

#import <PonyDebugger/PonyDebugger.h>

@interface HPAppDelegate ()

//Copy is the better option. but "I know what I am doing", so - strong is good enough.
@property (nonatomic, strong) NSDictionary *launchOptions;
@property (nonatomic, strong) UILocalNotification *localNotification;
@property (nonatomic, assign) NSInteger stateWhenLocalNotificationReceived;


@end

@implementation HPAppDelegate

#pragma mark - Properties

#pragma mark - Standard Callbacks

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	[HPLogger w:@"[%s] called, lo=%@", __PRETTY_FUNCTION__, launchOptions];
	self.launchOptions = launchOptions;
	self.stateWhenLocalNotificationReceived = -1;

	[self configurePonyDebugger];

	//[Flurry setCrashReportingEnabled:NO];
	[Crashlytics startWithAPIKey:kHPKeyCrashlytics];
	[Fabric with:@[CrashlyticsKit]];
	[HPInstrumentation startWithAPIKey:kHPKeyFlurry];

	[HPLogger d:[NSString stringWithFormat:@"rootViewController: %@", self.window.rootViewController]];

	HPMainTabBarViewController *rvc = (HPMainTabBarViewController *) self.window.rootViewController;

	NSArray *vcs = rvc.viewControllers;
	HPChapterViewController *hpcvc = [((UINavigationController *)[vcs objectAtIndex:0]).viewControllers objectAtIndex:0];
	if([launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey] != nil) {
		hpcvc.initialSegue = @"segue_ch07_al_dlg";
	}

	UITabBar *bar = rvc.tabBar;

	UITabBarItem *home = [bar.items objectAtIndex:0];
	home.image = [[UIImage imageNamed:@"home"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
	home.selectedImage = [[UIImage imageNamed:@"home_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

	UITabBarItem *debug = [bar.items objectAtIndex:1];
	debug.image = [[UIImage imageNamed:@"debug"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
	debug.selectedImage = [[UIImage imageNamed:@"debug_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

	UITabBarItem *settings = [bar.items objectAtIndex:2];
	settings.image = [[UIImage imageNamed:@"settings"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
	settings.selectedImage = [[UIImage imageNamed:@"settings_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

	UITabBarItem *bolt = [bar.items objectAtIndex:3];
	bolt.image = [[UIImage imageNamed:@"bolt"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
	bolt.selectedImage = [[UIImage imageNamed:@"bolt_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

	CFAbsoluteTime currentTime = CFAbsoluteTimeGetCurrent();
	CFTimeInterval timeTaken = currentTime - startTime;

	[HPLogger d:[NSString stringWithFormat:@"[AppDelegate::didFinishLWO] timeTaken: %lf", timeTaken]];
	[application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];

	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(defaultsChanged:)
												 name:NSUserDefaultsDidChangeNotification
											   object:nil];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	[HPLogger w:@"[applicationWillResignActive] called"];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	[HPLogger w:@"[applicationDidEnterBackground] called"];
	[HPInstrumentation logEvent:@"App_Background"];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	[HPLogger w:@"[applicationWillEnterForeground] called"];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	[HPLogger w:@"[applicationDidBecomeActive] called"];
	[HPInstrumentation logEvent:@"App_Activate"];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	[HPLogger w:@"[applicationWillTerminate] called"];
}

-(void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
	[HPLogger w:@"[applicationDidReceiveMemoryWarning] called"];
	[HPInstrumentation logEvent:@"App_MemWarn"];
}

#pragma mark - Extra Delegate Lifecycle Events

-(BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	[HPLogger w:@"[willFinishLaunchingWithOptions] called"];
	return YES;
}

-(BOOL)application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder
{
	[HPLogger w:@"[shouldSaveApplicationState] called"];
	[coder encodeInt:1 forKey:@"HPState"];
	return YES;
}

-(BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder
{
	[HPLogger w:@"[shouldRestoreApplicationState] called"];
	NSInteger hpstate = [coder decodeIntegerForKey:@"HPState"];
	[HPLogger d:[NSString stringWithFormat:@"hpstate: %ld", (long) hpstate]];
	return YES;
}

-(void)application:(UIApplication *)application didDecodeRestorableStateWithCoder:(NSCoder *)coder
{
	[HPLogger w:@"[didDecodeRestorableStateWithCoder] called"];
}

-(void)application:(UIApplication *)application willEncodeRestorableStateWithCoder:(NSCoder *)coder
{
	[HPLogger w:@"[willEncodeRestorableStateWithCoder] called"];
}

-(void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
	[HPLogger w:@"[performFetchWithCompletionHandler] called"];
	[HPInstrumentation logEvent:@"App_Fetch"];
	completionHandler(UIBackgroundFetchResultNoData);
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
	[HPLogger w:[NSString stringWithFormat:@"[openURL] src: %@, url: %@", sourceApplication, url]];
	if(!sourceApplication) {
		sourceApplication = @"(null)";
	}
	NSDictionary *params = @{
		@"url": [NSString stringWithFormat:@"%@", url],
		@"src": sourceApplication
	};
	[HPInstrumentation logEvent:@"App_OpenURL" withParams:params];
	return YES;
}

-(void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler
{
	completionHandler();
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
	[HPLogger i:[NSString stringWithFormat:@"%s -> %@, state: %d",
				  __PRETTY_FUNCTION__,
				  notification.userInfo,
				  (int) application.applicationState
				]
	];
	self.localNotification = notification;
	self.stateWhenLocalNotificationReceived = application.applicationState;

	//[application applicationState] == UIApplicationStateActive

	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:[notification.userInfo objectForKey:@"Message"] forKey:@"lastLocalNotification"];
	[defaults synchronize];
	//int minLevel = (int) [defaults integerForKey:@"minBatteryLevel"];
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
	[HPLogger i:@"didReceiveRemoteNotification: %@", userInfo];
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
	[HPLogger i:@"didReceiveRemoteNotification:fetchCompletionHandler: %@", userInfo];
	completionHandler(UIBackgroundFetchResultNewData);
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
	[HPLogger i:@"deviceToken: %@", deviceToken];
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
	[HPLogger w:@"Remote Notification Reg Failed: %@", error];
}

-(void)defaultsChanged:(NSNotification *)notification {
	//[HPLogger d:@"Defaults Changed"];
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSInteger level = [defaults integerForKey:@"logLevel"];
	[HPLogger setLogLevel:(int)level];
}

-(void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler {
	[HPLogger w:@"[handleAction] for local notification, ident=%@", identifier];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"handleAction" object:notification];
	self.localNotification = notification;
	self.stateWhenLocalNotificationReceived = application.applicationState;
	completionHandler();
}

-(void)configurePonyDebugger {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	BOOL enabled =[defaults boolForKey:@"pdEnabled"];
	if(enabled) {
		//NSURL *url = [defaults URLForKey:@"pdURL"];
		NSString *urlValue = [defaults stringForKey:@"pdURL"];
		NSURL *url = [NSURL URLWithString:urlValue];
		NSLog(@"Connecting to PD at: %@ <-> %@", url, urlValue);
		if(url) {
			PDDebugger *debugger = [PDDebugger defaultInstance];
			[debugger connectToURL:url];

			if([defaults boolForKey:@"pdNetwork"]) {
				[debugger enableNetworkTrafficDebugging];
				[debugger forwardAllNetworkTraffic];
			}
			if([defaults boolForKey:@"pdCoreData"]) {
				[debugger enableCoreDataDebugging];
			}
			if([defaults boolForKey:@"pdViewHierarchy"]) {
				[debugger enableViewHierarchyDebugging];
			}
			if([defaults boolForKey:@"pdRemoteLogging"]) {
				[debugger enableRemoteLogging];
			}
		}
	}
}

@end



