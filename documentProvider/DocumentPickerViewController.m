//
//  DocumentPickerViewController.m
//  documentProvider
//
//  Created by Gaurav Vaish on 3/22/15.
//  Copyright (c) 2015 Gaurav Vaish. All rights reserved.
//

#import "DocumentPickerViewController.h"

@interface DocumentPickerViewController ()

@property (nonatomic, strong) IBOutlet UIButton *imageSelectorButton;

@end

@implementation DocumentPickerViewController

-(void)viewDidLoad {
	self.imageSelectorButton.enabled = NO;
	[super viewDidLoad];
}

- (IBAction)openDocument:(id)sender {
    NSURL* documentURL = [self.documentStorageURL URLByAppendingPathComponent:@"image1.jpg"];

	NSLog(@"%s -> %@", __PRETTY_FUNCTION__, documentURL);

	//https://www.flickr.com/photos/neilspicys/2349783572/in/gallery-just2brittany-72157629318885899/
	//https://farm3.staticflickr.com/2119/2349783572_3b6acc8587_z_d.jpg
    // TODO: if you do not have a corresponding file provider, you must ensure that the URL returned here is backed by a file
    [self dismissGrantingAccessToURL:documentURL];
}

-(void)prepareForPresentationInMode:(UIDocumentPickerMode)mode {
	NSLog(@"%s", __PRETTY_FUNCTION__);
}

@end
