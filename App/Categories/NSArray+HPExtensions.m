//
//  NSArray+HPExtensions.m
//  HighPerformance
//
//  Created by Gaurav Vaish on 3/21/15.
//  Copyright (c) 2015 Gaurav Vaish. All rights reserved.
//

#import "NSArray+HPExtensions.h"
#import "NSItemProvider+HPExtension.h"
#import <Foundation/NSExtensionItem.h>

@implementation NSArray (HPExtensions)

-(NSString *)joinWithJoiner:(NSString *)joiner {
	NSUInteger count = self.count;
	NSMutableString *collector = [[NSMutableString alloc] init];
	for(NSUInteger index = 0; index < count; index++) {
		if(index != 0) {
			[collector appendString:joiner];
		} else {
			id item = [self objectAtIndex:index];
			if([item isKindOfClass:[NSArray class]]) {
				[collector appendString:[((NSArray *) item) joinWithJoiner:joiner]];
			} else {
				[collector appendFormat:@"%@", [self objectAtIndex:index]];
			}
		}
	};

	return [NSString stringWithString:collector];
}

-(NSString *)asClasses {
	NSMutableArray *clss = [NSMutableArray array];

	for(id item in self) {
		if([item isKindOfClass:[NSItemProvider class]]) {
			NSItemProvider *itemProvider = (NSItemProvider *)item;
			[clss addObject:[itemProvider.registeredTypeIdentifiers joinWithJoiner:@""]];
		} else {
			[clss addObject:[item class]];
		}
	}

	return [[NSArray arrayWithArray:clss] joinWithJoiner:@""] ;
}

-(NSArray *)nseiItems {
	NSMutableArray *items = [NSMutableArray array];

	for(id item in self) {
		if([item isKindOfClass:[NSExtensionItem class]]) {
			NSExtensionItem *extItem = (NSExtensionItem *)item;
			NSMutableString *entry = [[NSMutableString alloc] init];

			[entry appendString:@"{NSEI[at="];
			//[entry appendFormat:@"at=%@", [extItem.attachments asClasses]];
			//[entry appendString:@","];
			//[entry appendFormat:@"ui=%@", [extItem.userInfo.allKeys joinWithJoiner:@""]];
			NSArray *attachments = extItem.attachments;
			for(NSItemProvider *nsip in attachments) {
				[entry appendFormat:@"%@,", [nsip.registeredTypeIdentifiers joinWithJoiner:@""]];
			}

			[entry appendString:@"]}"];

			//[items addObject:[extItem.attachments asClasses]];
			[items addObject:entry];
		} else {
			[items addObject:[item description]];
		}
	}

	return [NSArray arrayWithArray:items];
}

@end
