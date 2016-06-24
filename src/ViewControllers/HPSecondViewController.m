//
//  HPSecondViewController.m
//  HighPerformance
//
//  Created by Gaurav Vaish on 8/17/14.
//  Copyright (c) 2014 Gaurav Vaish. All rights reserved.
//

#import "HPSecondViewController.h"
#import "HPInstrumentation.h"

@interface HPSecondViewController ()

@end

@implementation HPSecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated
{
	[HPInstrumentation logEvent:@"SV_Appear_About"];
	[super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)onPrintClicked:(id)sender {
    [HPInstrumentation logEvent:@"Open_URL_Print"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://amzn.to/24NEg9f"]];
}

-(IBAction)onKindleClicked:(id)sender {
    [HPInstrumentation logEvent:@"Open_URL_Kindle"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://amzn.to/28Yl9He"]];
}

-(IBAction)onGithubClicked:(id)sender {
    [HPInstrumentation logEvent:@"Open_URL_Github"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://bit.ly/29619jR"]];
}

@end
