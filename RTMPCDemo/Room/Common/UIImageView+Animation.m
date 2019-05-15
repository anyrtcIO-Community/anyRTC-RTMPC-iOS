//
//  UIImageView+Animation.m
//  RTMPCDemo
//
//  Created by 余生丶 on 2019/4/19.
//  Copyright © 2019 anyRTC. All rights reserved.
//

#import "UIImageView+Animation.h"

@implementation UIImageView (Animation)

- (void)startAudioAnimation {
    NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:5];
    for (int i = 1; i < 6; i ++) {
        UIImage *image =  [UIImage imageNamed:[NSString stringWithFormat:@"volume_%d",i]];
        [tempArr addObject:image];
    }
    
    self.animationImages = tempArr;
    self.animationDuration = 0.3f;
    self.animationRepeatCount = 5;
    [self startAnimating];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self stopAnimating];
        self.animationImages = nil;
    });
}

@end
