//
//  HPMeasurableView.m
//  HighPerformance
//
//  Created by Gaurav Vaish on 2/13/15.
//  Copyright (c) 2015 Gaurav Vaish. All rights reserved.
//

#import "HPMeasurableView.h"
#import "HPLogger.h"
#import "HPInstrumentation.h"
#import "HPUtils.h"

@interface HPMeasurableView ()

@end

@implementation HPMeasurableView

-(void)didAddSubview:(UIView *)subview {
	uint64_t nanos = [HPUtils timeBlock:^{
		[super didAddSubview:subview];
	}];
	[HPLogger i:@"[MV::didAddSubview] %p time=%ldns for %@", self, nanos, [subview class]];
}

-(void)layoutSubviews {
	uint64_t nanos = [HPUtils timeBlock:^{
		[super layoutSubviews];
	}];
	[HPLogger i:@"[MV::layoutSubviews] %p time=%ldns", self, nanos];
}

-(void)drawRect:(CGRect)rect {
	uint64_t nanos = [HPUtils timeBlock:^{
		[super drawRect:rect];
	}];
	[HPLogger i:@"[MV::drawRect] time=%ldns", nanos];
}

@end
