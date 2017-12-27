//
//  ATVideoView.h
//  RTMPCDemo
//
//  Created by jh on 2017/9/21.
//  Copyright © 2017年 jh. All rights reserved.
//视频连麦视图

#import <UIKit/UIKit.h>

@interface ATVideoView : UIView
typedef void(^RemoveBlock)(ATVideoView *view);
// 删除动作
@property (nonatomic, copy) RemoveBlock removeBlock;

@property (weak, nonatomic) IBOutlet UIButton *closeButton;

//横向
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerX;

//纵向
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerY;

//连麦昵称
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

// 视图的分辨率大小
@property (nonatomic, assign) CGSize videoSize;

// 标识Id
@property (nonatomic, copy) NSString *strPeerId;

//标识流id
@property (nonatomic, copy) NSString *strPubId;

- (void)addHideTap;

@end
