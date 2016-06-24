//
//  HPChapter04_LocationManagerViewController.m
//  HighPerformance
//
//  Created by Gaurav Vaish on 9/27/14.
//  Copyright (c) 2014 Gaurav Vaish. All rights reserved.
//

#import "HPChapter04_LocationManagerViewController.h"
#import "HPLogger.h"
#import "HPInstrumentation.h"
#import "HPLocationManager.h"
#import "HPUtils.h"

@interface HPChapter04_LocationManagerViewController () <UIAlertViewDelegate, HPLocationManagerDelegate>

-(void)startMonitor;
-(void)stopMonitor;

@end

@implementation HPChapter04_LocationManagerViewController

- (void)viewDidLoad {
	[super viewDidLoad];
}


-(void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[HPInstrumentation logEvent:@"SCR_Location"];

	CLAuthorizationStatus authStatus = [HPLocationManager status];
	switch (authStatus) {
	  case kCLAuthorizationStatusNotDetermined:
			self.currentStatus.text = @"NR";
			break;
		case kCLAuthorizationStatusRestricted:
			self.currentStatus.text = @"Restricted";
			break;
		case kCLAuthorizationStatusAuthorizedWhenInUse:
			self.currentStatus.text = @"Authz InUse :)";
			break;
		case kCLAuthorizationStatusAuthorizedAlways:
			if([HPUtils isIOS8]) {
				self.currentStatus.text = @"Authz Always :)";
			} else {
				self.currentStatus.text = @"Authz :)";
			}
			break;
		case kCLAuthorizationStatusDenied:
			self.currentStatus.text = @"Denied :(";
			break;
	}

	self.locationChangesCount.text = [NSString stringWithFormat:@"%lu", (unsigned long)([HPLocationManager sharedInstance].totalLocationChanges)];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

-(void)dealloc
{
	[self stopMonitor];
}

#pragma mark - Actions

-(void)permissionsTapped:(id)sender
{
	if([HPUtils isIOS8]) {
		[[[UIAlertView alloc] initWithTitle:@"" message:@"Request for background as well?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil] show];
	} else {
		[[HPLocationManager sharedInstance] mayBeRequestForPermissions:YES];
	}
}

-(void)trackLocationChanged:(id)sender
{
	//[HPLogger d:[NSString stringWithFormat:@"Track? %d", ((UISwitch *) sender).on]];
	UISwitch *lswitch = (UISwitch *)sender;

	if(lswitch.on) {
		if(![HPLocationManager enabled]) {
			//ouch. can't monitor
			lswitch.on = NO;
		} else {
			[self startMonitor];
		}
	} else {
		[self stopMonitor];
	}
}

-(void)printAccuracyLevelValues:(id)sender
{
	[HPLogger i:[NSString stringWithFormat:@"nav: %f", kCLLocationAccuracyBestForNavigation]];
	[HPLogger i:[NSString stringWithFormat:@"best: %f", kCLLocationAccuracyBest]];
	[HPLogger i:[NSString stringWithFormat:@"nav : %f", kCLLocationAccuracyNearestTenMeters]];
	[HPLogger i:[NSString stringWithFormat:@"100m: %f", kCLLocationAccuracyHundredMeters]];
	[HPLogger i:[NSString stringWithFormat:@"km  : %f", kCLLocationAccuracyKilometer]];
	[HPLogger i:[NSString stringWithFormat:@"3km : %f", kCLLocationAccuracyThreeKilometers]];
	[[[UIAlertView alloc] initWithTitle:@""
		message:@"See Log for accuracy level values" delegate:nil
		cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

-(void)startMonitor
{
	[HPLogger d:@"[startMonitor] called"];
	[HPLocationManager sharedInstance].delegate = self;
	[[HPLocationManager sharedInstance] startMonitor];
}

-(void)stopMonitor
{
	[HPLogger d:@"[stopMonitor] called"];
	[HPLocationManager sharedInstance].delegate = nil;
	[[HPLocationManager sharedInstance] stopMonitor];
}

#pragma mark - Location Manager Callbacks

-(void)locationDidChange:(HPLocationManager *)manager location:(CLLocation *)location
{
	NSMutableString *msg = [[NSMutableString alloc] init];

	[msg appendFormat:@"Latitude:  %+.5f\n", location.coordinate.latitude];
	[msg appendFormat:@"Longitute: %+.5f\n", location.coordinate.longitude];
	if(location.speed >= 0) {
		[msg appendFormat:@"Speed:     %0.2fmps\n", location.speed];
	} else {
		[msg appendString:@"Speed:     Invalid\n"];
	}
	if(location.horizontalAccuracy > 0) {
		[msg appendFormat:@"Accuracy:  %0.2fm\n", location.horizontalAccuracy];
	} else {
		[msg appendString:@"Accuracy:  Invalid\n"];
	}

	NSDate *ts = location.timestamp;
	NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
	[fmt setDateFormat:@"yyyy-MM-dd hh:mm a"];
	[msg appendFormat:@"Time:      %@\n", [fmt stringFromDate:ts]];

	NSTimeInterval staleness = abs([ts timeIntervalSinceNow]);
	[msg appendFormat:@"Old:       %lfs\n", staleness];

	self.resultLabel.text = msg;
	self.locationChangesCount.text = [NSString stringWithFormat:@"%lu", (unsigned long)([HPLocationManager sharedInstance].totalLocationChanges)];

	CLLocation *l = [[CLLocation alloc] initWithLatitude:-121.817413f longitude:37.297016f];
	CLLocationDistance distance = [location distanceFromLocation:l];
	distance = distance / 1000;

	self.distanceFromSoL.text = [NSString stringWithFormat:@"%.2lfkm", distance];
}

-(IBAction)openInMaps:(id)sender
{
	CLLocation *loc = [HPLocationManager sharedInstance].latestLocation;

	if(loc) {
		if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps-x-callback://"]]) {
			NSMutableString *urlValue = [[NSMutableString alloc]
											initWithString:@"comgooglemaps-x-callback://?x-source=HPerf+Apps&x-success=m10vhperf://&daddr=40.758895,-73.985131&saddr="];

			[urlValue appendFormat:@"%.f", loc.coordinate.latitude];
			[urlValue appendFormat:@","];
			[urlValue appendFormat:@"%.f", loc.coordinate.longitude];
			[HPLogger d:[NSString stringWithFormat:@"url: %@", urlValue]];
			NSURL *url = [NSURL URLWithString:urlValue];
			[[UIApplication sharedApplication] openURL:url];
		} else {
			[[[UIAlertView alloc]
			  initWithTitle:@"" message:@"Google Maps not found" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]
			 show];
		}
	}
}

#pragma mark - AlertView callbacks

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	switch(buttonIndex) {
		case 0:
			//No
			[[HPLocationManager sharedInstance] mayBeRequestForPermissions:NO];
			break;
		case 1:
			//Yes
			[[HPLocationManager sharedInstance] mayBeRequestForPermissions:YES];
			break;
	}
}

@end



