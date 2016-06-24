//
//  HPMailCompositeCell.h
//  HighPerformance
//
//  Created by Gaurav Vaish on 2/16/15.
//  Copyright (c) 2015 Gaurav Vaish. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface HPMailCompositeCell : UITableViewCell

@property (nonatomic, strong) IBInspectable IBOutlet UILabel *emailLabel;
@property (nonatomic, strong) IBInspectable IBOutlet UILabel *subjectLabel;
@property (nonatomic, strong) IBInspectable IBOutlet UILabel *snippetLabel;
@property (nonatomic, strong) IBInspectable IBOutlet UILabel *dateLabel;
@property (nonatomic, strong) IBOutlet UIButton *selectionButton;

@end
