//
//  HPChapter04ViewController.m
//  HighPerformance
//
//  Created by Gaurav Vaish on 9/14/14.
//  Copyright (c) 2014 Gaurav Vaish. All rights reserved.
//

#import "HPChapter04ViewController.h"
#import "HPInstrumentation.h"
#import "HPLogger.h"

#import <mach/mach.h>
#import <sys/sysctl.h>
#import <sys/types.h>
#import <sys/param.h>
#import <sys/mount.h>

@interface HPChapter04ViewController ()

@property (nonatomic, strong) IBOutlet UIButton *btnIntensiveOperation;

-(void)onRefreshClick:(id)sender;
-(void)computeAndRefresh;
-(NSArray *)cpuUsage;
-(float)appCPUUsage;
-(BOOL)shouldProceedWithMinLevel:(int)minLevel;

-(void)batteryStateOrLevelChanged;

-(void)cpuIntensiveOperation;

@end

@implementation HPChapter04ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

	UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithTitle:@"Refresh"
			style:UIBarButtonItemStylePlain target:self action:@selector(onRefreshClick:)];
	self.navigationItem.rightBarButtonItem = refreshButton;
}

-(void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[HPInstrumentation logEvent:@"Appear_Ch04" withParams:@{
		@"action": @"view"
	}];
	[self computeAndRefresh];
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	[center addObserver:self selector:@selector(batteryStateOrLevelChanged) name:UIDeviceBatteryLevelDidChangeNotification object:nil];
	[center addObserver:self selector:@selector(batteryStateOrLevelChanged) name:UIDeviceBatteryStateDidChangeNotification object:nil];
}

-(void)batteryStateOrLevelChanged
{
	[self computeAndRefresh];
}

-(void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	[center removeObserver:self name:UIDeviceBatteryLevelDidChangeNotification object:nil];
	[center removeObserver:self name:UIDeviceBatteryStateDidChangeNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)onRefreshClick:(id)sender
{
	[HPLogger d:@"[HPCh04VC:refreshClick] called"];
	self.batteryState.text = @"Loading...";
	self.batteryLevel.text = @"Loading...";
	[self computeAndRefresh];
}

-(IBAction)doIntensiveOperation:(id)sender
{
	[HPInstrumentation logEvent:@"Action_Intensive"];
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	BOOL prompt = [defaults boolForKey:@"promptForBattery"];
	int minLevel = (int) [defaults integerForKey:@"minBatteryLevel"];

	BOOL canAutoProceed = [self shouldProceedWithMinLevel:minLevel];
	if(canAutoProceed == YES) {
		self.result.text = @"Will compute";
		__weak HPChapter04ViewController *wself = self;
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
			HPChapter04ViewController *sself = wself;
			if(sself) {
				dispatch_async(dispatch_get_main_queue(), ^{
					sself.btnIntensiveOperation.enabled = NO;
				});
				[sself cpuIntensiveOperation];
				dispatch_async(dispatch_get_main_queue(), ^{
					sself.btnIntensiveOperation.enabled = YES;
				});
			}
		});
	} else {
		if(prompt == YES) {
			UIAlertView *promptView = [[UIAlertView alloc] initWithTitle:@"Proceed"
					message:@"Battery level is below minimum required. Proceed?"
					delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
			[promptView show];
		} else {
			self.result.text = @"Not enough battery";
		}
	}
}

-(void)cpuIntensiveOperation {
	double x = 0;
	for(int i = 0; i < 5000000; i++) {
		x = sqrt(pow(sin(i), 2) + pow(cos(i), 2));
	}
	NSLog(@"[cpuIntensiveOperation] x: %lf", x);
}

-(BOOL)shouldProceedWithMinLevel:(int)minLevel
{
	UIDevice *device = [UIDevice currentDevice];
	device.batteryMonitoringEnabled = YES;

	UIDeviceBatteryState state = device.batteryState;
	if(state == UIDeviceBatteryStateCharging || state == UIDeviceBatteryStateFull) {
		return YES;
	}

	int batteryLevel = (int) (device.batteryLevel * 100);
	if(batteryLevel >= minLevel) {
		return YES;
	}
	return NO;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(buttonIndex == 0) {
		self.result.text = @"Will not compute";
	} else {
		self.result.text = @"Will compute, you forced";
	}
}

