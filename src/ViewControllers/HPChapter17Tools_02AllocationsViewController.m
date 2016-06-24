//
//  HPChapter17Tools_02AllocationsViewController.m
//  HighPerformance
//
//  Created by Gaurav Vaish on 6/6/15.
//  Copyright (c) 2015 Gaurav Vaish. All rights reserved.
//

#import "HPChapter17Tools_02AllocationsViewController.h"
#import "HPCache.h"
#import "HPInstrumentation.h"

@interface TrashCan : NSObject

@property (nonatomic, strong) NSMutableArray *trash;

@end

@implementation TrashCan

-(instancetype)init {
	if(self = [super init]) {
		self.trash = [NSMutableArray array];
		for(int i = 0; i < 1024 * 1024; i++) {
			[self.trash addObject:[NSNumber numberWithInt:i]];
		}
	}
	return self;
}

@end

@interface HPChapter17Tools_02AllocationsViewController ()

-(IBAction)addToCacheClicked:(id)sender;
-(IBAction)clearCacheEntries:(id)sender;

@end

@implementation HPChapter17Tools_02AllocationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[HPInstrumentation logEvent:@"SCR_Tools_Allocations"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(IBAction)addToCacheClicked:(id)sender {
	[HPInstrumentation logEvent:@"Tap_TA_ATC"];
	HPCache *cache = [HPCache sharedInstance];
	id obj = [cache objectForKey:@"tools_abandoned"];
	NSMutableArray *items;
	if(!obj) {
		items = [NSMutableArray array];
		[cache setObject:items forKey:@"tools_abandoned"];
	} else {
		items = (NSMutableArray *)obj;
	}
	[items addObject:[[TrashCan alloc] init]];
}

-(void)clearCacheEntries:(id)sender {
	[[HPCache sharedInstance] removeObjectForKey:@"tools_abandoned"];
}

@end
