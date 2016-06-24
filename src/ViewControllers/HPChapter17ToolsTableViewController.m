//
//  HPChapter17ToolsTableViewController.m
//  HighPerformance
//
//  Created by Gaurav Vaish on 6/6/15.
//  Copyright (c) 2015 Gaurav Vaish. All rights reserved.
//

#import "HPChapter17ToolsTableViewController.h"
#import "HPInstrumentation.h"
#import "HPLogger.h"

@interface HPChapter17ToolsTableViewController ()

@property (nonatomic, strong) NSArray *viewNames;

@end

@implementation HPChapter17ToolsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

	self.viewNames = @[
//		@{
//			@"label": @"Instruments - Activity Monitor",
//			@"segue": @"segue_08_01_am"
//		},
		@{
			@"label": @"Instruments - Allocations",
			@"segue": @"segue_08_02_allocations"
		},
		@{
			@"label": @"Instruments - Leaks",
			@"segue": @"segue_08_03_leaks"
		},
		@{
			@"label": @"Instruments - Network",
			@"segue": @"segue_08_04_network"
		},
		@{
			@"label": @"Pony Debugger",
			@"segue": @"segue_17_05_pd"
		}
	];
}

-(void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[HPInstrumentation logEvent:@"SCR_Tools"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSInteger rows = self.viewNames.count;
	return rows;
}

//*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *identifier = @"instrument_name";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];

	if(!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
	}
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	NSDictionary *obj = (NSDictionary *)[self.viewNames objectAtIndex:indexPath.row];
	cell.textLabel.text = (NSString *) [obj objectForKey:@"label"];

	if(indexPath.row % 2 == 0) {
		cell.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:1 alpha:1];
	} else {
		cell.backgroundColor = [UIColor whiteColor];
	}

    return cell;
}
//*/

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:NO];

	NSDictionary *obj = (NSDictionary *)[self.viewNames objectAtIndex:indexPath.row];
	NSString *segue = (NSString *) [obj objectForKey:@"segue"];

	[self performSegueWithIdentifier:segue sender:self];
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
