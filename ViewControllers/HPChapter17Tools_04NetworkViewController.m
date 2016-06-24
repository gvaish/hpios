//
//  HPChapter17Tools_04NetworkViewController.m
//  HighPerformance
//
//  Created by Gaurav Vaish on 6/6/15.
//  Copyright (c) 2015 Gaurav Vaish. All rights reserved.
//

#import "HPChapter17Tools_04NetworkViewController.h"
#import "HPInstrumentation.h"
#import "HPLogger.h"

@interface HPChapter17Tools_04NetworkViewController () <UIWebViewDelegate>

@property (nonatomic, strong) IBOutlet UITextField *urlField;
@property (nonatomic, strong) IBOutlet UIWebView *webView;

@end

@implementation HPChapter17Tools_04NetworkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[HPInstrumentation logEvent:@"SCR_Tools_Network"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(IBAction)gotoURL:(id)sender {
	[self enableURLField:NO];
	NSString *value = self.urlField.text;
	if(value) {
		if(![value hasPrefix:@"http://"] && ![value hasPrefix:@"https://"]) {
			value = [NSString stringWithFormat:@"http://%@", value];
		}
		[HPInstrumentation logEvent:@"Act_Network_Go" withParams:@{
			@"url": value
		}];
		NSURL *url = [NSURL URLWithString:value];
		NSURLRequest *request = [NSURLRequest requestWithURL:url];
		[self.webView loadRequest:request];
	} else {
		[self enableURLField:YES];
	}
}

-(void)enableURLField:(BOOL)enable {
	self.urlField.enabled = enable;
	if(enable) {
		self.urlField.backgroundColor = [UIColor whiteColor];
	} else {
		self.urlField.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
	}
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	[HPLogger d:@"webView:didFailLoadWithError: %@", error];
	[self enableURLField:YES];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
	[HPLogger d:@"webViewDidFinishLoad"];
	[self enableURLField:YES];
}

@end
