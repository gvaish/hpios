//
//  HPMailDirectDrawCell.h
//  HighPerformance
//
//  Created by Gaurav Vaish on 2/17/15.
//  Copyright (c) 2015 Gaurav Vaish. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HPMailDirectDrawCellStatus) {
	HPMailDirectDrawCellStatusUnread,
	HPMailDirectDrawCellStatusRead,
	HPMailDirectDrawCellStatusReplied
};

@interface HPMailDirectDrawCell : UITableViewCell

@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *subject;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *snippet;
@property (nonatomic, assign) HPMailDirectDrawCellStatus mailStatus;
@property (nonatomic, assign) BOOL hasAttachment;
@property (nonatomic, assign) BOOL isMailSelected;

@end
