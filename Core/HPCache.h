//
//  HPCache.h
//  HighPerformance
//
//  Created by Gaurav Vaish on 12/14/14.
//  Copyright (c) 2014 Gaurav Vaish. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HPCache : NSObject

+(HPCache *)sharedInstance;

-(id)objectForKey:(id<NSCopying>)key;
-(void)setObject:(id)object forKey:(id<NSCopying>)key;
-(id)removeObjectForKey:(id<NSCopying>)key;

-(void)clear;

@end
