//
//  HPChapter05ViewController.m
//  HighPerformance
//
//  Created by Gaurav Vaish on 10/12/14.
//  Copyright (c) 2014 Gaurav Vaish. All rights reserved.
//

#import "HPChapter05ViewController.h"
#import "HPInstrumentation.h"
#import "HPLogger.h"
#import "HPUtils.h"
#import <mach/mach.h>

@interface HPCreationTime : NSObject

@property (nonatomic, assign) uint64_t start;
@property (nonatomic, assign) uint64_t enter;
@property (nonatomic, assign) uint64_t time;

@end


@implementation HPCreationTime

@end


@interface HPChapter05ViewController ()

-(uint64_t)timeThreadCreation:(NSUInteger) count;
-(void)timeThreadCreationStart:(id)object;
-(void)threadStartMethod:(id)object;

@property (nonatomic, assign) BOOL canGoBack;
@property (nonatomic, assign) SEL defAction;
@property (nonatomic, copy) id defTarget;

@property (nonatomic, strong) NSMutableArray *times;

-(IBAction)backButtonPressed:(id)sender;


-(void)enableOrDisableButtons:(BOOL)enable;

@end

@implementation HPChapter05ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)backButtonPressed:(id)sender
{
	[HPLogger i:@"[backButtonPressed] called"];
	[self.navigationController popViewControllerAnimated:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[HPInstrumentation logEvent:@"SCR_Chapter05"];
	self.canGoBack = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = event.allTouches.anyObject;
	if(self.tccTextField.isFirstResponder && touch.view != self.tccTextField) {
		[self.tccTextField resignFirstResponder];
	}
	[super touchesBegan:touches withEvent:event];
}

-(void)enableOrDisableButtons:(BOOL)enable
{
	self.tcButton.enabled = enable;
	self.atomicButton.enabled = enable;
	self.nonatomicButton.enabled = enable;
	self.navigationItem.hidesBackButton = !enable;
}

-(void)computeAtomicPropertySetTime:(id)sender
{
	NSString *text = self.tccTextField.text;
	NSInteger count = text.integerValue;

	if(count <= 0) {
		self.tctLabel.text = @"Invalid thread count";
	} else {
		[self enableOrDisableButtons:NO];
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
			NSString *obj = @"Value to set";
			uint64_t totalTime = [HPUtils timeBlock:^{
				for(NSInteger i = 0; i < count; i++) {
					self.atomicProperty = obj;
				}
			}];
			dispatch_async(dispatch_get_main_queue(), ^{
				self.tctLabel.text = [NSString stringWithFormat:@"Atomic Property Setter - %f nanos", (totalTime * 1.0)/count];
				[self enableOrDisableButtons:YES];
			});
		});
	}
}

-(void)computeNonAtomicPropertySetTime:(id)sender
{
	NSString *text = self.tccTextField.text;
	NSInteger count = text.integerValue;

	if(count <= 0) {
		self.tctLabel.text = @"Invalid thread count";
	} else {
		[self enableOrDisableButtons:NO];
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
			NSString *obj = @"Value to set";
			uint64_t totalTime = [HPUtils timeBlock:^{
				for(NSInteger i = 0; i < count; i++) {
					self.atomicProperty = obj;
				}
			}];
			dispatch_async(dispatch_get_main_queue(), ^{
				self.tctLabel.text = [NSString stringWithFormat:@"Non-Atomic Property - %lf nanos", (totalTime * 1.0)/count];
				[self enableOrDisableButtons:YES];
			});
		});
	}
}

-(void)computeThreadCreationTime:(id)sender
{
	NSString *text = self.tccTextField.text;
	NSInteger count = text.integerValue;

	if(count <= 0) {
		self.tctLabel.text = @"Invalid thread count";
	} else {
		//[self.tccTextField resignFirstResponder];
		self.tctLabel.text = @"Computing... ";
		NSNumber *n = [NSNumber numberWithUnsignedInteger:(NSUInteger)count];
		[[[NSThread alloc] initWithTarget:self selector:@selector(timeThreadCreationStart:) object:n] start];
	}
}

-(void)timeThreadCreationStart:(id)object
{
	[HPLogger i:@"[timeThreadCreationStart] started"];

	dispatch_async(dispatch_get_main_queue(), ^{
		[self enableOrDisableButtons:NO];
	});

	NSUInteger count = [((NSNumber *) object) unsignedIntegerValue];
	//[NSThread sleepForTimeInterval:0.01];
	uint64_t average = [self timeThreadCreation:(NSUInteger)count];

	//[NSThread sleepForTimeInterval:1.0];
	uint64_t total = 0;
	uint64_t averageExec = 0;
	uint64_t minExec = 0x7ffffff;
	uint64_t maxExec = 0;

	for(NSUInteger i = 0; i < count; i++) {
		HPCreationTime *ct = (HPCreationTime *)[self.times objectAtIndex:i];
		total += ct.time;
		maxExec = MAX(maxExec, ct.time);
		minExec = MIN(minExec, ct.time);
	}
	averageExec = total / count;

	dispatch_async(dispatch_get_main_queue(), ^{
//		self.tctLabel.text = [NSString
//				stringWithFormat:@"Average Creation: %llu µsec\nAverage Execution: %llu µsec\nMin Exec: %llu\nMax Exec: %llu",
//				average, averageExec,
//				minExec, maxExec];
		self.tctLabel.text = [NSString stringWithFormat:@"Average Creation: %llu µsec", average];
		[self enableOrDisableButtons:YES];
	});
	[HPLogger i:@"[timeThreadCreationStart] done"];
}

-(uint64_t)timeThreadCreation:(NSUInteger)count
{
	uint64_t start_64;
	uint64_t end_64;
	uint64_t time_64;
	uint64_t total_64 = 0;
	uint64_t average_64 = 0;

	NSMutableArray *threads = [[NSMutableArray alloc] initWithCapacity:count];
	self.times = [[NSMutableArray alloc] initWithCapacity:count];
	HPCreationTime *ct;

	for(NSUInteger i = 0; i < count; i++) {

		dispatch_async(dispatch_get_main_queue(), ^{
			self.tctLabel.text = [NSString stringWithFormat:@"Created thread: %lu/%lu", (i+1), count];
		});

		ct = [[HPCreationTime alloc] init];
		[self.times addObject:ct];

		start_64 = mach_absolute_time();
		NSThread *t = [[NSThread alloc] initWithTarget:self selector:@selector(threadStartMethod:) object:ct];
		end_64 = mach_absolute_time();
		ct.start = mach_absolute_time();
		//[t start];
		time_64 = [HPUtils nanosUsingStart:start_64 end:end_64];//end_64 - start_64;
		[HPLogger i:[NSString stringWithFormat:@"Time taken for thread creation: %llu", time_64]];
		total_64 += time_64;
		[threads addObject:t];
		//[NSThread sleepForTimeInterval:0.01];
	}

	average_64 = total_64 / count;

	return average_64;
}

-(void)threadStartMethod:(id)object
{
	uint64_t enter_64 = mach_absolute_time();
	HPCreationTime *ct = (HPCreationTime *)object;
	ct.enter = enter_64;
	ct.time = ct.enter - ct.start;
	[HPLogger i:[NSString stringWithFormat:@"[threadStartMethod] called: %llu %llu", ct.start, ct.time]];
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
