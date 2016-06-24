//
//  HPChapter04_ScreenViewController.h
//  HighPerformance
//
//  Created by Gaurav Vaish on 9/28/14.
//  Copyright (c) 2014 Gaurav Vaish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HPChapter04_ScreenViewController : UIViewController

@property (nonatomic, strong) IBOutlet UILabel *screenCountLabel;
@property (nonatomic, strong) IBOutlet UIImageView *iv;
@property (nonatomic, strong) IBOutlet UIButton *btnStart;
@property (nonatomic, strong) IBOutlet UIButton *btnStop;
@property (nonatomic, strong) IBOutlet UIButton *btnPauseResume;

-(IBAction)startAnimationTapped:(id)sender;
-(IBAction)pauseResumeAnimationTapped:(id)sender;
-(IBAction)stopAnimationTapped:(id)sender;

@end
