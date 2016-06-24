//
//  NSItemProvider+HPExtension.m
//  HighPerformance
//
//  Created by Gaurav Vaish on 3/21/15.
//  Copyright (c) 2015 Gaurav Vaish. All rights reserved.
//

#import "NSItemProvider+HPExtension.h"

@implementation NSItemProvider (HPExtension)

-(NSString *)summary {
	return [NSString stringWithFormat:@"%@", self.registeredTypeIdentifiers];
}

@end
