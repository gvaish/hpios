//
//  HPConfigurationItemViewController.h
//  HighPerformance
//
//  Created by Gaurav Vaish on 3/21/15.
//  Copyright (c) 2015 Gaurav Vaish. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^HPConfigurationItemViewControllerCallback)(void);

@interface HPConfigurationItemViewController : UIViewController

@property (nonatomic, copy) HPConfigurationItemViewControllerCallback closeHandler;

@end
