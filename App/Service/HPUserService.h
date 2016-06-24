//
//  HPUserService.h
//  HighPerformance
//
//  Created by Gaurav Vaish on 4/6/15.
//  Copyright (c) 2015 Gaurav Vaish. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HPUser;

@interface HPUserService : NSObject

+(instancetype)sharedInstance;

-(void)userWithId:(NSString *)userId completion:(void(^)(HPUser *))completion;

@end
