//
//  HPChapter03AllTableViewController.m
//  HighPerformance
//
//  Created by Gaurav Vaish on 9/1/14.
//  Copyright (c) 2014 Gaurav Vaish. All rights reserved.
//

#import "HPChapter03AllTableViewController.h"
#import "HPLogger.h"
#import "HPInstrumentation.h"
#import "HPChapter03ViewController.h"

extern CFAbsoluteTime startTime;

@interface HPChapter03AllTableViewController ()

@end

@implementation HPChapter03AllTableViewController

NSArray *sections;
NSArray *segues;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	sections = [NSArray arrayWithObjects:@"01: Blocks", nil];
	segues = [NSArray arrayWithObjects:@"segue_ch03_01", nil];

	CFAbsoluteTime currentTime = CFAbsoluteTimeGetCurrent();
	CFTimeInterval timeTaken = currentTime - startTime;

	[HPLogger d:[NSString stringWithFormat:@"[ChapterVC::viewDidLoad] timeTaken: %lf", timeTaken]];
}

-(void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[HPInstrumentation logEvent:@"Appear_Ch03All"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return sections.count;
}

//*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *identifier = @"hperf_ch03";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if(cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
	}
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	cell.textLabel.text = [sections objectAtIndex:indexPath.row];
	return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	//[self performSegueWithIdentifier:[segues objectAtIndex:indexPath.row] sender:self];
	[HPLogger d:[NSString stringWithFormat:@"[didSelectRowAtIndexPath] called with indexPath.row=%ld", (long)indexPath.row]];
	//[self.navigationController performSegueWithIdentifier:[segues objectAtIndex:indexPath.row] sender:self];
	HPChapter03ViewController *vc = [[HPChapter03ViewController alloc] init];
	[self.navigationController pushViewController:vc animated:NO];
}
//*/

//*
#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	[HPLogger i:[NSString stringWithFormat:@"prepareForSegue[HPCVC] -> %@", segue.destinationViewController]];
	[HPLogger i:[NSString stringWithFormat:@"prepareForSegue[HPCVC] -> %@", segue.identifier]];
}
//*/

@end
