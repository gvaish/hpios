//
//  HPDebugLogViewController.m
//  HighPerformance
//
//  Created by Gaurav Vaish on 9/6/14.
//  Copyright (c) 2014 Gaurav Vaish. All rights reserved.
//

#import "HPDebugLogViewController.h"
#import "HPInstrumentation.h"
#import "HPLogger.h"

@interface HPDebugLogViewController ()

@end

@implementation HPDebugLogViewController

@synthesize logTextView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.title = @"Debug Log";
	UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithTitle:@"Refresh"
				style:UIBarButtonItemStylePlain target:self action:@selector(onRefreshClick:)];
	self.navigationItem.rightBarButtonItem = refreshButton;

	UIBarButtonItem *clearButton = [[UIBarButtonItem alloc] initWithTitle:@"Clear"
				style:UIBarButtonItemStylePlain target:self action:@selector(onClearClick:)];
	self.navigationItem.leftBarButtonItem = clearButton;
}

-(void)showUpdatedLogs
{
	NSArray *items = [HPLogger logs];

	NSString *value = [items componentsJoinedByString:@"\n"];
	NSMutableString *fvalue = [[NSMutableString alloc] initWithCapacity:(value.length + 3)];
	[fvalue appendString:value];
	[fvalue appendString:@"\n\n\n"];
	self.logTextView.text = fvalue;
}

-(void)onClearClick:(id)sender
{
	[HPInstrumentation logEvent:@"Log_Clear"];
	[HPLogger clearLogs];
	[self showUpdatedLogs];
}

-(void)onRefreshClick:(id)sender
{
	[HPInstrumentation logEvent:@"Log_Refresh"];
	[self showUpdatedLogs];
}

-(void)viewDidAppear:(BOOL)animated
{
	[HPInstrumentation logEvent:@"SCR_DebugLog"];
	[self showUpdatedLogs];
	[super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
