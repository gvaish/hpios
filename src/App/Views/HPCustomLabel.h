//
//  HPCustomLabel.h
//  HighPerformance
//
//  Created by Gaurav Vaish on 2/12/15.
//  Copyright (c) 2015 Gaurav Vaish. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
	BORDER_STYLE_SOLID,
	BORDER_STYLE_DASHED,
	BORDER_STYLE_DOTTED,
} HPLabelBorderStyle;

IB_DESIGNABLE
@interface HPCustomLabel : UILabel

@property (nonatomic, assign) IBInspectable NSInteger lineWidth;
@property (nonatomic, strong) IBInspectable UIColor *lineColor;
@property (nonatomic, assign) IBInspectable NSInteger padding;
@property (nonatomic, assign) IBInspectable HPLabelBorderStyle borderStyle;

@end
