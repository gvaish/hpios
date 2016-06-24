//
//  ActionViewController.m
//  actionRead
//
//  Created by Gaurav Vaish on 3/19/15.
//  Copyright (c) 2015 Gaurav Vaish. All rights reserved.
//

#import "ActionViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface ActionViewController ()

@property(strong,nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ActionViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	BOOL imageFound = NO;
	for(NSExtensionItem *item in self.extensionContext.inputItems) {
		for(NSItemProvider *itemProvider in item.attachments) {
			if([itemProvider hasItemConformingToTypeIdentifier:(NSString *)kUTTypeImage]) {
				__weak UIImageView *imageView = self.imageView;
				[itemProvider loadItemForTypeIdentifier:(NSString *)kUTTypeImage options:nil completionHandler:^(UIImage *image, NSError *error) {
					if(image) {
						[[NSOperationQueue mainQueue] addOperationWithBlock:^{
							[imageView setImage:image];
						}];
					}
				}];

				imageFound = YES;
				break;
			}
		}

		if(imageFound) {
			break;
		}
	}
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (IBAction)done {
	[self.extensionContext completeRequestReturningItems:self.extensionContext.inputItems completionHandler:nil];
}

@end
