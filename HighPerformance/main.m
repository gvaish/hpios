//
//  main.m
//  HighPerformance
//
//  Created by Gaurav Vaish on 8/17/14.
//  Copyright (c) 2014 Gaurav Vaish. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HPAppDelegate.h"

CFAbsoluteTime startTime;

int main(int argc, char * argv[])
{
	startTime = CFAbsoluteTimeGetCurrent();
	@autoreleasepool {
	    return UIApplicationMain(argc, argv, nil, NSStringFromClass([HPAppDelegate class]));
	}
}
