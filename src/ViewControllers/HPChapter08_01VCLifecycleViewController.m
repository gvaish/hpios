//
//  HPChapter07_VCLifecycleViewController.m
//  HighPerformance
//
//  Created by Gaurav Vaish on 2/11/15.
//  Copyright (c) 2015 Gaurav Vaish. All rights reserved.
//

#import "HPChapter08_01VCLifecycleViewController.h"
#import "HPInstrumentation.h"
#import "HPLogger.h"
#import "HPUtils.h"
#import "HPChapter08_ChildViewController.h"

@interface HPChapter08_01VCLifecycleViewController ()

@property (nonatomic, strong) IBOutlet UILabel *instructionsLabel;
@property (nonatomic, strong) IBOutlet UILabel *resultLabel;

-(void)onRefreshClicked:(id)sender;
-(void)updateUIUsingData;

@property (nonatomic, strong) NSDate *timeEnterInitWithCoder;

@end

@implementation HPChapter08_01VCLifecycleViewController

@synthesize message = _message;

-(id)initWithCoder:(NSCoder *)aDecoder {
	self.timeEnterInitWithCoder = [NSDate date];
	self = [super initWithCoder:aDecoder];
	NSDate *stopDate = [NSDate date];
	[HPLogger i:@"[VC::initWithCoder]: %llf", [stopDate timeIntervalSinceDate:self.timeEnterInitWithCoder]];
	return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
	NSDate *stopDate = [NSDate date];
	[HPLogger i:@"[VC::p:viewDidLoad]: %llf", [stopDate timeIntervalSinceDate:self.timeEnterInitWithCoder]];

	UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithTitle:@"Refresh"
			style:UIBarButtonItemStylePlain target:self action:@selector(onRefreshClicked:)];
	self.navigationItem.rightBarButtonItem = refreshButton;

	self.instructionsLabel.numberOfLines = 0;
	[self.instructionsLabel sizeToFit];

	[self updateUIUsingData];

	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	int delay = (int) [defaults integerForKey:@"vcDelay"];
	if(delay > 0) {
		[NSThread sleepForTimeInterval:delay];
	}
	stopDate = [NSDate date];
	[HPLogger i:@"[VC::viewDidLoad]: %llf", [stopDate timeIntervalSinceDate:self.timeEnterInitWithCoder]];
}

-(void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    self.navigationItem.title = @"View Controller";
	NSDate *stopDate = [NSDate date];
	[HPLogger i:@"[VC::viewWillAppear]: %llf", [stopDate timeIntervalSinceDate:self.timeEnterInitWithCoder]];
}

-(void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	NSDate *stopDate = [NSDate date];
	[HPLogger i:@"[VC::viewDidAppear]: %llf", [stopDate timeIntervalSinceDate:self.timeEnterInitWithCoder]];
	[HPInstrumentation logEvent:@"SCR_ViewController"];
}

-(void)viewWillDisappear:(BOOL)animated {
	NSInteger index = [self.navigationController.viewControllers indexOfObject:self];
	[HPLogger i:@"VC::viewWillDisappear, %@", (index == NSNotFound) ? @"Pop": @"Push"];
	[super viewWillDisappear:animated];
}

-(void)viewDidDisappear:(BOOL)animated {
	[HPLogger i:@"VC::viewDidDisappear"];
	[super viewDidDisappear:animated];
}

-(void)onRefreshClicked:(id)sender {
	[HPInstrumentation logEvent:@"VCLC_Refresh"];

	[self updateUIUsingData];
}

-(void)setMessage:(NSString *)message {
	[HPLogger i:@"[VC::setMessage]"];
	_message = message;
	[self updateUIUsingData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)updateUIUsingData {
	if(self.isViewLoaded && self.message.length > 0) {
		self.resultLabel.text = self.message;
	}
}

-(IBAction)childViewControllerWasTapped:(id)sender {
	HPChapter08_ChildViewController *child = [[HPChapter08_ChildViewController alloc] init];
	child.navigationItem.title = @"Child";
    self.navigationItem.title = @"Back";
    [self.navigationController pushViewController:child animated:YES];
	//[self.navigationController showViewController:controller sender:self];
}

@end
