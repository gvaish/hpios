//
//  HPChapter08_02Views_10CustomViewsTableViewController.m
//  HighPerformance
//
//  Created by Gaurav Vaish on 2/16/15.
//  Copyright (c) 2015 Gaurav Vaish. All rights reserved.
//

#import "HPChapter08_02Views_10CustomViewsTableViewController.h"
#import "HPMailCompositeCell.h"
#import "HPUtils.h"
#import "HPLogger.h"
#import "HPInstrumentation.h"
#import "HPMailDirectDrawCell.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface HPChapter08_02Views_10CustomViewsTableViewController ()

@end

@implementation HPChapter08_02Views_10CustomViewsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

	UINib *nib = [UINib nibWithNibName:@"HPMailCompositeCell" bundle:nil];
	[self.tableView registerNib:nib forCellReuseIdentifier:@"mailcomposite"];
	//[self.tableView registerClass:[HPMailCompositeCell class] forCellReuseIdentifier:@"mailcomposite"];
	[self.tableView registerClass:[HPMailDirectDrawCell class] forCellReuseIdentifier:@"maildirect"];
}

-(void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	if(!self.shouldUseDirect) {
		[HPInstrumentation logEvent:@"SCR_Views_Custom_Composite"];
	} else {
		[HPInstrumentation logEvent:@"SCR_Views_Custom_Direct"];
	}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 64;
}

//*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	uint64_t nanotime = 0;
	UITableViewCell *rvCell = nil;
	long row = (long)indexPath.row;
	u_int32_t rnd = arc4random();
	NSString *email = [NSString stringWithFormat:@"Email-%ld@domain.com", row];;
	NSString *subject = [NSString stringWithFormat:@"Subject- %ld", row];
	NSString *snippet = [NSString stringWithFormat:@"Content Snippet %ld%d", row, rnd];

	if(!self.shouldUseDirect) {
		__block HPMailCompositeCell *cell = nil;
		nanotime = [HPUtils timeBlock:^{
			cell = (HPMailCompositeCell *)[tableView dequeueReusableCellWithIdentifier:@"mailcomposite"];
			cell.emailLabel.text = email;
			cell.subjectLabel.text = subject;
			cell.snippetLabel.text = snippet;
		}];
		rvCell = cell;
	} else {
		__block HPMailDirectDrawCell *cell = nil;
		nanotime = [HPUtils timeBlock:^{
			cell = (HPMailDirectDrawCell *) [tableView dequeueReusableCellWithIdentifier:@"maildirect"];
			cell.email = email;
			cell.subject = subject;
			cell.snippet = snippet;
			cell.date = @"Yesterday";
			cell.hasAttachment = ((rnd % 2) == 0);
			cell.mailStatus = (HPMailDirectDrawCellStatus)(indexPath.row % 3);
		}];
		rvCell = cell;
	}

	[HPLogger i:@"[cell %ld]: Time=%ld ns", row, nanotime];
	return rvCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
}
//*/


@end
