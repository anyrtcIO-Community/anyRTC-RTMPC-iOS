//
//  ATExtendMenuButton.m
//  RTMPCDemo
//
//  Created by derek on 2017/9/23.
//  Copyright © 2017年 jh. All rights reserved.
//

#import "ATExtendMenuButton.h"
#import <Masonry.h>
#define MarkButtonTitleW 20

@implementation ATExtendMenuButton
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        // 高亮的时候不要自动调整图标
        self.adjustsImageWhenHighlighted = NO;
        self.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        //        self.imageView.contentMode = UIViewContentModeCenter;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 高亮的时候不要自动调整图标
        self.adjustsImageWhenHighlighted = NO;
        self.titleLabel.font = [UIFont boldSystemFontOfSize:13];
//        self.imageView.contentMode = UIViewContentModeCenter;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
//        // 背景
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageY = contentRect.size.height*.2;
    CGFloat imageX = contentRect.size.width*.3;
    CGFloat imageW = contentRect.size.width*.4;
    CGFloat imageH = contentRect.size.height*.4;
    return CGRectMake(imageX, imageY, imageW, imageH);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleY = contentRect.size.height*.6;
    CGFloat titleW = contentRect.size.width;
    CGFloat titleX = 0;
    CGFloat titleH = contentRect.size.height*.2;
    return CGRectMake(titleX, titleY, titleW, titleH);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
