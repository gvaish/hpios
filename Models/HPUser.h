//
//  HPUser.h
//  HighPerformance
//
//  Created by Gaurav Vaish on 4/6/15.
//  Copyright (c) 2015 Gaurav Vaish. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HPUser : NSObject

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, copy) NSDate *dateOfBirth;
@property (nonatomic, strong) NSArray *albums;

@end
