//
//  HPChapter04_LocationManagerViewController.h
//  HighPerformance
//
//  Created by Gaurav Vaish on 9/27/14.
//  Copyright (c) 2014 Gaurav Vaish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HPChapter04_LocationManagerViewController : UIViewController

@property (nonatomic, strong) IBOutlet UILabel *currentStatus;
@property (nonatomic, strong) IBOutlet UILabel *locationChangesCount;
@property (nonatomic, strong) IBOutlet UILabel *resultLabel;
@property (nonatomic, strong) IBOutlet UILabel *distanceFromSoL;

-(IBAction)permissionsTapped:(id)sender;
-(IBAction)trackLocationChanged:(id)sender;
-(IBAction)openInMaps:(id)sender;
-(IBAction)printAccuracyLevelValues:(id)sender;

@end
