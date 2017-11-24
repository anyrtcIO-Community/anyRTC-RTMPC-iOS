//
//  ATExtendMenuViewController.h
//  RTMPCDemo
//
//  Created by derek on 2017/9/23.
//  Copyright © 2017年 jh. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,ExtendMenuType) {
    ExtendMenuTypeSwitchCamera = 0,
    ExtendMenuTypeBeautyCamera = 1,
    ExtendMenuTypeCloseVideo = 2,
    ExtendMenuTypeCloseAudio = 3,
};
@interface ATExtendMenuViewController : UIViewController
typedef void(^ExtendMenuTapBlock)(ExtendMenuType type,BOOL isSelected);

@property (nonatomic, copy)ExtendMenuTapBlock menuTapBlock;

@end
