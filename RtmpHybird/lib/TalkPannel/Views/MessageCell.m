//
//  MessageCell.m
//  MessageLivingDemo
//
//  Created by jianqiangzhang on 16/5/12.
//  Copyright © 2016年 jianqiangzhang. All rights reserved.
//

#import "MessageCell.h"

@implementation MessageCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //取消单元格选中效果
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self addAtrribuedLabel];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addAtrribuedLabel];
    }
    return self;
}
- (void)setModel:(MessageModel *)model{
    _model = model;
    self.label.textContainer = model.textContainer;
   // self.label.backgroundColor = [UIColor colorWithRed:236/255.0 green:237/255.0 blue:241/255.0 alpha:1];;
    
}

- (void)addAtrribuedLabel
{
    TYAttributedLabel *label = [[TYAttributedLabel alloc]init];
    label.backgroundColor = [UIColor clearColor];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:label];
    _label = label;
    
    NSArray *verticalContrainsts = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-3-[label]-3-|" options:0 metrics:nil views:@{@"label":_label}];
    NSArray *horizontalCOntraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[label]-5-|" options:0 metrics:nil views:@{@"label":_label}];
    
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0) {
        [NSLayoutConstraint activateConstraints:verticalContrainsts];
        [NSLayoutConstraint activateConstraints:horizontalCOntraints];
    } else {
        [self.contentView addConstraints:verticalContrainsts];
        [self.contentView addConstraints:horizontalCOntraints];
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
