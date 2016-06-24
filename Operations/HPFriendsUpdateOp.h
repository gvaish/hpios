//
//  HPFriendsUpdateOp.h
//  HighPerformance
//
//  Created by Gaurav Vaish on 9/1/14.
//  Copyright (c) 2014 Gaurav Vaish. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HPFriendsUpdateOp : NSObject

-(void)startUsingDelegate:(id)delegate withSelector:(SEL)selector;
-(void)cancel;

@end
