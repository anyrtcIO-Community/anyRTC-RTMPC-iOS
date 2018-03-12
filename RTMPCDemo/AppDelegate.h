//
//  AppDelegate.h
//  RTMPCDemo
//
//  Created by jh on 2017/9/18.
//  Copyright © 2017年 jh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATMainViewController.h"

#warning config developer info
//开发者信息（前往www.anyrtc.io申请）
static NSString *developerID = @"XXX";
static NSString *token = @"XXX";
static NSString *key = @"XXX";
static NSString *appID = @"XXX";
static NSString *appvtoken = @"XXX";

//推流拉流以及hls地址（根据自己vdn策略规则）
//#define PushRtmpServer @"rtmp://push.ws.anyrtc.io/live"
//#define PullRtmpServer @"rtmp://pull.ws.anyrtc.io/live"
//#define HlsServer @"http://hls.ws.anyrtc.io/live"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//是都允许横屏
@property (nonatomic,assign)BOOL allowRotation;

@property (nonatomic, strong)ATMainViewController *mainVc;

@end

