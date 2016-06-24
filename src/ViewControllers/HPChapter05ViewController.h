//
//  HPChapter05ViewController.h
//  HighPerformance
//
//  Created by Gaurav Vaish on 10/12/14.
//  Copyright (c) 2014 Gaurav Vaish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HPChapter05ViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIButton *tcButton;
@property (nonatomic, strong) IBOutlet UIButton *atomicButton;
@property (nonatomic, strong) IBOutlet UIButton *nonatomicButton;
@property (nonatomic, strong) IBOutlet UILabel *tctLabel;
@property (nonatomic, strong) IBOutlet UITextField *tccTextField;

@property (nonatomic, strong) NSString *nonAtomicProperty;
@property (atomic, strong) NSString *atomicProperty;

-(IBAction)computeThreadCreationTime:(id)sender;
-(IBAction)computeAtomicPropertySetTime:(id)sender;
-(IBAction)computeNonAtomicPropertySetTime:(id)sender;


@end
