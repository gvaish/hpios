//
//  HPUserService.m
//  HighPerformance
//
//  Created by Gaurav Vaish on 4/6/15.
//  Copyright (c) 2015 Gaurav Vaish. All rights reserved.
//

#import "HPUserService.h"
#import "HPSyncService.h"
#import "HPUser.h"

@implementation HPUserService

+(instancetype)sharedInstance {
	static dispatch_once_t onceToken;
	static HPUserService *svc = nil;
	dispatch_once(&onceToken, ^{
		svc = [[HPUserService alloc] init];
	});
	return svc;
}

-(void)userWithId:(NSString *)userId completion:(void (^)(HPUser *))completion {

	HPSyncService *ssvc = [HPSyncService sharedInstance];
	[ssvc fetchType:@"user" withId:userId completion:^(NSDictionary *data) {
		//TODO: use HPUserBuilder
		HPUser *userFromServer = [[HPUser alloc] init];
		userFromServer.userId = [data objectForKey:@"id"];
		userFromServer.firstName = [data objectForKey:@"fname"];
		userFromServer.lastName = [data objectForKey:@"lname"];
		userFromServer.gender = [data objectForKey:@"gender"];
		userFromServer.dateOfBirth = [data objectForKey:@"dob"];

		completion(userFromServer);
	}];
}

@end
