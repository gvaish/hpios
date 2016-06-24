//
//  HPPhotoTest.m
//  HighPerformance
//
//  Created by Gaurav Vaish on 4/4/15.
//  Copyright (c) 2015 Gaurav Vaish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "HPPhoto.h"
#import "HPAlbum.h"

@interface HPPhotoTest : XCTestCase

@end

@implementation HPPhotoTest

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testInitializer {
	HPPhoto *photo = [[HPPhoto alloc] init];
	XCTAssert(photo, @"Photo alloc-init failed");
}

- (void)testPropertySetters {
	HPPhoto *photo = [[HPPhoto alloc] init];
	photo.url = [NSURL URLWithString:@"http://www.m10v.com/url"];
	photo.title = @"Photo-Title";
	photo.comments = @[
		@"Comment-1",
		@"Comment-2"
	];

	HPAlbum *album = [[HPAlbum alloc] init];

	photo.album = album;
	
	//No Error! Good!
}


- (void)testPropertyGetters {
	HPPhoto *photo = [[HPPhoto alloc] init];
	NSURL *url = [NSURL URLWithString:@"http://www.m10v.com/url"];
	NSArray *comments = @[
		@"Comment-1",
		@"Comment-2"
	];
	photo.url = url;
	photo.title = @"Photo-Title";
	photo.comments = comments;

	HPAlbum *album = [[HPAlbum alloc] init];

	photo.album = album;

	XCTAssertEqualObjects(url, photo.url);
	XCTAssertEqualObjects(comments, photo.comments);
	XCTAssertEqualObjects(@"Photo-Title", photo.title);
	XCTAssertEqualObjects(album, photo.album);
}


@end
