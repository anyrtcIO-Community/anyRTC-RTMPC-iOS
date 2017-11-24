//
//  ATWatchView.m
//  RTMPCDemo
//
//  Created by derek on 2017/9/25.
//  Copyright © 2017年 jh. All rights reserved.
//

#import "ATWatchView.h"

@implementation ATWatchView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}
- (void)layoutSubviews {
    self.layer.cornerRadius = self.bounds.size.height/2;
}
- (void)initUI {
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.5];

    self.layer.masksToBounds = YES;
    
    [self addSubview:self.atIconImageView];
    [self addSubview:self.atTitleLabel];
    [self addSubview:self.atNumLabel];
    [self.atIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.centerY.equalTo(self.mas_centerY);
        make.width.height.equalTo(@30);
    }];
    
    [self.atTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.atIconImageView.mas_right);
        make.right.equalTo(self.mas_right).offset(-15);
        make.bottom.equalTo(self.mas_bottom).offset(-5);
    }];
    
    [self.atNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.atTitleLabel.mas_top);
        make.centerX.equalTo(self.atTitleLabel.mas_centerX);
    }];
    
}

#pragma mark - get
- (UIImageView *)atIconImageView {
    if (!_atIconImageView) {
        _atIconImageView = [UIImageView new];
        _atIconImageView.image = [UIImage imageNamed:@"Onlookers"];
    }
    return _atIconImageView;
}
- (UILabel*)atNumLabel {
    if (!_atNumLabel) {
        _atNumLabel = [UILabel new];
        _atNumLabel.textAlignment = NSTextAlignmentCenter;
        _atNumLabel.font = [UIFont systemFontOfSize:16];
        _atNumLabel.textColor = [UIColor whiteColor];
        _atNumLabel.text = @"0";
    }
    return _atNumLabel;
}
- (UILabel*)atTitleLabel {
    if (!_atTitleLabel) {
        _atTitleLabel = [UILabel new];
        _atTitleLabel.textAlignment = NSTextAlignmentCenter;
        _atTitleLabel.font = [UIFont systemFontOfSize:12];
        _atTitleLabel.textColor = [UIColor whiteColor];
        _atTitleLabel.text = @"围观群众";
    }
    return _atTitleLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
