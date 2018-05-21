//
//  ATAudioButton.m
//  RTMPCDemo
//
//  Created by jh on 2018/4/16.
//  Copyright © 2018年 jh. All rights reserved.
//

#import "ATAudioButton.h"

@implementation ATWavesView

- (void)drawRect:(CGRect)rect{
    CGFloat radius = 30;
    CGFloat startAngle = 0;
    
    CGFloat endAngle = 2 * M_PI;
    
    // center: 弧线中心点的坐标  radius: 弧线所在圆的半径 startAngle: 弧线开始的角度值  endAngle: 弧线结束的角度值clockwise: 是否顺时针画弧线
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:self.center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    
    CAShapeLayer *layer = [[CAShapeLayer alloc]init];
    layer.path = path.CGPath;
    layer.strokeColor = [UIColor blueColor].CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer:layer];
}

@end

@implementation ATAudioButton

//音频检测
- (void)startAudioAnimation{
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.35 target:self selector:@selector(wavesRippleAnimation) userInfo:nil repeats:YES];
    }
    
}

- (void)wavesRippleAnimation{
    ATWavesView *wavesView = [[ATWavesView alloc]initWithFrame:self.bounds];
    wavesView.backgroundColor = [UIColor clearColor];
    [self addSubview:wavesView];
    
    [UIView animateWithDuration:2 animations:^{
        wavesView.transform = CGAffineTransformMakeScale(2, 2);
        wavesView.alpha = 0;
    } completion:^(BOOL finished) {
        if (self.timer) {
            [self.timer invalidate];
            self.timer = nil;
        }
    }];
    
}
@end


