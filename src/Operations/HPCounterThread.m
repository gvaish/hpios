//
//  HPCounterOperation.m
//  HighPerformance
//
//  Created by Gaurav Vaish on 1/11/15.
//  Copyright (c) 2015 Gaurav Vaish. All rights reserved.
//

#import "HPCounterThread.h"

@interface HPCounterThread ()

@property (nonatomic, readwrite, assign) BOOL stopRequested;

-(void)run;

@end

@implementation HPCounterThread

@synthesize stopRequested = _stopRequested;

-(instancetype)init {
	if(self = [super init]) {
		self.stopRequested = NO;
	}
	return self;
}

-(void)start {
	NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(run) object:nil];
	[thread start];
}

-(void)run {
	while(!self.stopRequested) {
		NSLog(@"[HPCounterThread::run] %@", [NSDate date]);
		[NSThread sleepForTimeInterval:2];
	}
}

-(void)stop {
	self.stopRequested = YES;
}

@end
