//
//  HPLogger.m
//  HighPerformance
//
//  Created by Gaurav Vaish on 8/17/14.
//  Copyright (c) 2014 Gaurav Vaish. All rights reserved.
//

#import "HPLogger.h"
#import <PDDebugger.h>

const int HP_LOG_LEVEL_VERBOSE = 1;
const int HP_LOG_LEVEL_DEBUG = 2;
const int HP_LOG_LEVEL_INFO = 3;
const int HP_LOG_LEVEL_WARNING = 4;
const int HP_LOG_LEVEL_ERROR = 5;

@interface HPLogger ()

+(void)addToLog:(NSString *)message params:(va_list)args;

@end

@implementation HPLogger

static int _level = HP_LOG_LEVEL_VERBOSE;

+(int) logLevel
{
	@synchronized(self) {
		return _level;
	}
}

+(void) setLogLevel:(int) level
{
	@synchronized(self) {
		NSLog(@"New Log Level: %d", level);
		_level = level;
	}
}

+(void)v:(NSString *) message, ...
{
	if(_level <= HP_LOG_LEVEL_VERBOSE) {
		NSMutableString *format = [[NSMutableString alloc] init];
		[format appendString:@"[V] "];
		[format appendString:message];

		va_list args;
		va_start(args, message);
		[self addToLog:format params:args];
		va_end(args);
	}
}

+(void)d:(NSString *) message, ...
{
	if(_level <= HP_LOG_LEVEL_DEBUG) {
		NSMutableString *format = [[NSMutableString alloc] init];
		[format appendString:@"[D] "];
		[format appendString:message];
		
		va_list args;
		va_start(args, message);
		[self addToLog:format params:args];
		va_end(args);
	}
}

+(void)i:(NSString *) message, ...
{
	if(_level <= HP_LOG_LEVEL_INFO) {
		NSMutableString *format = [[NSMutableString alloc] init];
		[format appendString:@"[I] "];
		[format appendString:message];
		
		va_list args;
		va_start(args, message);
		[self addToLog:format params:args];
		va_end(args);
	}
}

+(void)w:(NSString *) message, ...
{
	if(_level <= HP_LOG_LEVEL_WARNING) {
		NSMutableString *format = [[NSMutableString alloc] init];
		[format appendString:@"[W] "];
		[format appendString:message];

		va_list args;
		va_start(args, message);
		[self addToLog:format params:args];
		va_end(args);
	}
}

+(void)e:(NSString *) message, ...
{
	if(_level <= HP_LOG_LEVEL_ERROR) {
		NSMutableString *format = [[NSMutableString alloc] init];
		[format appendString:@"[E] "];
		[format appendString:message];

		va_list args;
		va_start(args, message);
		[self addToLog:format params:args];
		va_end(args);
	}
}

+(NSArray *)logs
{
	static NSMutableArray *logs = nil;
	static dispatch_once_t token = 0;

	dispatch_once(&token, ^{
		logs = [[NSMutableArray alloc] init];
	});

	return logs;
}

+(void)addToLog:(NSString *)message params:(va_list)args;
{
	NSMutableArray *logs = (NSMutableArray *)[self logs];
	message = [[NSString alloc] initWithFormat:message arguments:args];
	[logs addObject:message];
	NSLog(@"%@", message);
	PDLog(@"%@", message);
}

+(void)clearLogs
{
	NSMutableArray *logs = (NSMutableArray *)[self logs];
	[logs removeAllObjects];
}

@end
