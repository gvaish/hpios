//
//  HPChapter08_03InteractiveNotificationViewController.m
//  HighPerformance
//
//  Created by Gaurav Vaish on 2/21/15.
//  Copyright (c) 2015 Gaurav Vaish. All rights reserved.
//

#import "HPChapter08_03InteractiveNotificationViewController.h"
#import "HPLogger.h"
#import "HPInstrumentation.h"

@interface HPChapter08_03InteractiveNotificationViewController () <UIAlertViewDelegate>

-(IBAction)onQueueLocalNotification:(id)sender;
-(IBAction)onQueueRemoteNotification:(id)sender;

@end

@implementation HPChapter08_03InteractiveNotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[HPInstrumentation logEvent:@"SCR_InteractiveNotification"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(IBAction)onQueueLocalNotification:(id)sender {
	UIMutableUserNotificationAction *snooze = [[UIMutableUserNotificationAction alloc] init];
	snooze.activationMode = UIUserNotificationActivationModeBackground;
	//\U0001F44D == Like
	snooze.title = @"Snooze";
	snooze.identifier = @"snooze";
	snooze.destructive = NO;
	snooze.authenticationRequired = YES;

	UIMutableUserNotificationAction *complete = [[UIMutableUserNotificationAction alloc] init];
	complete.activationMode = UIUserNotificationActivationModeBackground;
	//\U0001F44D == Like
	complete.title = @"Complete";
	complete.identifier = @"complete";
	complete.destructive = NO;
	complete.authenticationRequired = YES;
	

	UIMutableUserNotificationCategory *category = [[UIMutableUserNotificationCategory alloc] init];
	category.identifier = @"inot-category";
	[category setActions:@[snooze, complete] forContext:UIUserNotificationActionContextDefault];

	NSSet *categories = [NSSet setWithObjects:category, nil];
	NSUInteger types = UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound;
	UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
	[[UIApplication sharedApplication] registerUserNotificationSettings:settings];

	NSDate *time = [NSDate date];
	UILocalNotification *lnoc = [[UILocalNotification alloc] init];
	lnoc.fireDate = [NSDate.date dateByAddingTimeInterval:5];
	lnoc.alertBody = [NSString stringWithFormat:@"Complete the book"];// -> %@", time];
	lnoc.alertAction = @"Reminder";
	lnoc.category = @"inot-category";
	lnoc.userInfo = @{
		@"Key1": @"Value1",
		@"Message": time.description
	};
	[[UIApplication sharedApplication] scheduleLocalNotification:lnoc];
}

-(IBAction)onQueueRemoteNotification:(id)sender {
	[[[UIAlertView alloc] initWithTitle:@"" message:@"Remote Notifications not implemented" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	//
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
