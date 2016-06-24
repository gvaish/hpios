//
//  HPChapter03_02BlocksViewController.m
//  HighPerformance
//
//  Created by Gaurav Vaish on 9/1/14.
//  Copyright (c) 2014 Gaurav Vaish. All rights reserved.
//

#import "HPChapter03_02BlocksViewController.h"
#import "HPLogger.h"
#import "HPInstrumentation.h"
#import "HPFriendsUpdateOp.h"

//Class HPFriendsListViewController in the book
@interface HPChapter03_02BlocksViewController ()

@property (nonatomic, strong) HPFriendsUpdateOp *updateOp;

-(void)onFriendsAvailable;

@end

@implementation HPChapter03_02BlocksViewController

@synthesize resultLabel;

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
}

-(void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[HPInstrumentation logEvent:@"Appear_Ch03_02"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

//#if !__has_feature(objc_arc)
//-(id) retain
//{
//	[HPLogger d:[[NSString alloc] initWithFormat:@"[retain] %@", [NSThread callStackSymbols]]];
//	return [super retain];
//}
//#endif

-(IBAction)onBlocksUsingLocalVariable:(id)sender
{
	[HPLogger d:@"[onRefreshClicked] enter"];
	self.updateOp = [[HPFriendsUpdateOp alloc] init];
	[self.updateOp startUsingDelegate:self withSelector:@selector(onFriendsAvailable)];
	[HPLogger d:@"[onRefreshClicked] exit"];
}

-(void)onFriendsAvailable
{
	[HPLogger d:@"[onFriendsAvailable] called"];
	self.resultLabel.text = @"[onFriendsAvailable] called";
	self.updateOp = nil;
}

-(void)dealloc
{
	[HPLogger d:@"[HPFriendsListViewController::dealloc] called"];
	if(self.updateOp != nil) {
		[self.updateOp cancel];
	}
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
