//
//  RTMeetKit.h
//  RTMeetEngine
//
//  Created by EricTao on 16/11/10.
//  Copyright © 2016年 EricTao. All rights reserved.
//

#ifndef RTMeetKit_h
#define RTMeetKit_h

#import <UIKit/UIKit.h>
#import "RTMeetKitDelegate.h"

@interface RTMeetKit : NSObject {
    
}

/**
 *  初始化会议工具
 *
 *  @param delegate RTC相关回调代理
 *
 *  @return 会议工具类
 */
- (instancetype)initWithDelegate:(id<RTMeetKitDelegate>)delegate;

/**
 *  配置 RTC 会议引擎
 *
 *  @param strDeveloperId   开发者ID(在www.anyrtc.ios注册开发者后平台会分配用户一个开发者ID)
 *  @param strAppId         AppID(开发者创建一个应用，平台会为该App分配一个AppID)
 *  @param strAppKey        AppKey(开发者创建一个应用，平台会为该App分配一个AppKey)
 *  @param strAppToken      AppToken(开发者创建一个应用，平台会为该App分配一个Token)
 */
- (void)InitEngineWithAnyrtcInfo:(NSString*)strDeveloperId andAppID:(NSString*)strAppId andAppKey:(NSString*)strAppKey andAppToken:(NSString*)strAppToken;

/**
 *  配置私有云
 *
 *  @param strAddr 私有云地址
 *  @param nPort   私有云端口
 */
- (void)ConfigServerForPriCloud:(NSString*)strAddr andPort:(int)nPort;

#pragma mark Common function
/**
 *  设置音频是否传输，默认音频传输
 *
 *  @param enabled 设置YES,开启音频传输，设置NO,不传输音频
 */
- (void)SetAudioEnable:(bool) enabled;
/**
 *  设置音频是否传输，默认视频传输
 *
 *  @param enabled 设置YES,开启视频传输，设置NO,不传输视频
 */
- (void)SetVideoEnable:(bool) enabled;

/**
 *  设置扬声器开关
 *
 *  @param on 设置YES,打开扬声器，设置NO,关闭扬声器。默认打开
 */
- (void)SetSpeakerOn:(bool)on;
/**
 *  设置本地视频显示窗口
 *
 *  @param render 视频窗口
 *  @param front  摄像头前置，还是后置; YES:前置；NO:后置
 */
- (void)SetVideoCapturer:(UIView*) render andUseFront:(bool)front;
/**
 *  更改前置跟后置摄像头
 */
- (void)SwitchCamera;
/**
 开启摄像头灯光
 
 @param isOn YES/NO:开启/关闭
 
 @return 返回成功与否
 */
- (BOOL)SetCameraTorchMode:(bool)isOn;

#pragma mark RTC function for line
/**
 *  加入会议
 *
 *  @param strAnyrtcID 会议号（可以在AnyRTC 平台获得，也可以根据自己平台，分配唯一的一个ID号）
 *  @return 加入会议成功或者失败
 */
- (BOOL)Join:(NSString*)strAnyrtcID;
/**
 *  离开会议室
 */
- (void)Leave;
/**
 *  显示其他端视频；视频的大小见回调
 *  @param strLivePeerID 游客端的请求ID
 *  @param render        显示对方视频的View
 */
- (void)SetRTCVideoRender:(NSString*)strLivePeerID andRender:(UIView*)render;
@end

#endif /* RTMeetKit_h */
