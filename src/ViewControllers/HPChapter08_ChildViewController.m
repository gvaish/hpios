//
//  HPChapter08_ChildViewController.m
//  HighPerformance
//
//  Created by Gaurav Vaish on 2/14/15.
//  Copyright (c) 2015 Gaurav Vaish. All rights reserved.
//

#import "HPChapter08_ChildViewController.h"
#import "HPInstrumentation.h"
#import "HPLogger.h"
#import "HPMeasurableView.h"

@interface HPChapter08_ChildViewController ()

@property (nonatomic, strong) UILabel *dynamicLabel;
@property (nonatomic, strong) IBOutlet HPMeasurableView *mview;

-(IBAction)addViewButtonWasClicked:(id)sender;

@end

@implementation HPChapter08_ChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	[self setEdgesForExtendedLayout:UIRectEdgeNone];
}

-(void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[HPInstrumentation logEvent:@"SCR_ViewController_Child"];
}

-(void)viewWillDisappear:(BOOL)animated {
	[HPLogger i:@"CVC::viewWillDisappear"];
	[super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(IBAction)addViewButtonWasClicked:(id)sender {
	CGRect frame = self.mview.frame;
	NSLog(@"Bounds: (%lf, %lf) - (%lf, %lf)", frame.origin.x, frame.origin.y, frame.size.width + frame.origin.x, frame.origin.y + frame.size.height);
	self.dynamicLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 200, 20)];
	self.dynamicLabel.text = [NSString stringWithFormat:@"Dynamic Label, will be removed after 1 sec."];
	self.dynamicLabel.numberOfLines = 0;
	[self.dynamicLabel sizeToFit];
	[self.mview addSubview:self.dynamicLabel];
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[self.dynamicLabel removeFromSuperview];
		self.dynamicLabel = nil;
	});
}

@end
