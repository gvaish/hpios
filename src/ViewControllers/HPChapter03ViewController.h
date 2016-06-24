//
//  HPFirstViewController.h
//  HighPerformance
//
//  Created by Gaurav Vaish on 8/17/14.
//  Copyright (c) 2014 Gaurav Vaish. All rights reserved.
//

#import <UIKit/UIKit.h>

//FirstViewController has been renamed to HPChapter03ViewController to match the book structure
@interface HPChapter03ViewController : UIViewController

@property (nonatomic, strong) IBOutlet UILabel *resultLabel;

-(IBAction)crashButtonWasClicked:(id)sender;
-(IBAction)createStrongPhoto:(id)sender;
-(IBAction)createStrongToWeakPhoto:(id)sender;
-(IBAction)createWeakPhoto:(id)sender;
-(IBAction)createUnsafeUnretainedPhoto:(id)sender;


@end
