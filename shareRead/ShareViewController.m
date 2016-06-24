//
//  ShareViewController.m
//  shareRead
//
//  Created by Gaurav Vaish on 3/20/15.
//  Copyright (c) 2015 Gaurav Vaish. All rights reserved.
//

#import "ShareViewController.h"
#import "HPInstrumentation.h"
#import "HPLogger.h"
#import "NSArray+HPExtensions.h"
#import "HPConfigurationItemViewController.h"

@interface ShareViewController ()

@end

@interface ShareConfigurationItem : SLComposeSheetConfigurationItem

@property (nonatomic, strong) ShareViewController *svc;

@end

@implementation ShareConfigurationItem

-(SLComposeSheetConfigurationItemTapHandler)tapHandler {
	return ^{
		HPConfigurationItemViewController *ctrl = [[HPConfigurationItemViewController alloc] init];
		ctrl.closeHandler = ^{
			[self.svc popConfigurationViewController];
		};
		[self.svc pushConfigurationViewController:ctrl];
	};
}

@end

@implementation ShareViewController

-(void)viewDidLoad {
	[super viewDidLoad];
	NSLog(@"[viewDidLoad] called");
}

- (BOOL)isContentValid {
	NSLog(@"[isContentValid] items -> %@", [self.extensionContext.inputItems nseiItems]);
    return YES;
}

-(void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	NSLog(@"[viewWillAppear] called");
}

-(void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	NSLog(@"[viewDidAppear] called");
}

//Preview!
//-(UIView *)loadPreviewView {
//	return nil;
//}

-(void)didSelectPost {
	NSLog(@"[didSelectPost] items -> %@", [self.extensionContext.inputItems nseiItems]);
    [self.extensionContext completeRequestReturningItems:@[] completionHandler:nil];
}

-(void)didSelectCancel {
	NSLog(@"[didSelectCancel] items -> %@", self.extensionContext.inputItems.nseiItems);
	[self.extensionContext completeRequestReturningItems:@[] completionHandler:nil];
}

- (NSArray *)configurationItems {
	NSLog(@"[configurationItems] items -> %@", [self.extensionContext.inputItems nseiItems]);

	ShareConfigurationItem *ci = [[ShareConfigurationItem alloc] init];
	ci.svc = self;
	ci.title = @"Configuration";
	ci.value = @"Value";

    return @[ci];
}

@end
