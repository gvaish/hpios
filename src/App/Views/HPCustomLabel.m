//
//  HPCustomLabel.m
//  HighPerformance
//
//  Created by Gaurav Vaish on 2/12/15.
//  Copyright (c) 2015 Gaurav Vaish. All rights reserved.
//

#import "HPCustomLabel.h"
#import "HPLogger.h"

@implementation HPCustomLabel

-(void)drawRect:(CGRect)rect {
	//[HPLogger i:@"HPCustomLabel::drawRect called"];
	[super drawRect:rect];

	CGContextRef ctx = UIGraphicsGetCurrentContext();
	CGRect r = self.bounds;
	if(self.lineWidth > 0) {
		CGContextSetLineWidth(ctx, self.lineWidth);
	} else {
		CGContextSetLineWidth(ctx, 2);
	}
	CGRectInset(r, 4, 4);
	if(self.lineColor) {
		[self.lineColor set];
	} else {
		[[UIColor greenColor] set];
	}
	UIRectFrame(r);
}

-(void)drawTextInRect:(CGRect)rect {
	if(self.padding > 0) {
		UIEdgeInsets insets = { self.padding, self.padding, self.padding, self.padding };
		[super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
	} else {
		[super drawTextInRect:rect];
	}
}

@end
