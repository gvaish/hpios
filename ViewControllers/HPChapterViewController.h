//
//  HPChapterViewController.h
//  HighPerformance
//
//  Created by Gaurav Vaish on 8/23/14.
//  Copyright (c) 2014 Gaurav Vaish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HPChapterViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSString *initialSegue;

@end
