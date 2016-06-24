//
//  HPChapter17Tools_0LeaksViewController.m
//  HighPerformance
//
//  Created by Gaurav Vaish on 6/6/15.
//  Copyright (c) 2015 Gaurav Vaish. All rights reserved.
//

#import "HPChapter17Tools_03LeaksViewController.h"
#import "HPInstrumentation.h"
#import "HPLogger.h"

@class A;
@class B;

@interface A : NSObject
@property (nonatomic, strong) B* b;
@end

@implementation A

-(instancetype)init {
	self = [super init];
	[HPLogger d:@"%s %p", __PRETTY_FUNCTION__, self];
	return self;
}

-(void)dealloc {
	[HPLogger d:@"%s %p", __PRETTY_FUNCTION__, self];
}

@end

@interface B : NSObject
@property (nonatomic, strong) A* a;
@end

@implementation B

-(instancetype)init {
	self = [super init];
	[HPLogger d:@"%s %p", __PRETTY_FUNCTION__, self];
	return self;
}

-(void)dealloc {
	[HPLogger d:@"%s %p", __PRETTY_FUNCTION__, self];
}

@end

@interface HPChapter17Tools_03LeaksViewController ()

@property (nonatomic, strong) IBOutlet UILabel *statusLabel;
@property (nonatomic, strong) IBOutlet UIButton *leakButton;

-(IBAction)leakButtonClick:(id)sender;

@end

@implementation HPChapter17Tools_03LeaksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[HPInstrumentation logEvent:@"SCR_Tools_Leaks"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)leakButtonClick:(id)sender {
	for(int i = 0; i < 5; i++) {
		A *a = [[A alloc] init];
		B *b = [[B alloc] init];
		a.b = b;
		b.a = a;
	}
	self.statusLabel.text = @"10 objects have been leaked.\nLook at Leaks instruments for details.";
}

@end
