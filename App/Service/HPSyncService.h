//
//  HPSyncService.h
//  HighPerformance
//
//  Created by Gaurav Vaish on 4/6/15.
//  Copyright (c) 2015 Gaurav Vaish. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HPSyncService : NSObject

+(instancetype)sharedInstance;

-(void)fetchType:(NSString *)type withId:(NSString *)itemId completion:(void(^)(NSDictionary *data))completion;

@end
