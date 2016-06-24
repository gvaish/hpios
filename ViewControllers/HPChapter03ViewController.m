//
//  HPFirstViewController.m
//  HighPerformance
//
//  Created by Gaurav Vaish on 8/17/14.
//  Copyright (c) 2014 Gaurav Vaish. All rights reserved.
//

#import "HPChapter03ViewController.h"
#import "Flurry.h"
#import "HPPhoto.h"
#import "HPLogger.h"
#import "HPInstrumentation.h"
//#import <mach/mach.h>

@interface HPChapter03ViewController ()

@end

@implementation HPChapter03ViewController

@synthesize resultLabel;

- (void)viewDidLoad
{
//	task_basic_info_data_t info;
//	mach_msg_type_number_t size = sizeof(info);
//	kern_return_t kerr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)&info, &size);
//	[HPLogger d:[NSString stringWithFormat:@"Memory consumed: %u", ((kerr == KERN_SUCCESS) ? info.resident_size : 0)]];
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
	//[HPInstrumentation logEvent:@"FV_Appear"];
	[HPInstrumentation logEvent:@"Appear_Ch03"];
	[super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)crashButtonWasClicked:(id)sender
{
	[HPInstrumentation logEvent:@"Btn_Crash"];
	[NSException raise:@"Crash Button was Clicked" format:@""];
}

-(IBAction)createStrongPhoto:(id)sender
{
	[HPInstrumentation logEvent:@"FV_Ph_Strong"];
	[HPLogger d:@"[enter] createStrongPhoto"];
	HPPhoto * __strong photo = [[HPPhoto alloc] init];
	[HPLogger d:[NSString stringWithFormat:@"Strong Photo: %@", photo]];
	photo.title = @"Strong Photo";

	NSMutableString *ms = [[NSMutableString alloc] init];
	[ms appendString:(photo == nil ? @"Photo is nil" : @"Photo is not nil")];
	[ms appendString:@"\n"];
	if(photo != nil) {
		[ms appendString:photo.title];
	}
	self.resultLabel.text = ms;
	[HPLogger d:@"[exit] createStrongPhoto"];
}

-(void)createStrongToWeakPhoto:(id)sender
{
	[HPInstrumentation logEvent:@"FV_Ph_StrgToWeak"];
	[HPLogger d:@"[enter] createStrongToWeakPhoto"];
	HPPhoto * sphoto = [[HPPhoto alloc] init];
	[HPLogger d:[NSString stringWithFormat:@"Strong Photo: %@", sphoto]];
	sphoto.title = @"Strong Photo, Assigned to Weak";

	HPPhoto * __weak wphoto = sphoto;
	[HPLogger d:[NSString stringWithFormat:@"Weak Photo: %@", wphoto]];

	NSMutableString *ms = [[NSMutableString alloc] init];
	[ms appendString:(wphoto == nil ? @"Photo is nil" : @"Photo is not nil")];
	[ms appendString:@"\n"];
	if(wphoto != nil) {
		[ms appendString:wphoto.title];
	}
	self.resultLabel.text = ms;
	[HPLogger d:@"[exit] createStrongToWeakPhoto"];
}

-(IBAction)createWeakPhoto:(id)sender
{
	[HPInstrumentation logEvent:@"FV_Ph_Weak"];
	[HPLogger d:@"[enter] createWeakPhoto"];
	HPPhoto * __weak wphoto = [[HPPhoto alloc] init];
	[HPLogger d:[NSString stringWithFormat:@"Weak Photo: %@", wphoto]];
	wphoto.title = @"Weak Photo";

	NSMutableString *ms = [[NSMutableString alloc] init];
	[ms appendString:(wphoto == nil ? @"Photo is nil" : @"Photo is not nil")];
	[ms appendString:@"\n"];
	if(wphoto != nil) {
		[ms appendString:wphoto.title];
	}
	self.resultLabel.text = ms;
	[HPLogger d:@"[exit] createWeakPhoto"];
}

-(void)createUnsafeUnretainedPhoto:(id)sender
{
	[HPInstrumentation logEvent:@"FV_Ph_UU"];
	[HPLogger d:@"[enter] createUnsafeUnretainedPhoto"];
	HPPhoto * __unsafe_unretained wphoto = [[HPPhoto alloc] init];
	[HPLogger d:[NSString stringWithFormat:@"Unsafe Unretained Photo: %@", wphoto]];
	wphoto.title = @"Strong Photo";

	NSMutableString *ms = [[NSMutableString alloc] init];
	[ms appendString:(wphoto == nil ? @"Photo is nil" : @"Photo is not nil")];
	[ms appendString:@"\n"];
	if(wphoto != nil) {
		[ms appendString:wphoto.title];
	}
	self.resultLabel.text = ms;
	[HPLogger d:@"[exit] createUnsafeUnretainedPhoto"];
}

@end
