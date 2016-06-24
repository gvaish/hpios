//
//  HPChapterViewController.m
//  HighPerformance
//
//  Created by Gaurav Vaish on 8/23/14.
//  Copyright (c) 2014 Gaurav Vaish. All rights reserved.
//

#import "HPChapterViewController.h"
#import "HPLogger.h"
#import "HPInstrumentation.h"
#import "HPChapter03AllTableViewController.h"
#import "HPChapter08_01VCLifecycleViewController.h"

extern CFAbsoluteTime startTime;

@interface HPChapterViewController ()

@end

@implementation HPChapterViewController

NSArray *chapters;
NSArray *segues;

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
	chapters = [NSArray arrayWithObjects:
				//@"1: Setup",
				@"3: Lifetime Identifiers",
				@"3: Memory Management",
				@"4: CPU/Battery",
				@"4: Location Manager",
				@"4: Screen",
				@"5: Threads",
				@"6: App Delegate",
				@"7: View Controller",
				@"7: Views",
				@"7: iOS 8 Features",
				@"8: Data Sharing",
				@"12: Tools",
				nil];
	segues = [NSArray arrayWithObjects:
                //@"segue_ch01",
				@"segue_ch03_idents",
				@"segue_ch03_all",
				@"segue_ch04",
				@"segue_ch04_lm",
				@"seque_ch04_scr",
				@"segue_ch05_threads",
				@"segue_ch07_al_dlg",
			    @"segue_ch07_al_vc",
			    @"segue_ch08_views",
				@"segue_ch07_ios8_features",
			    @"segue_share_all",
			    @"segue_ch12_tools",
				nil];

	CFAbsoluteTime currentTime = CFAbsoluteTimeGetCurrent();
	CFTimeInterval timeTaken = currentTime - startTime;

	[HPLogger d:[NSString stringWithFormat:@"[ChapterVC::viewDidLoad] timeTaken: %lf", timeTaken]];

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNotificationReceived:) name:@"handleAction" object:nil];

	if(self.initialSegue) {
		[self performSegueWithIdentifier:self.initialSegue sender:self];
	}
}

-(void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[HPInstrumentation logEvent:@"Appear_Chxx"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *segue = [segues objectAtIndex:indexPath.row];
	[self performSegueWithIdentifier:segue sender:self];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return chapters.count;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//	
//}

//-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
//	CGPoint speed = [scrollView.panGestureRecognizer velocityInView:self.view];
//	[HPLogger d:@"did scroll, %lf --> %lf", scrollView.contentOffset.y, fabs(speed.y)];
//}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *identifier = @"hperf_chapter";

//	CGPoint speed = [tableView.panGestureRecognizer velocityInView:self.view];
//	[HPLogger i:@"velocity: %lf", speed.y];
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if(cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
	}
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	cell.textLabel.text = [chapters objectAtIndex:indexPath.row];

	if(indexPath.row % 2 == 0) {
		cell.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:1 alpha:1];
	} else {
		cell.backgroundColor = [UIColor whiteColor];
	}

	return cell;
}

//*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	UIViewController *vc = (UIViewController *) segue.destinationViewController;
	[HPLogger v:[NSString stringWithFormat:@"prepareForSegue[HPCVC] destination: ident=%@ cls=%@", segue.identifier, [vc class]]];

	if([vc isKindOfClass:[HPChapter08_01VCLifecycleViewController class]]) {
		HPChapter08_01VCLifecycleViewController *ch07 = (HPChapter08_01VCLifecycleViewController *)vc;
		[ch07 setMessage:@"Message from caller controller"];
	}

    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
//*/

-(void)onNotificationReceived:(NSNotification *)notification {
	[HPLogger i:@"[onNotificationReceived] notification -> %@", notification.object];
}

-(void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
