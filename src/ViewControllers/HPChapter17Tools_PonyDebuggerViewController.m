//
//  HPChapter17Tools_PonyDebuggerViewController.m
//  HighPerformance
//
//  Created by Gaurav Vaish on 6/7/15.
//  Copyright (c) 2015 Gaurav Vaish. All rights reserved.
//

#import "HPChapter17Tools_PonyDebuggerViewController.h"
#import "HPInstrumentation.h"
#import "HPLogger.h"
#import "HPUtils.h"

@interface HPChapter17Tools_PonyDebuggerViewController () <NSURLConnectionDelegate, NSURLConnectionDataDelegate, UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UIButton *connButton;
@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) IBOutlet UITextField *urlField;

-(IBAction)buttonWasClicked:(id)sender;

@end

@implementation HPChapter17Tools_PonyDebuggerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[HPInstrumentation logEvent:@"SCR_Tools_PD"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(IBAction)buttonWasClicked:(id)sender {
	UIButton *btn = (UIButton *)sender;
	NSInteger tag = btn.tag;

	NSURL *pdURL = [NSURL URLWithString:@"http://github.com/square/ponydebugger"];

	switch(tag) {
		case 1:
			[[UIApplication sharedApplication] openURL:pdURL];
			break;
		case 2:
			[HPUtils openSettings];
			break;
		case 3:
			[self makeARequest];
		default:
			break;
	}
}

-(IBAction)gotoURL:(id)sender {
	[self makeARequest];
}

-(void)makeARequest {
	NSString *urlValue = self.urlField.text;
	if(urlValue) {
		if(![urlValue hasPrefix:@"http://"] && ![urlValue hasPrefix:@"https://"]) {
			urlValue = [NSString stringWithFormat:@"http://%@", urlValue];
		}
		NSURL *url = [NSURL URLWithString:urlValue];
		if(url) {
			self.connButton.enabled = NO;
			NSURLRequest *req = [NSURLRequest requestWithURL:url];
			NSURLConnection *conn = [NSURLConnection connectionWithRequest:req delegate:self];
			self.connection = conn;
			[conn start];
		}
	}
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	self.connButton.enabled = YES;
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	self.connButton.enabled = YES;
}

@end
