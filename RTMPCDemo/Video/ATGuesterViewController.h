//
//  ATGuesterViewController.h
//  RTMPDemo
//
//  Created by jh on 2017/9/14.
//  Copyright © 2017年 jh. All rights reserved.
//游客端视频

#import <UIKit/UIKit.h>
#import "ATLivingItem.h"

typedef void(^RefreshBlock)(void);

@interface ATGuesterViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *guestBottomView;

//rtc连接提示
@property (weak, nonatomic) IBOutlet UILabel *rtcLabel;

//rtmp连接提示
@property (weak, nonatomic) IBOutlet UILabel *rtmpLabel;

//主播头像
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

//主题
@property (weak, nonatomic) IBOutlet UILabel *topicLabel;

//房间id
@property (weak, nonatomic) IBOutlet UILabel *roomIdLabel;

//观看人数
@property (weak, nonatomic) IBOutlet UILabel *onlineLabel;

//请求连麦按钮
@property (weak, nonatomic) IBOutlet UIButton *applyButton;

//翻转摄像头
@property (weak, nonatomic) IBOutlet UIButton *switchButton;

//视频
@property (weak, nonatomic) IBOutlet UIButton *videoButton;

//音频
@property (weak, nonatomic) IBOutlet UIButton *voiceButton;

//聊天
@property (weak, nonatomic) IBOutlet UIButton *messageButton;

//围观群众
@property (weak, nonatomic) IBOutlet UIView *listView;

@property (nonatomic, strong)RTMPCGuestKit *guestKit;

@property (nonatomic, strong) LiveList *liveItem;

//显示视图
@property (nonatomic, strong)UIView *guestView;

//当前连麦者
@property (nonatomic, strong)NSMutableArray *videoArr;

@property (nonatomic, strong)GuestInfo *gestInfo;

@property (nonatomic, copy)RefreshBlock refreshBlock;

@property (nonatomic, strong) ATListViewController  *listVc;

@end
