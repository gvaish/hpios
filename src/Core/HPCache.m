//
//  HPCache.m
//  HighPerformance
//
//  Created by Gaurav Vaish on 12/14/14.
//  Copyright (c) 2014 Gaurav Vaish. All rights reserved.
//

#import "HPCache.h"

static const char* const kCacheQueueName = "com.m10v.hperf.cache.queue";

@interface HPCache ()

@property (nonatomic, readonly) NSMutableDictionary *cacheObjects;
@property (nonatomic, readonly) dispatch_queue_t queue;

@end


@implementation HPCache

-(instancetype)init {
	if(self = [super init]) {
		_cacheObjects = [NSMutableDictionary dictionary];
		_queue = dispatch_queue_create(kCacheQueueName, DISPATCH_QUEUE_CONCURRENT);
	}
	return self;
}

+(HPCache *)sharedInstance {
	static HPCache *instance = nil;

	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		instance = [[HPCache alloc] init];
	});
	return instance;
}


-(void)setObject:(id)object forKey:(id<NSCopying>)key {
	dispatch_barrier_async(self.queue, ^{
		[self.cacheObjects setObject:object forKey:key];
	});
}

-(id)objectForKey:(id<NSCopying>)key {
	__block id rv = nil;

	dispatch_sync(self.queue, ^{
		[NSThread sleepForTimeInterval:0.01];
		rv = [self.cacheObjects objectForKey:key];
	});

	return rv;
}

-(void)clear {
	dispatch_sync(self.queue, ^{
		[self.cacheObjects removeAllObjects];
	});
}

-(id)removeObjectForKey:(id<NSCopying>)key {
	__block id rv = nil;

	dispatch_sync(self.queue, ^{
		rv = [self.cacheObjects objectForKey:key];
		[self.cacheObjects removeObjectForKey:key];
	});
	return rv;
}

@end




