//
//  CustomTableViewCell.m
//  CalculatorPad
//
//  Created by Administrator on 21.01.14.
//  Copyright (c) 2014 MyiPod. All rights reserved.
//

#import "CustomTableViewCell.h"

@implementation CustomTableViewCell

@synthesize textLabel = _textLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 50, 728, 30)];
        self.textLabel.textColor = [UIColor blackColor];
        self.textLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:30];
        [self.textLabel setTextAlignment:NSTextAlignmentRight];
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.textLabel];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
