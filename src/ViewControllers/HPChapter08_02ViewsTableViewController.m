//
//  HPChapter08_02ViewsTableViewController.m
//  HighPerformance
//
//  Created by Gaurav Vaish on 2/15/15.
//  Copyright (c) 2015 Gaurav Vaish. All rights reserved.
//

#import "HPChapter08_02ViewsTableViewController.h"
#import "HPChapter08_02Views_10CustomViewsTableViewController.h"
#import "HPLogger.h"
#import "HPInstrumentation.h"

@interface HPChapter08_02ViewsTableViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *viewNames;
@property (nonatomic, assign) long row;

@end

@implementation HPChapter08_02ViewsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

	self.viewNames = @[
		@"UILabel",
		@"UITableView",
		@"UIImageView",
		@"Custom View - Composite",
		@"Custom View - Direct Draw",
		@"Size Classes"
	];
	//[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"viewname"];
}

-(void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[HPInstrumentation logEvent:@"SCR_Views"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rv = self.viewNames.count;
	return rv;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *identifier = @"viewname";

	NSInteger index = indexPath.row;
	//NSLog(@"[cellForRowAtIndexPath] %@", indexPath);
	//UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"viewname" forIndexPath:indexPath];

	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if(cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
	}
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

	NSString *name = (NSString *)[self.viewNames objectAtIndex:index];
	cell.textLabel.text = name;

	if(indexPath.row % 2 == 0) {
		cell.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:1 alpha:1];
	} else {
		cell.backgroundColor = [UIColor whiteColor];
	}

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	self.row = indexPath.row;
	//NSLog(@"Selected: %ld", (long)indexPath.row);
	[tableView deselectRowAtIndexPath:indexPath animated:NO];

	switch(self.row) {
		case 3:
		case 4:
			[self performSegueWithIdentifier:@"ch_08_10_cpsv" sender:self];
			break;
		case 5:
			[self performSegueWithIdentifier:@"ch_08_15_scls" sender:self];
			break;
	}
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
	[HPLogger i:@"[shouldPerformSegue] i=%@", identifier];
	return YES;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	[HPLogger i:@"[prepareForSegue] i=%@, row=%d", segue.identifier, self.row];

	if(self.row == 3 || self.row == 4) {
		//NSLog(@"--> segue-class: %@", segue.destinationViewController);
		HPChapter08_02Views_10CustomViewsTableViewController *vc = segue.destinationViewController;
		if(self.row == 4) {
			vc.navigationItem.title = @"Direct Draw";
			vc.shouldUseDirect = (self.row == 4);
		}
	}
}

@end
