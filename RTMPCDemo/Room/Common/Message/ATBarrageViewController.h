//
//  ATBarrageViewController.h
//  RTMPCDemo
//
//  Created by jh on 2018/4/11.
//  Copyright © 2018年 jh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATListViewController.h"
#import "ATBarragesView.h"
#import "ATHallModel.h"
#import "ATRealMicModel.h"

@interface ATBarrageViewController : UIViewController<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *messageTextField;

@property (nonatomic, strong) ATListViewController  *listVc; //在线人员

@property (nonatomic, strong) NSMutableArray * videoArr;   //视频窗口

@property (nonatomic, strong) NSMutableArray * audioArr;   //音频窗口

@property (nonatomic, strong) BarrageRenderer *renderer;   //横屏弹幕

@property (nonatomic, strong) ATBarragesView * infoView; //竖屏消息

//弹幕生成器
- (BarrageDescriptor *)produceTextBarrage:(BarrageWalkDirection)direction message:(NSString *)message;

//普通消息
- (ATBarragesModel *)produceTextInfo:(NSString *)name content:(NSString *)content userId:(NSString *)userId;

//连麦模型
- (ATRealMicModel *)produceRealModel:(NSString *)peerId userId:(NSString *)userId userData:(NSString *)userData;

//获取在线人员列表
- (void)getMemberList;
/**
 视频连麦窗口布局
 
 @param localView 端本地视图(主播端或游客)
 @param containerView 容器
 @param landscape  横竖屏
 */
- (void)layoutVideoView:(UIView *)localView containerView:(UIView *)containerView landscape:(NSInteger)landscape;

/**
 视频连麦窗口布局
 
 @param hosterButton 主播端头像
 @param containerView 容器
 @param landscape  横竖屏
 */
- (void)layoutAudioView:(UIButton *)hosterButton containerView:(UIView *)containerView landscape:(NSInteger)landscape;

@end
