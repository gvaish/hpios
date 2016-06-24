//
//  HPChapter08_DataSharingViewController.m
//  HighPerformance
//
//  Created by Gaurav Vaish on 3/16/15.
//  Copyright (c) 2015 Gaurav Vaish. All rights reserved.
//

#import <MobileCoreServices/MobileCoreServices.h>
#import "HPChapter09_DataSharingViewController.h"
#import "HPLocationManager.h"
#import "HPInstrumentation.h"
#import "HPLogger.h"
#import "HPShareActivity.h"

@interface HPChapter09_DataSharingViewController () <UIDocumentInteractionControllerDelegate, UIAlertViewDelegate, UIDocumentPickerDelegate>

@property (nonatomic, strong) IBOutlet UIButton *mapsButton;
@property (nonatomic, strong) UIDocumentInteractionController *controller;
@property (nonatomic, strong) IBOutlet UILabel *resultLabel;
@property (nonatomic, strong) IBOutlet UIImageView *imageView;

-(IBAction)onMapsTapped:(id)sender;

-(UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller;

@end

@implementation HPChapter09_DataSharingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps-x-callback://"]]) {
		self.mapsButton.enabled = YES;
	} else {
		self.mapsButton.enabled = NO;
	}
}

-(void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[HPInstrumentation logEvent:@"SCR_DataShare"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(IBAction)onMapsTapped:(id)sender {
	CLLocation *loc = [HPLocationManager sharedInstance].latestLocation;

	if(loc) {
		if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps-x-callback://"]]) {
			NSMutableString *urlValue = [[NSMutableString alloc]
											initWithString:@"comgooglemaps-x-callback://?x-source=HPerf+Apps&x-success=m10vhperf://&daddr=40.758895,-73.985131&saddr="];
			
			[urlValue appendFormat:@"%.f", loc.coordinate.latitude];
			[urlValue appendFormat:@","];
			[urlValue appendFormat:@"%.f", loc.coordinate.longitude];
			[HPLogger d:[NSString stringWithFormat:@"url: %@", urlValue]];
			NSURL *url = [NSURL URLWithString:urlValue];
			[[UIApplication sharedApplication] openURL:url];
		} else {
			[[[UIAlertView alloc]
			  initWithTitle:@"" message:@"Google Maps not found" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]
			 show];
		}
	}
	
}

-(NSURL *)URLForSamplePDF {
	NSString *extras = [[NSBundle mainBundle] pathForResource:@"sample" ofType:@"pdf"];
	NSURL *url = [NSURL fileURLWithPath:extras];
	return url;
}

-(void)setupPDFPreviewOrOpen {
	NSURL *url = self.URLForSamplePDF;
	UIDocumentInteractionController *uidic = [UIDocumentInteractionController interactionControllerWithURL:url];
	uidic.UTI = (__bridge NSString *)(kUTTypePDF);
	uidic.delegate = self;
	self.controller = uidic;
}

-(IBAction)previewPDF:(id)sender {
	[HPInstrumentation logEvent:@"Act:Share:Preview"];
	[self setupPDFPreviewOrOpen];
	BOOL success = [self.controller presentPreviewAnimated:YES];
	self.resultLabel.text = success ? @"Preview: Success": @"Preview: Failure";
}

-(IBAction)openPDF:(id)sender {
	[HPInstrumentation logEvent:@"Act:Share:Open"];
	[self setupPDFPreviewOrOpen];
	BOOL success = [self.controller presentOpenInMenuFromRect:self.view.bounds inView:self.view animated:YES];
	self.resultLabel.text = success ? @"Open: Success": @"Open: Failure";
}

-(IBAction)listInboxFiles:(id)sender {
	[HPInstrumentation logEvent:@"Act:Share:ListInbox"];
	NSFileManager *filemgr = [NSFileManager defaultManager];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString* inboxPath = [documentsDirectory stringByAppendingPathComponent:@"Inbox"];
	NSArray *dirFiles = [filemgr contentsOfDirectoryAtPath:inboxPath error:nil];

	NSMutableString *s = [[NSMutableString alloc] init];
	[s appendFormat:@"Total Files: %d\n", (int) dirFiles.count];
	for(NSString *f in dirFiles) {
		[s appendString:f];
		[s appendString:@"\n"];
	}
	self.resultLabel.text = s;

	if(dirFiles.count > 0) {
		[[[UIAlertView alloc] initWithTitle:@""
				message:@"Clear Inbox?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes!", nil]
		 show];
	}
}

-(IBAction)shareDocument:(id)sender {
	[HPInstrumentation logEvent:@"Act:Share:Doc"];
	NSString *string = @"High Performance iOS Apps - Secrets to building lovable apps.\n";
	NSURL *url = [NSURL URLWithString:@"http://www.m10v.com"];
	UIImage *image = [UIImage imageNamed:@"m10v"];

	HPShareActivity *activity = [[HPShareActivity alloc] init];

	UIActivityViewController *avc = [[UIActivityViewController alloc]
			initWithActivityItems:@[url, string, image]
			applicationActivities:@[activity]];
	avc.excludedActivityTypes = @[];
	[self.navigationController presentViewController:avc animated:YES
		completion:^{
			//NO-OP
	}];
}

-(UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller {
	return self;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if(buttonIndex == 1) {
		NSFileManager *filemgr = [NSFileManager defaultManager];
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		NSString* inboxPath = [documentsDirectory stringByAppendingPathComponent:@"Inbox"];
		NSArray *dirFiles = [filemgr contentsOfDirectoryAtPath:inboxPath error:nil];
		for(NSString *fname in dirFiles) {
			NSString *fullName = [inboxPath stringByAppendingPathComponent:fname];
			[filemgr removeItemAtPath:fullName error:nil];
		}
	}
}

-(IBAction)onOpenPDFUsingPicker:(id)sender {
	//NSURL *pdfURL = [self URLForSamplePDF];
	NSArray *types = @[
		(NSString *)kUTTypeImage,
		(NSString *)kUTTypePNG,
		(NSString *)kUTTypeJPEG,
		(NSString *)kUTTypeGIF
	];
	UIDocumentPickerViewController *dpvc = [[UIDocumentPickerViewController alloc]
											initWithDocumentTypes:types inMode:UIDocumentPickerModeImport];
	dpvc.delegate = self;
	dpvc.modalPresentationStyle = UIModalPresentationFormSheet;
	[self.navigationController presentViewController:dpvc animated:YES completion:nil];
	[HPInstrumentation logEvent:@"ACT_Picker"];
}

-(void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url {
	[HPInstrumentation logEvent:@"ACT_Picker_Pick"];
	[HPLogger d:@"[didPickDocumentAtURL] url=%@", url];
	UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
	if(img) {
		//NSLog(@"img: %@", [img class]);
		self.imageView.image = img;
	} else {
		self.resultLabel.text = @"Error with image";
	}
}

-(void)documentPickerWasCancelled:(UIDocumentPickerViewController *)controller {
	[HPInstrumentation logEvent:@"ACT_Picker_Cancel"];
	[HPLogger d:@"[documentPickerWasCancelled] called"];
}

@end
