//
//  FBWaterHeadView.h
//  咻一咻
//
//  Created by derek on 2017/8/22.
//  Copyright © 2017年 derek. All rights reserved.
//音频连麦动画

#import <UIKit/UIKit.h>

@interface FBWaterHeadView : UIView

@property (nonatomic, strong) UIImageView *fbHeadImageView;

- (void)startAnimation:(int)time;

@end