-(void)computeAndRefresh
{
	UIDevice *device = [UIDevice currentDevice];
	device.batteryMonitoringEnabled = YES;

	float batteryLevel = device.batteryLevel;
	self.batteryLevel.text = [NSString stringWithFormat:@"~%d%%", (int)(batteryLevel * 100)];

	UIDeviceBatteryState state = device.batteryState;
	NSString *stateValue = @"<unknown>";
	switch(state) {
		case UIDeviceBatteryStateCharging:
			stateValue = @"Charging";
			break;
		case UIDeviceBatteryStateUnplugged:
			stateValue = @"Unplugged";
			break;
		case UIDeviceBatteryStateFull:
			stateValue = @"Full";
			self.batteryLevel.text = @"Full";
			break;
		case UIDeviceBatteryStateUnknown:
			stateValue = @"Unknown";
			break;
	}
	self.batteryState.text = stateValue;

	host_basic_info_data_t hostInfo;
	mach_msg_type_number_t infoCount;

	infoCount = HOST_BASIC_INFO_COUNT;
	host_info(mach_host_self(), HOST_BASIC_INFO, (host_info_t) &hostInfo, &infoCount);

	int coreCount = hostInfo.max_cpus;
	uint64_t maxMemory = hostInfo.max_mem;

	self.coreCount.text = [NSString stringWithFormat:@"%d", coreCount];
	self.maxMemory.text = [NSString stringWithFormat:@"%.2fM", (maxMemory * 1.0f / (1024 * 1024))];

	task_basic_info_data_t info;
	mach_msg_type_number_t size = sizeof(info);
	kern_return_t kerr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)&info, &size);
	self.memoryConsumed.text = [NSString stringWithFormat:@"%.2fM", ((kerr == KERN_SUCCESS) ? (info.resident_size * 1.0f/(1024*1024)) : 0)];

	self.cpuStatus.text = [self.cpuUsage componentsJoinedByString:@","];

	self.appCPUStatus.text = [NSString stringWithFormat:@"%.2f%%", self.appCPUUsage];
}

-(NSArray *)cpuUsage
{
	NSMutableArray *rv = [[NSMutableArray alloc] init];
	processor_info_array_t cpuInfo = NULL;
	mach_msg_type_number_t numCPUInfo = 0;

	NSUInteger numCPUs = [NSProcessInfo processInfo].processorCount;

	natural_t nCPUs = 0;
	kern_return_t kerr = host_processor_info(mach_host_self(), PROCESSOR_CPU_LOAD_INFO, &nCPUs, &cpuInfo, &numCPUInfo);

	if(kerr == KERN_SUCCESS) {
		for(NSUInteger i = 0; i < numCPUs; i++) {
			float inUse, total;
			inUse = cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER]
				+ cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM]
				+ cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE];
			total = inUse + cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE];

			[rv addObject:[NSString stringWithFormat:@"%.2f%%", inUse / total * 100.0f]];
		}
	}

	return rv;
}

//Adapted from: http://stackoverflow.com/questions/8223348/ios-get-cpu-usage-from-application
-(float)appCPUUsage
{
	kern_return_t kr;
	task_info_data_t tinfo;
	mach_msg_type_number_t task_info_count;

	task_info_count = TASK_INFO_MAX;
	kr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)tinfo, &task_info_count);
	if (kr != KERN_SUCCESS) {
		return -1;
	}

	thread_array_t thread_list;
	mach_msg_type_number_t thread_count;

	thread_info_data_t thinfo;
	mach_msg_type_number_t thread_info_count;

	thread_basic_info_t basic_info_th;

	kr = task_threads(mach_task_self(), &thread_list, &thread_count);
	if (kr != KERN_SUCCESS) {
		return -1;
	}

	float tot_cpu = 0;
	int j;

	for (j = 0; j < thread_count; j++)
	{
		thread_info_count = THREAD_INFO_MAX;
		kr = thread_info(thread_list[j], THREAD_BASIC_INFO,
						 (thread_info_t)thinfo, &thread_info_count);
		if (kr != KERN_SUCCESS) {
			return -1;
		}

		basic_info_th = (thread_basic_info_t)thinfo;

		if (!(basic_info_th->flags & TH_FLAGS_IDLE)) {
			tot_cpu = tot_cpu + basic_info_th->cpu_usage / (float)TH_USAGE_SCALE * 100.0;
		}
	}

	kr = vm_deallocate(mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t));
	assert(kr == KERN_SUCCESS);

	return tot_cpu;
}
@end






