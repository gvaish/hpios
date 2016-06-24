//
//  HPChapter07AL_01DelegateViewController.m
//  HighPerformance
//
//  Created by Gaurav Vaish on 1/15/15.
//  Copyright (c) 2015 Gaurav Vaish. All rights reserved.
//

#import "HPChapter07AL_01DelegateViewController.h"
#import "HPAppDelegate.h"
#import "HPInstrumentation.h"
#import "HPLogger.h"

@interface HPChapter07AL_01DelegateViewController ()

@property (nonatomic, strong) IBOutlet UILabel *permStatusLabel;
@property (nonatomic, strong) IBOutlet UILabel *resultLabel;

-(IBAction)onSendLocalNotificationClick:(id)sender;
-(IBAction)onRequestPermissionClick:(id)sender;
-(IBAction)onScheduleRemoteNotificationClick:(id)sender;

-(void)updateNotification;
-(void)onRefreshClicked:(id)sender;

@end

@implementation HPChapter07AL_01DelegateViewController
-(void)viewDidLoad {
	[super viewDidLoad];
	[HPLogger i:@"%s", __PRETTY_FUNCTION__];

	UIApplication *app = [UIApplication sharedApplication];
	NSString *perms = @"Not required";
	if([app respondsToSelector:@selector(currentUserNotificationSettings)]) {
		UIUserNotificationSettings *settings = [app currentUserNotificationSettings];
		UIUserNotificationType types = settings.types;
		if(types == UIUserNotificationTypeNone) {
			perms = @"No Perms :(";
		} else {
			perms = @"Have perms :)";
		}
	}
	self.permStatusLabel.text = perms;

	UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithTitle:@"Refresh"
			style:UIBarButtonItemStylePlain target:self action:@selector(onRefreshClicked:)];
	self.navigationItem.rightBarButtonItem = refreshButton;
}


-(void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[HPLogger i:@"%s", __PRETTY_FUNCTION__];

	[HPInstrumentation logEvent:@"SCR_AppDlg"];

	[self updateNotification];
}

-(IBAction)onSendLocalNotificationClick:(id)sender {
	NSDate *time = [NSDate date];
	UILocalNotification *n = [[UILocalNotification alloc] init];
	n.fireDate = [NSDate.date dateByAddingTimeInterval:5];
	n.alertBody = [NSString stringWithFormat:@"Local Notification -> %@", time];
	n.applicationIconBadgeNumber = 1;
	n.soundName = UILocalNotificationDefaultSoundName;
	n.userInfo = @{
		@"Key1": @"Value1",
		@"Message": time.description
	};

	[[UIApplication sharedApplication] scheduleLocalNotification:n];
}

-(IBAction)onRequestPermissionClick:(id)sender {
    //Code-path no longer applicable for iOS8+
	//if([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
		UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
		UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
		[[UIApplication sharedApplication] registerUserNotificationSettings:settings];
		[[UIApplication sharedApplication] registerForRemoteNotifications];
//	} else {
//		if([UIApplication instancesRespondToSelector:@selector(registerForRemoteNotificationTypes:)]) {
//			[[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge)];
//		}
//	}
}

-(IBAction)onScheduleRemoteNotificationClick:(id)sender {
	[[[UIAlertView alloc] initWithTitle:@"" message:@"Remote Notifications not available" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
}

-(void)updateNotification {
	HPAppDelegate *dlg = (HPAppDelegate *)[UIApplication sharedApplication].delegate;
	NSMutableString *msg = [[NSMutableString alloc] init];
	[msg appendFormat:@"State: %ld\nLocal Notification:\n", (long) dlg.stateWhenLocalNotificationReceived];

	if(dlg.localNotification) {
		UILocalNotification *n = dlg.localNotification;
		[msg appendFormat:@"drln: %@", n.userInfo];
		[UIApplication sharedApplication].applicationIconBadgeNumber = 0;
	}
	if(dlg.launchOptions) {
		NSDictionary *opts = dlg.launchOptions;
		id notObj = [opts objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
		if(notObj != nil) {
			UILocalNotification *n = (UILocalNotification *)notObj;
			[msg appendFormat:@"lwo: %@", n.userInfo];
			[UIApplication sharedApplication].applicationIconBadgeNumber = 0;
		}
	}

	self.resultLabel.text = msg;
}

-(void)onRefreshClicked:(id)sender {
	[HPInstrumentation logEvent:@"AppDlg_Refresh"];

	[self updateNotification];
}

@end
