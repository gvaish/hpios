//
//  HPLogger.h
//  HighPerformance
//
//  Created by Gaurav Vaish on 8/17/14.
//  Copyright (c) 2014 Gaurav Vaish. All rights reserved.
//

#import <Foundation/Foundation.h>

extern const int HP_LOG_LEVEL_VERBOSE;
extern const int HP_LOG_LEVEL_DEBUG;
extern const int HP_LOG_LEVEL_INFO;
extern const int HP_LOG_LEVEL_WARNING;
extern const int HP_LOG_LEVEL_ERROR;

@interface HPLogger : NSObject

+(int) logLevel;
+(void) setLogLevel:(int) level;

+(void)v:(NSString *) format, ...;
+(void)d:(NSString *) format, ...;
+(void)i:(NSString *) format, ...;
+(void)w:(NSString *) format, ...;
+(void)e:(NSString *) format, ...;

+(NSArray *)logs;
+(void)clearLogs;

@end
