//
//  HPCacheTest.m
//  HighPerformance
//
//  Created by Gaurav Vaish on 4/4/15.
//  Copyright (c) 2015 Gaurav Vaish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "HPCache.h"

@interface HPCacheTest : XCTestCase

@end

@implementation HPCacheTest

- (void)setUp {
    [super setUp];
	//Give time for setup
	[NSThread sleepForTimeInterval:0.1];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testSharedInstance {
	HPCache *cache = [HPCache sharedInstance];
	XCTAssert(cache);
}

-(void)testSharedInstance_Same {
	HPCache *cache1 = [HPCache sharedInstance];
	HPCache *cache2 = [HPCache sharedInstance];

	XCTAssertEqualObjects(cache1, cache2);
}

-(void)testObjectForKey_NotAdded {
	HPCache *cache = [HPCache sharedInstance];
	id obj = [cache objectForKey:@"key-does-not-exist"];
	XCTAssertNil(obj);
}


-(void)testObjectForKey_Performance {
	HPCache *cache = [HPCache sharedInstance];

	[self measureBlock:^{
		id obj = [cache objectForKey:@"key-does-not-exist"];
		XCTAssertNil(obj);
	}];
}

@end
