//
//  HPLocationManager.h
//  HighPerformance
//
//  Created by Gaurav Vaish on 9/27/14.
//  Copyright (c) 2014 Gaurav Vaish. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreLocation;

@class HPLocationManager;

@protocol HPLocationManagerDelegate <NSObject>

@optional
-(void)locationDidChange:(HPLocationManager *)manager location:(CLLocation *)location;

@end

@interface HPLocationManager : NSObject

+(HPLocationManager *)sharedInstance;
+(CLAuthorizationStatus)status;
+(BOOL)enabled;

@property (nonatomic, weak) id<HPLocationManagerDelegate> delegate;

-(void)mayBeRequestForPermissions:(BOOL)background;
-(void)startMonitor;
-(void)stopMonitor;
-(NSUInteger)totalLocationChanges;
-(CLLocation *)latestLocation;

@end
