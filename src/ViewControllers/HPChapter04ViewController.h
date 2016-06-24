//
//  HPChapter04ViewController.h
//  HighPerformance
//
//  Created by Gaurav Vaish on 9/14/14.
//  Copyright (c) 2014 Gaurav Vaish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HPChapter04ViewController : UIViewController <UIAlertViewDelegate>

@property (nonatomic, strong) IBOutlet UILabel *batteryLevel;
@property (nonatomic, strong) IBOutlet UILabel *result;
@property (nonatomic, strong) IBOutlet UILabel *batteryState;
@property (nonatomic, strong) IBOutlet UILabel *coreCount;
@property (nonatomic, strong) IBOutlet UILabel *maxMemory;
@property (nonatomic, strong) IBOutlet UILabel *memoryConsumed;
@property (nonatomic, strong) IBOutlet UILabel *cpuStatus;
@property (nonatomic, strong) IBOutlet UILabel *appCPUStatus;

-(IBAction)doIntensiveOperation:(id)sender;

@end
