//
//  ATHostVoiceView.m
//  RTMPCDemo
//
//  Created by derek on 2017/9/25.
//  Copyright © 2017年 jh. All rights reserved.
//

#import "ATHostVoiceView.h"
#import "UIImage+Extension.h"

@implementation ATHostVoiceView
-(void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.atNameLabel.textColor = [ATCommon getColor:@"#fedc3d"];
}
// 设置名字
- (void)setStrName:(NSString *)strName {
    _strName = strName;
    self.atNameLabel.text = strName;
}
- (void)setStrHeadUrl:(NSString *)strHeadUrl {
    _strHeadUrl = strHeadUrl;
    self.atHeadImageView.fbHeadImageView.image = [UIImage imageNamed:@"headurl"];
}
- (void)showAnimation:(int)time {
    if (self.atHeadImageView) {
        [self.atHeadImageView startAnimation:time];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
