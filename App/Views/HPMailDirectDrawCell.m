//
//  HPMailDirectDrawCell.m
//  HighPerformance
//
//  Created by Gaurav Vaish on 2/17/15.
//  Copyright (c) 2015 Gaurav Vaish. All rights reserved.
//

#import "HPMailDirectDrawCell.h"
#import "HPLogger.h"

@implementation HPMailDirectDrawCell

-(instancetype)init {
	self = [super init];
	if(self) {
		[self setup];
	}
	return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if(self) {
		[self setup];
	}
	return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if(self) {
		[self setup];
	}
	return self;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if(self) {
		[self setup];
	}
	return self;
}

-(void)setup {
	UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapped:)];
	[self addGestureRecognizer:gesture];
}

-(IBAction)cellTapped:(UIGestureRecognizer *)recognizer {
	CGPoint location = [recognizer locationInView:self];
	if(location.x >= 0 && location.x <= 20 && location.y >= 30) {
		self.isMailSelected = !self.isMailSelected;
		[self setNeedsDisplayInRect:CGRectMake(0, 30, 20, self.frame.size.height)];
		//[self setNeedsDisplay];
	}
}

- (void)awakeFromNib {
}

-(void)drawRect:(CGRect)rect {
	{
		UIImage *statusImage = nil;
		switch(self.mailStatus) {
			case HPMailDirectDrawCellStatusRead:
				statusImage = [UIImage imageNamed:@"bolt"];
				break;
			case HPMailDirectDrawCellStatusReplied:
				statusImage = [UIImage imageNamed:@"second"];
				break;
			case HPMailDirectDrawCellStatusUnread:
			default:
				statusImage = [UIImage imageNamed:@"bolt_selected"];
				break;
		}

		CGRect statusRect = CGRectMake(8, 4, 12, 12);
		[statusImage drawInRect:statusRect];
	}

	{
		UIImage *attachmentImage = nil;
		if(self.hasAttachment) {
			attachmentImage = [UIImage imageNamed:@"mail_attachment"];
		}

		CGRect statusRect = CGRectMake(8, 20, 12, 12);
		[attachmentImage drawInRect:statusRect];
	}
	
	{
		UIImage *selectedImage = [UIImage imageNamed:(self.isMailSelected ? @"mail_selected": @"mail_unselected")];
		CGRect selectedRect = CGRectMake(8, 36, 12, 12);
		[selectedImage drawInRect:selectedRect];
	}

	float fontSize = 13;
	CGFloat width = rect.size.width;
	CGFloat remainderWidth = width - 28;
	{
		CGFloat emailWidth = remainderWidth - 72;
		UIFont *emailFont=[UIFont boldSystemFontOfSize:fontSize];
		NSDictionary *attrs = @{ NSFontAttributeName: emailFont };

		[self.email drawInRect:CGRectMake(28, 4, emailWidth, 16) withAttributes:attrs];
	}

	{
		UIFont *stdFont = [UIFont systemFontOfSize:fontSize];
		NSDictionary *attrs = @{ NSFontAttributeName: stdFont };
		[self.subject drawInRect:CGRectMake(28, 24, remainderWidth, 16) withAttributes:attrs];
		[self.snippet drawInRect:CGRectMake(28, 44, remainderWidth, 16) withAttributes:attrs];
	}

	{
		UIFont *verdana = [UIFont fontWithName:@"Verdana" size:10];
		NSDictionary *attrs = @{ NSFontAttributeName: verdana };
		[self.date drawInRect:CGRectMake(width - 60, 4, 60, 16) withAttributes:attrs];
	}
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
	//self.isMailSelected = selected;
	//[self setNeedsDisplayInRect:CGRectMake(8, 36, 12, 12)];
}

@end



