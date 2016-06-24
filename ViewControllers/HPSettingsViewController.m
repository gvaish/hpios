//
//  HPSettingsViewController.m
//  HighPerformance
//
//  Created by Gaurav Vaish on 2/7/15.
//  Copyright (c) 2015 Gaurav Vaish. All rights reserved.
//

#import "HPSettingsViewController.h"
#import "HPUtils.h"
#import "HPInstrumentation.h"

@interface HPSettingsViewController ()

@end

@implementation HPSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	[self.showSettingsBtn setTitle:@"Can't open settings directly" forState:UIControlStateDisabled];
	self.showSettingsBtn.enabled = [HPUtils canOpenSettings];
}

-(void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[HPInstrumentation logEvent:@"SCR_Settings"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(IBAction)showSettingsTapped:(id)sender {
	[HPUtils openSettings];
}

-(IBAction)resetNotificationBadgeClicked:(id)sender {
	[UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

@end
