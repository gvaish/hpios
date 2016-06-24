//
//  HPPhoto.m
//  HighPerformance
//
//  Created by Gaurav Vaish on 8/17/14.
//  Copyright (c) 2014 Gaurav Vaish. All rights reserved.
//

#import "HPPhoto.h"
#import "HPAlbum.h"
#import "HPLogger.h"

@implementation HPPhoto

@synthesize album;
@synthesize url;
@synthesize title;
@synthesize comments;

-(void) dealloc
{
	[HPLogger v:@"HPVPhoto dealloc-ed"];
}

@end
