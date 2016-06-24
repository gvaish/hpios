//
//  HPLocationManager.m
//  HighPerformance
//
//  Created by Gaurav Vaish on 9/27/14.
//  Copyright (c) 2014 Gaurav Vaish. All rights reserved.
//

#import "HPLocationManager.h"
#import "HPUtils.h"
#import "HPLogger.h"
#import "HPInstrumentation.h"

@interface HPLocationManager () <CLLocationManagerDelegate> {
	NSUInteger count;
}

@property (nonatomic, strong) CLLocationManager *manager;

@end

@implementation HPLocationManager

-(instancetype)init
{
	if(self = [super init]) {
		self->count = 0;
		self.manager = [[CLLocationManager alloc] init];
		self.manager.delegate = self;
	}
	return self;
}

+(HPLocationManager *)sharedInstance
{
	static HPLocationManager *instance;

	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		instance = [[HPLocationManager alloc] init];
	});
	return instance;
}

+(CLAuthorizationStatus)status
{
	return [CLLocationManager authorizationStatus];
}

+(BOOL)enabled
{
	return [CLLocationManager locationServicesEnabled];
}

#pragma mark - Permission Request

-(void)mayBeRequestForPermissions:(BOOL)background
{
	//CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
	//if([self.manager respondsToSelector:@selector(requestWhenInUseAuthorization:))

	if([HPUtils isIOS8]) {
		if(background) {
			[self.manager requestAlwaysAuthorization];
		} else {
			[self.manager requestWhenInUseAuthorization];
		}
	} else {
		[self startMonitor];
		[self stopMonitor];
	}
}

-(NSUInteger)totalLocationChanges {
	return self->count;
}

-(CLLocation *)latestLocation
{
	return self.manager.location;
}

#pragma mark - Lifecycle

-(void)startMonitor
{
	self.manager.distanceFilter = kCLDistanceFilterNone;
	self.manager.desiredAccuracy = kCLLocationAccuracyBest;
	[self.manager startUpdatingLocation];
	//[self.manager startMonitoringSignificantLocationChanges];
}

-(void)stopMonitor
{
	[self.manager stopUpdatingLocation];
}

#pragma mark - Location Manager Delegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
	self->count++;
	//[HPLogger i:[NSString stringWithFormat:@"locations: %@", locations]];
	CLLocation *loc = [locations lastObject];

	id<HPLocationManagerDelegate> dlg = self.delegate;
	if(dlg) {
		[dlg locationDidChange:self location:loc];
	}
}


@end




