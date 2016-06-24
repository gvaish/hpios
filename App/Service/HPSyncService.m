//
//  HPSyncService.m
//  HighPerformance
//
//  Created by Gaurav Vaish on 4/6/15.
//  Copyright (c) 2015 Gaurav Vaish. All rights reserved.
//

#import "HPSyncService.h"

@implementation HPSyncService

+(instancetype)sharedInstance {
	static dispatch_once_t onceToken;
	static HPSyncService *svc = nil;
	dispatch_once(&onceToken, ^{
		svc = [[HPSyncService alloc] init];
	});
	return svc;
}

-(void)fetchType:(NSString *)type withId:(NSString *)itemId completion:(void (^)(NSDictionary *))completion {
	NSLog(@"***** [HPSyncService] %s called", __PRETTY_FUNCTION__);

	if([@"user" isEqualToString:type]) {
		//Ok. In real app, this will connect to the server and get details
		NSMutableDictionary *collector = [NSMutableDictionary dictionary];
		[collector setObject:itemId forKey:@"id"];
		[collector setObject:[NSString stringWithFormat:@"fname-%@", itemId] forKey:@"fname"];
		[collector setObject:[NSString stringWithFormat:@"lname-%@", itemId] forKey:@"lname"];
		[collector setObject:[NSString stringWithFormat:@"gender-%@", itemId] forKey:@"gender"];
		[collector setObject:[NSDate date] forKey:@"dob"];

		NSDictionary *data = [NSDictionary dictionaryWithDictionary:collector];
		completion(data);
	} else {
		completion(nil);
	}
}

@end
