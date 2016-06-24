//
//  HPShareActivityViewController.m
//  HighPerformance
//
//  Created by Gaurav Vaish on 3/19/15.
//  Copyright (c) 2015 Gaurav Vaish. All rights reserved.
//

#import "HPShareActivityViewController.h"
#import "HPLogger.h"
#import "HPInstrumentation.h"

@interface HPShareActivityViewController ()

@end

@implementation HPShareActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated {
	self.contentLabel.text = self.contentValue;
	[super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[HPInstrumentation logEvent:@"SCR_ShareVC"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(IBAction)onDoneButtonClick:(id)sender {
	[self.shareActivity activityDidFinish:YES];
}

@end
