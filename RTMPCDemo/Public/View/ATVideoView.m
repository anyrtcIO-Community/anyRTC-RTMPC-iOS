//
//  ATVideoView.m
//  RTMPCDemo
//
//  Created by jh on 2017/9/21.
//  Copyright © 2017年 jh. All rights reserved.
//

#import "ATVideoView.h"

@implementation ATVideoView

- (void)awakeFromNib{
    [super awakeFromNib];
}

- (void)addHideTap{
    //主播端全部添加，游客端只有自己添加（无法挂断别人连麦）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.closeButton.hidden = YES;
    });
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideHangUp)];
    [self addGestureRecognizer:tap];
}

- (void)hideHangUp{
    self.closeButton.hidden = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.closeButton.hidden = YES;
    });
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat widthX = self.frame.size.width;
    CGFloat heightY = self.frame.size.height;
    if (widthX == 0 && heightY == 0) {
        return;
    }
    
    if (widthX > heightY) {
        //横屏
        self.centerY.constant = widthX/2 - 20;
    } else {
        self.centerX.constant = heightY/2 - 20;
    }
    
}

- (IBAction)removeAll:(id)sender {
    if (self.removeBlock) {
        self.removeBlock(self);
    }
}

@end
