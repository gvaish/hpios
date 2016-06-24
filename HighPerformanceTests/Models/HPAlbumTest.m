//
//  HPAlbumTest.m
//  HighPerformance
//
//  Created by Gaurav Vaish on 4/4/15.
//  Copyright (c) 2015 Gaurav Vaish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#define EXP_SHORTHAND
#import <Expecta/Expecta.h>

#import "HPAlbum.h"
#import "HPPhoto.h"

@interface HPAlbumTest : XCTestCase

@end

@implementation HPAlbumTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInitializer {
	HPAlbum *album = [[HPAlbum alloc] init];
	XCTAssert(album, @"Album alloc-init failed");
}

- (void)testPropertySetters {
	HPAlbum *album = [[HPAlbum alloc] init];
	album.name = @"Album-1";
	album.creationTime = [NSDate date];

	HPPhoto *coverPhoto = [[HPPhoto alloc] init];
	coverPhoto.album = album;

	album.coverPhoto = coverPhoto;
	album.photos = @[coverPhoto];

	//No Error! Good!
}


- (void)testPropertyGetters {
	HPAlbum *album = [[HPAlbum alloc] init];
	album.name = @"Album-1";
	NSDate *ctime = [NSDate date];
	album.creationTime = ctime;

	HPPhoto *coverPhoto = [[HPPhoto alloc] init];
	coverPhoto.album = album;

	album.coverPhoto = coverPhoto;
	NSArray *photos = @[coverPhoto];
	album.photos = photos;

	XCTAssertEqualObjects(@"Album-1", album.name);

	XCTAssertEqualObjects(ctime, album.creationTime);
	XCTAssertEqualObjects(coverPhoto, album.coverPhoto);
	XCTAssertEqualObjects(photos, album.photos);
}

@end


