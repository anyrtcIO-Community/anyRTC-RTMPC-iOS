//
//  AppDelegate.h
//  RTMPCDemo
//
//  Created by jh on 2017/9/18.
//  Copyright © 2017年 jh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATMainViewController.h"

static NSString *developerID = @"XXX";
static NSString *token = @"XXX";
static NSString *key = @"XXX";
static NSString *appID = @"XXX";

#define PushRtmpServer @"XXX"
#define PullRtmpServer @"XXX"
#define HlsServer @"XXX"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//是都允许横屏
@property (nonatomic,assign)BOOL allowRotation;

@property (nonatomic, strong)ATMainViewController *mainVc;

@end

