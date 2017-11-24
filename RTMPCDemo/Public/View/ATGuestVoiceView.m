//
//  ATVoiceView.m
//  RTMPCDemo
//
//  Created by derek on 2017/9/25.
//  Copyright © 2017年 jh. All rights reserved.
//

#import "ATGuestVoiceView.h"
#import "UIImage+Extension.h"

@implementation ATGuestVoiceView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.atNameLabel.textColor = [UIColor whiteColor];
}
- (void)setIsMySelf:(BOOL)isMySelf {
    _isMySelf = isMySelf;
    if (!isMySelf) {
        self.atHangUpButton.hidden = YES;
    }
}
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
- (IBAction)hangUp:(id)sender {
    if (self.removeBlock) {
        self.removeBlock(self);
    }
}

@end
