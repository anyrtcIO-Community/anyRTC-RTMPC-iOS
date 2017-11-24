//
//  ATAudioGuesterViewController.h
//  RTMPCDemo
//
//  Created by jh on 2017/9/25.
//  Copyright © 2017年 jh. All rights reserved.
//游客端音频

#import <UIKit/UIKit.h>

@interface ATAudioGuesterViewController : UIViewController

@property (nonatomic, strong)RTMPCGuestAudioKit *guestAudioKit;

@property (nonatomic, strong) LiveList *liveItem;

//显示视图
@property (nonatomic, strong)UIView *guestView;

//当前连麦者
@property (nonatomic, strong)NSMutableArray *voiceArr;

@property (nonatomic, strong)GuestInfo *gestInfo;

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

@property (weak, nonatomic) IBOutlet UIButton *applyButton;

@property (weak, nonatomic) IBOutlet UIImageView *hostBackImageView;

//围观群众
@property (weak, nonatomic) IBOutlet UIView *listView;

@property (nonatomic, strong) ATListViewController  *listVc;
@end
