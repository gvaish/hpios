//
//  HPMailCompositeCell.m
//  HighPerformance
//
//  Created by Gaurav Vaish on 2/16/15.
//  Copyright (c) 2015 Gaurav Vaish. All rights reserved.
//

#import "HPMailCompositeCell.h"


@implementation HPMailCompositeCell

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
	return [super initWithCoder:aDecoder];
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	return [super initWithStyle:style reuseIdentifier:reuseIdentifier];
}

-(instancetype)initWithFrame:(CGRect)frame {
	return [super initWithFrame:frame];
}

-(instancetype)init {
	return [super init];
}

- (void)awakeFromNib {
    // Initialization code
	[super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
