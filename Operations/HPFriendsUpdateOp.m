//
//  HPFriendsUpdateOp.m
//  HighPerformance
//
//  Created by Gaurav Vaish on 9/1/14.
//  Copyright (c) 2014 Gaurav Vaish. All rights reserved.
//

#import "HPFriendsUpdateOp.h"
#import "HPLogger.h"

@interface HPFriendsUpdateOp ()

@property (nonatomic, readonly) NSObject *syncObject;
@property (nonatomic, weak) id delegate;
@property (nonatomic, assign) SEL selector;

@end

@implementation HPFriendsUpdateOp

@synthesize syncObject = _syncObject;

-(id)init
{
	self = [super init];
	if(self) {
		self->_syncObject = [[NSObject alloc] init];
	}
	return self;
}

//Initial code using parameters
//-(void)startUsingDelegate:(id)delegate withSelector:(SEL)selector
//{
//	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//		//just doing a delay
//		[NSThread sleepForTimeInterval:2.0];
//		dispatch_async(dispatch_get_main_queue(), ^{
//			if([delegate respondsToSelector:selector]) {
//				[delegate performSelector:selector];
//			} else {
//				[HPLogger d:@"[FriendsUpdateOp::start] [dispatch_async::main] delegate does not respond to selector"];
//			}
//		});
//	});
//}

-(void)startUsingDelegate:(id)delegate withSelector:(SEL)selector
{
	self.delegate = delegate;
	self.selector = selector;
	
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		//just doing a delay
		[NSThread sleepForTimeInterval:2.0];
		dispatch_async(dispatch_get_main_queue(), ^{
			@synchronized(self.syncObject) {
				if(self.delegate == nil) {
					[HPLogger d:@"[FriendsUpdateOp::start] [dispatch_async::main] delegate is nil"];
					return;
				}
				id delegate = self.delegate;
				SEL selector = self.selector;
				if([delegate respondsToSelector:selector]) {
					[delegate performSelector:selector];
				} else {
					[HPLogger d:@"[FriendsUpdateOp::start] [dispatch_async::main] delegate does not respond to selector"];
				}
			}
		});
	});
}

-(void)cancel
{
	@synchronized(self.syncObject) {
		self.delegate = nil;
		self.selector = nil;
	}
}

-(void)dealloc
{
	[HPLogger d:@"[FriendsUpdateOp::dealloc] called"];
}

@end
