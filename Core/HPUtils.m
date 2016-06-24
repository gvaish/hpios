//
//  HPUtils.m
//  HighPerformance
//
//  Created by Gaurav Vaish on 9/27/14.
//  Copyright (c) 2014 Gaurav Vaish. All rights reserved.
//

#import "HPUtils.h"
#import <mach/mach_time.h>

@interface HPUtils ()

+(mach_timebase_info_data_t *)timeBaseInfoData;

@end

@implementation HPUtils

+(BOOL)isIOS8
{
	return SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0");
}


+(BOOL)canOpenSettings {
	//return (&UIApplicationOpenSettingsURLString != nil);
    //Always YES for iOS 8+
    return YES;
}

+(void)openSettings {
	if([self canOpenSettings]) {
		NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
		NSLog(@"[openSettings] %@", url);
		[[UIApplication sharedApplication] openURL:url];
	}
}

+(mach_timebase_info_data_t *)timeBaseInfoData {
	static mach_timebase_info_data_t info;
	static dispatch_once_t onceToken;

	dispatch_once(&onceToken, ^{
		mach_timebase_info(&info);
	});
	return &info;
}

+(uint64_t)timeBlock:(void (^)(void))block {
	uint64_t start = mach_absolute_time ();
	block ();
	uint64_t end = mach_absolute_time ();
	return [self nanosUsingStart:start end:end];
}

+(uint64_t)nanosUsingStart:(uint64_t)start end:(uint64_t)end {
	mach_timebase_info_data_t *info = [self timeBaseInfoData];

	uint64_t elapsed = end - start;
	uint64_t nanos = elapsed * info->numer / info->denom;
	return nanos;
}

@end
