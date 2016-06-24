//
//  HPIntrumenter.h
//  HighPerformance
//
//  Created by Gaurav Vaish on 8/17/14.
//  Copyright (c) 2014 Gaurav Vaish. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HPInstrumentation : NSObject

+(void)startWithAPIKey:(NSString *)apiKey;
+(void)logEvent:(NSString *)name;
+(void)logEvent:(NSString *)name withParams:(NSDictionary *)params;

+(void)logPageViewForTabBarController:(UITabBarController *)vc;

@end
