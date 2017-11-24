//
//  ATAudioHosterViewController.h
//  RTMPCDemo
//
//  Created by jh on 2017/9/23.
//  Copyright © 2017年 jh. All rights reserved.
//主播端音频

#import <UIKit/UIKit.h>
#import "ATLivingItem.h"
#import "ATListViewController.h"

@interface ATAudioHosterViewController : UIViewController

@property(nonatomic ,strong) RTMPCHosterAudioKit *mHosterAudioKit;

//推流地址
@property (nonatomic, copy) NSString *rtmpUrl;

//拉流地址（录像地址）
@property (nonatomic, copy) NSString *rtmpPullUrl;

//hls地址
@property (nonatomic, copy)NSString *hlsUrl;

//当前连麦者
@property (nonatomic ,strong)NSMutableArray *voiceArr;

@property (nonatomic, strong) LiveInfo *liveInfo;

@property (nonatomic, strong) ATListViewController  *listVc;

@end
