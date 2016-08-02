//
//  CustomSwitch.h
//  MessageLivingDemo
//
//  Created by jianqiangzhang on 16/5/12.
//  Copyright © 2016年 jianqiangzhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomSwitchDelegate <NSObject>

- (void)customSwitchOn;

- (void)customSwitchOff;

@end

@interface CustomSwitch : UIView

@property (nonatomic,weak)id<CustomSwitchDelegate>delegate;

@property(nonatomic,getter=isOn) BOOL on;

- (void)setOn:(BOOL)on animated:(BOOL)animated; // does not send action

@end
