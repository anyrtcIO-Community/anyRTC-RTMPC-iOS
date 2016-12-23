//
//  RTMPCGuestKit.h
//  RTMPCHybirdEngine
//
//  Created by EricTao on 16/7/16.
//  Copyright © 2016年 EricTao. All rights reserved.
//

#ifndef RTMPCGuestKit_h
#define RTMPCGuestKit_h
#import <UIKit/UIKit.h>
#import "RTMPCGuestDelegate.h"
#include "RTMPCCommon.h"

typedef NS_ENUM(NSInteger,VideoShowMode){
    VideoShowModeScaleAspectFit,   
    VideoShowModeScaleAspectFill,  // default by height scale (高度填充整个屏幕)
    VideoShowModeCenter
};

@interface RTMPCGuestKit : NSObject {
    
}
/**
 *  播放器显示模式
 */
@property (nonatomic, assign)VideoShowMode videoContentMode;
/**
 *  RTC 相关回调代理，如果不用RTC，该回调不用设置
 */
@property (weak, nonatomic) id<RTMPCGuestRtcDelegate> rtc_delegate;
/**
 *  初始化游客工具
 *
 *  @param delegate RTMP相关回调代理
 *  @param capturePosition  设备方向（横屏/竖屏）
 *  @param isAudioOnly 如果是YES,存音频模式；设置NO,为音视频模式
 *  @param audioDetect  如果isAudioOnly 为YES的时候 audioDetect才有用，设置YES，打开音频监测
 *
 *  @return 游客端工具类
 */
- (instancetype)initWithDelegate:(id<RTMPCGuestRtmpDelegate>)delegate
       withCaptureDevicePosition:(RTMPCScreenOrientation)capturePosition
             withLivingAudioOnly:(BOOL)isAudioOnly withAudioDetect:(BOOL)audioDetect;
;
/**
 *  清空游客端工具类，相当于析构函数
 */
- (void) clear;

#pragma mark - Common function
/**
 *  设置音频是否传输，默认音频传输
 *
 *  @param enable 设置YES,传输音频，设置NO,不传输音频
 */
- (void)SetAudioEnable:(bool) enabled;
/**
 *  设置音频是否传输，默认视频传输
 *
 *  @param enable 设置YES,传输视频，设置NO,不传输视频
 */
- (void)SetVideoEnable:(bool) enabled;
/**
 *  设置本地视频显示窗口（收到其他连麦同意的调调后设置）
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
 *  当显示尺寸更新的时候，调用该方法，更新显示区域（横竖屏切换调用，如果固定方向，不用调用该方法）
 */
- (void)videoFreamUpdate;

#pragma mark Rtmp function for pull rtmp stream
/**
 *  播放RTMP流
 *
 *  @param strUrl rtmp 地址
 *  @param render 视频显示View
 *
 *  @return 播放成功与失败
 */
- (BOOL)StartRtmpPlay:(NSString*)strUrl andRender:(UIView*)render;
/**
 *  停止播放（如果推出，直接调用Clear,该方法不用调用）
 */
- (void)StopRtmpPlay;

#pragma mark RTC function for line
/**
 *  打开RTC功能
 *
 *  @param strAnyrtcID (anyrtc ID 或者用户所在平台唯一键值)
 *  @param strCustomID (用户所在的自己平台的ID)
 *  @param strUserData (用户所在的自己平台的相关数据，建议用jason{键:值}，头像，昵称等等)
 *  @return 打开RTC成功与否
 */
- (BOOL)JoinRTCLine:(NSString*)strAnyrtcID andCustomID:(NSString*)strCustomID andUserData:(NSString*)strUserData;
/**
 *  申请与主播连麦
 *
 *  @param strUserData 申请理由（可为空）
 */
- (void)ApplyRTCLine:(NSString*)strUserData;
/**
 *  挂断连麦
 */
- (void)HangupRTCLine;
/**
 *  显示其他游客端连麦的小视频；如果横屏：视频大小比例为4:3;如果为竖屏：视频大小的比例为3:4
 *  @param strLivePeerID 游客端的请求ID
 *  @param render        显示对方视频的View
 */
- (void)SetRTCVideoRender:(NSString*)strLivePeerID andRender:(UIView*)render;
/**
 *  发送消息
 *
 *  @param nsCustomName   主播的昵称
 *  @param nsCustomHeader 主播的头像
 *  @param nsContent      消息内容
 *
 *  @return YES/NO 发送成功/发送失败
 */
- (BOOL)SendUserMsg:(NSString*)nsCustomName andCustomHeader:(NSString*)nsCustomHeader andContent:(NSString*)nsContent;
/**
 *  发送弹幕消息
 *
 *  @param nsCustomName   主播的昵称
 *  @param nsCustomHeader 主播的头像
 *  @param nsContent      消息内容
 *
 *  @return YES/NO 发送成功/发送失败
 */
- (BOOL)SendBarrage:(NSString*)nsCustomName andCustomHeader:(NSString*)nsCustomHeader  andContent:(NSString*)nsContent;
/**
 *  离开RTC，如果直接退出直接调用Clear ，不用调用该方法
 */
- (void)LeaveRTCLine;

/**
 *  更新经验值
 *
 *  @param exp 经验值
 */
- (void)UpdataExp:(int)exp;

@end

#endif /* RTMPCGuestKit_h */
