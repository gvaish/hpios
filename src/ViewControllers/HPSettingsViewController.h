//
//  HPSettingsViewController.h
//  HighPerformance
//
//  Created by Gaurav Vaish on 2/7/15.
//  Copyright (c) 2015 Gaurav Vaish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HPSettingsViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIButton *showSettingsBtn;

-(IBAction)showSettingsTapped:(id)sender;
-(IBAction)resetNotificationBadgeClicked:(id)sender;

@end
