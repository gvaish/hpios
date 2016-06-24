//
//  HPAppDelegate.h
//  HighPerformance
//
//  Created by Gaurav Vaish on 8/17/14.
//  Copyright (c) 2014 Gaurav Vaish. All rights reserved.
//

#import <UIKit/UIKit.h>

extern CFAbsoluteTime startTime;

@interface HPAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, readonly) NSDictionary *launchOptions;
@property (nonatomic, readonly) UILocalNotification *localNotification;
@property (nonatomic, readonly) NSInteger stateWhenLocalNotificationReceived;

@end
