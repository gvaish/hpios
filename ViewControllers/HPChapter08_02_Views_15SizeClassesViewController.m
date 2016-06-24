//
//  HPChapter08_02_Views_15SizeClassesViewController.m
//  HighPerformance
//
//  Created by Gaurav Vaish on 2/19/15.
//  Copyright (c) 2015 Gaurav Vaish. All rights reserved.
//

#import "HPChapter08_02_Views_15SizeClassesViewController.h"
#import "HPLogger.h"
#import "HPInstrumentation.h"

@interface HPChapter08_02_Views_15SizeClassesViewController ()

@end

@implementation HPChapter08_02_Views_15SizeClassesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[HPInstrumentation logEvent:@"SCR_SizeClasses"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[HPLogger i:@"willAnimateRotationToInterfaceOrientation"];
	[super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	[super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

-(BOOL)shouldAutorotate {
	BOOL rv = [super shouldAutorotate];
	[HPLogger i:@"shouldAutorotate: %d", rv];
	return rv;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations {
	UIInterfaceOrientationMask rv = [super supportedInterfaceOrientations];
	[HPLogger i:@"supportedInterfaceOrientations: %d", rv];
	return rv;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
	UIInterfaceOrientation rv = [super preferredInterfaceOrientationForPresentation];
	[HPLogger i:@"preferredInterfaceOrientationForPresentation: %d", rv];
	return rv;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
