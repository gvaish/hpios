//
//  HPConfigurationItemViewController.m
//  HighPerformance
//
//  Created by Gaurav Vaish on 3/21/15.
//  Copyright (c) 2015 Gaurav Vaish. All rights reserved.
//

#import "HPConfigurationItemViewController.h"

@interface HPConfigurationItemViewController ()

-(IBAction)onCloseClick:(id)sender;

@end

@implementation HPConfigurationItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)onCloseClick:(id)sender {
	if(self.closeHandler) {
		self.closeHandler();
	}
}

@end
