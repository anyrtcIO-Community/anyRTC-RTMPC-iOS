//
//  ATLiveInfoView.m
//  RTMPCDemo
//
//  Created by derek on 2017/9/25.
//  Copyright © 2017年 jh. All rights reserved.
//

#import "ATLiveInfoView.h"

@implementation ATLiveInfoView

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
    [self addSubview:self.atHeadImageView];
    [self.atHeadImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(5);
        make.centerY.equalTo(self.mas_centerY);
        make.height.equalTo(self.mas_height).multipliedBy(.75);
        make.width.equalTo(_atHeadImageView.mas_height);
    }];
    
    [self addSubview:self.atTitleLabel];
    [self.atTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.atHeadImageView.mas_right).offset(10);
        make.centerY.equalTo(self.mas_centerY).multipliedBy(.7);
        make.right.mas_greaterThanOrEqualTo(self.mas_right).offset(-10);
    }];
    
    [self addSubview:self.atIdLabel];
    [self.atIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.atHeadImageView.mas_right).offset(10);
        make.top.equalTo(self.atTitleLabel.mas_bottom);
        make.right.mas_greaterThanOrEqualTo(self.mas_right).offset(-10);
    }];
}
#pragma mark - get
- (UIImageView *)atHeadImageView {
    if (!_atHeadImageView) {
        _atHeadImageView = [[UIImageView alloc] init];
        _atHeadImageView.layer.cornerRadius = 16.6;
        _atHeadImageView.layer.masksToBounds = YES;
        _atHeadImageView.backgroundColor = [UIColor blueColor];
        _atHeadImageView.image = [UIImage imageNamed:@"headurl"];
    }
    return _atHeadImageView;
}
- (UILabel*)atTitleLabel {
    if (!_atTitleLabel) {
        _atTitleLabel = [UILabel new];
        _atTitleLabel.font = [UIFont systemFontOfSize:16];
        _atTitleLabel.textColor = [UIColor whiteColor];
    }
    return _atTitleLabel;
}
- (UILabel*)atIdLabel {
    if (!_atIdLabel) {
        _atIdLabel = [UILabel new];
        _atIdLabel.font = [UIFont systemFontOfSize:12];
        _atIdLabel.textColor = [UIColor whiteColor];
        _atIdLabel.text = @"ID:3343223";
    }
    return _atIdLabel;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
