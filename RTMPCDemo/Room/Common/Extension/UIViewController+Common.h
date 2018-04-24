//
//  UIViewController+Common.h
//  RTMPCDemo
//
//  Created by jh on 2018/4/11.
//  Copyright © 2018年 jh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Common)

/**
 将若干view等宽布局于容器containerView中(横向排列)
 @param views 子视图数组
 @param containerView 容器
 @param spacing 两边间距
 @param padding 相邻两个间距
 */
- (void)makeVideoEqualWidthViews:(NSMutableArray *)views containerView:(UIView *)containerView spacing:(CGFloat)spacing padding:(CGFloat)padding;

/**
 将若干view等高布局于容器containerView中(纵向排列)
 @param views 子视图数组
 @param containerView 容器
 @param spacing 两边间距
 @param padding 相邻两个间距
 */
- (void)makeVideoHeightViews:(NSMutableArray *)views containerView:(UIView *)containerView spacing:(CGFloat)spacing padding:(CGFloat)padding;

/**
 等分布局
 @param views 数组
 @param containerView 容器
 @param itemWidth  子视图宽
 @param itemHeight  子视图高
 @param warpCount  折行点
 */
- (void)makeVideoViews:(NSMutableArray *)views containerView:(UIView *)containerView itemWidth:(CGFloat)itemWidth itemHeight:(CGFloat)itemHeight warpCount:(NSInteger)warpCount;

/**
 根据分辨率显示，防止拉伸压缩
 @param  videoArr 视图数组
 @param itemWidth   子视图的宽
 @param itemHeight  子视图的高
 */
- (void)makeResolution:(NSMutableArray *)videoArr itemWidth:(CGFloat)itemWidth itemHeight:(CGFloat)itemHeight;

//自定义Bar
- (void)customNavigationBar:(NSString *)title;

//横屏  UIInterfaceOrientation.landscapeLeft    竖屏：UIInterfaceOrientation.portrait
- (void)orientationRotating:(UIInterfaceOrientation)direction;

@end
