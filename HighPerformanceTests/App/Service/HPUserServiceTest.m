//
//  HPUserServiceTest.m
//  HighPerformance
//
//  Created by Gaurav Vaish on 4/6/15.
//  Copyright (c) 2015 Gaurav Vaish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
//#import <OCMock/NSInvocation+OCMAdditions.h>
#import "../../../Pods/OCMock/Source/OCMock/NSInvocation+OCMAdditions.h"

#import "HPSyncService.h"
#import "HPUserService.h"
#import "HPUser.h"

@interface HPUserServiceTest : XCTestCase

@end

@implementation HPUserServiceTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testUserWithId_Completion {

	id ssvc = OCMClassMock([HPSyncService class]);
	//OCMStub([[ssvc class] sharedInstance]).andReturn(ssvc);
	[OCMStub([ssvc sharedInstance]) andReturn:ssvc];

	NSString *userId = @"id=1";
	NSString *fn = @"fn",
	 *ln = @"ln",
	 *g = @"gender";
	NSDate *dob = [NSDate date];

	[OCMStub([ssvc fetchType:OCMOCK_ANY withId:OCMOCK_ANY completion:OCMOCK_ANY]) andDo:^(NSInvocation *invocation) {
		NSLog(@"***** [HPUserServiceTest] mock fetch on HPSyncService called");

		NSMutableDictionary *collector = [NSMutableDictionary dictionary];
		[collector setObject:userId forKey:@"id"];
		[collector setObject:fn forKey:@"fname"];
		[collector setObject:ln forKey:@"lname"];
		[collector setObject:g forKey:@"gender"];
		[collector setObject:dob forKey:@"dob"];

		NSDictionary *data = [NSDictionary dictionaryWithDictionary:collector];

		//index0 -> ssvc, index1 -> _cmd, index2..index4: parameters (type, id, completion-block)
		id cb = [invocation getArgumentAtIndexAsObject:4];
		void (^callback)(NSDictionary *)  = cb;
		callback(data);
	}];

	HPUserService *svc = [HPUserService sharedInstance];

	[svc userWithId:userId completion:^(HPUser *user) {
		NSLog(@"**** [HPUserServiceTest] %s called with *** user = %@", __PRETTY_FUNCTION__, user);
		XCTAssert(user);
		XCTAssertEqualObjects(userId, user.userId);
		XCTAssertEqualObjects(fn, user.firstName);
		XCTAssertEqualObjects(ln, user.lastName);
		XCTAssertEqualObjects(g, user.gender);
		XCTAssertEqualObjects(dob, user.dateOfBirth);
	}];
	OCMVerify([ssvc sharedInstance]);
	OCMVerify([ssvc fetchType:@"user" withId:userId completion:[OCMArg any]]);
}

@end
