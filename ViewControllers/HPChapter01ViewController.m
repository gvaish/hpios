//
//  HPChapter1ViewController.m
//  HighPerformance
//
//  Created by Gaurav Vaish on 8/23/14.
//  Copyright (c) 2014 Gaurav Vaish. All rights reserved.
//

#import "HPChapter01ViewController.h"
#import "HPInstrumentation.h"

@interface HPChapter01ViewController ()

@end

@implementation HPChapter01ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[HPInstrumentation logEvent:@"Appear_Ch01"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
