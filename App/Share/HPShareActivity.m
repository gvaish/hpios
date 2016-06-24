//
//  HPShareActivity.m
//  HighPerformance
//
//  Created by Gaurav Vaish on 3/19/15.
//  Copyright (c) 2015 Gaurav Vaish. All rights reserved.
//

#import "HPShareActivity.h"
#import "HPLogger.h"
#import "HPInstrumentation.h"
#import "HPShareActivityViewController.h"

@interface HPShareActivity ()

@property (nonatomic, strong) NSArray *activityItems;

@end

@implementation HPShareActivity

+(UIActivityCategory)activityCategory {
	return UIActivityCategoryShare;
}

-(NSString *)activityType {
	return @"com.m10v.HiPerf.share";
}

-(NSString *)activityTitle {
	return @"HPerf Share";
}

-(UIImage *)activityImage {
	return [UIImage imageNamed:@"HighPerfShare"];
}

-(BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
	return YES;
}

-(void)prepareWithActivityItems:(NSArray *)activityItems {
	//[HPLogger d:@"[prepareWithActivityItems] items: %@", activityItems];
	self.activityItems = activityItems;
}

-(UIViewController *)activityViewController {
	//[HPLogger d:@"[activityViewController] items: %@", self.activityItems];
	HPShareActivityViewController *vc = [[HPShareActivityViewController alloc] init];
	vc.contentValue = [NSString stringWithFormat:@"Items: -> %@", self.activityItems];
	vc.shareActivity = self;
	return vc;
}

@end
