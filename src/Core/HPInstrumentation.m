//
//  HPIntrumenter.m
//  HighPerformance
//
//  Created by Gaurav Vaish on 8/17/14.
//  Copyright (c) 2014 Gaurav Vaish. All rights reserved.
//

#import "HPInstrumentation.h"
#import "Flurry.h"

@implementation HPInstrumentation

+(void)startWithAPIKey:(NSString *)apiKey
{
	[Flurry startSession:apiKey];
}

+(void)logEvent:(NSString *)name
{
	NSLog(@"<HPInst> %@", name);
	[Flurry logEvent:name];
}

+(void)logEvent:(NSString *)name withParams:(NSDictionary *)params
{
	NSLog(@"<HPInst> %@ -> %@", name, params);
	[Flurry logEvent:name withParameters:params];
}

+(void)logPageViewForTabBarController:(UITabBarController *)vc {
	NSLog(@"<HPInst> PV: %@", [vc class]);
	[Flurry logAllPageViewsForTarget:vc];
}

@end
