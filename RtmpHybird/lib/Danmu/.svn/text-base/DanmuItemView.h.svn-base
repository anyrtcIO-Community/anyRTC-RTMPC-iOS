//
//  DanmuItemView.h
//  MessageLivingDemo
//
//  Created by jianqiangzhang on 16/8/2.
//  Copyright © 2016年 jianqiangzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DanmuItem.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define ItemHeight 35
#define ItemSpace 5

@interface DanmuItemView : UIView
@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, assign) BOOL previousIsShow;
@property (nonatomic, assign) NSInteger selfYposition;
@property (nonatomic, assign) NSInteger index;

- (void)setContent:(DanmuItem*)model;
//过场动画，根据长度计算时间
- (void)grounderAnimation:()model;

//固定高度求文字长度
+ (CGFloat)calculateMsgWidth:(NSString *)msg andWithLabelFont:(UIFont*)font andWithHeight:(NSInteger)height;
@end
