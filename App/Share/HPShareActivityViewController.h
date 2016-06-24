//
//  HPShareActivityViewController.h
//  HighPerformance
//
//  Created by Gaurav Vaish on 3/19/15.
//  Copyright (c) 2015 Gaurav Vaish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPShareActivity.h"

@interface HPShareActivityViewController : UIViewController

@property (nonatomic, strong) IBOutlet UILabel *contentLabel;
@property (nonatomic, strong) HPShareActivity *shareActivity;
@property (nonatomic, strong) NSString *contentValue;

@end
