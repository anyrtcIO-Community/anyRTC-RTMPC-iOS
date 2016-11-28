//
//  RTMPCHosterKit.h
//  RTMPCHybirdEngine
//
//  Created by EricTao on 16/7/16.
//  Copyright © 2016年 EricTao. All rights reserved.
//

#ifndef RTMPCHosterKit_h
#define RTMPCHosterKit_h
#import <UIKit/UIKit.h>
#import "RTMPCHosterDelegate.h"
#include "RTMPCCommon.h"

@interface RTMPCHosterKit : NSObject {
    
}
/**
 *  RTC 相关回调代理，如果不用RTC，该回调不用设置
 */
@property (weak, nonatomic) id<RTMPCHosterRtcDelegate> rtc_delegate;
/**
 *  初始化主播工具
 *
 *  @param delegate RTMP相关回调代理
 *  @param capturePosition  设备方向（横屏/竖屏）
 *  @param isAudioOnly  如果是YES,存音频模式；设置NO,为音视频模式
 *
 *  @return 主播端工具类
 */
- (instancetype)initWithDelegate:(id<RTMPCHosterRtmpDelegate>)delegate
       withCaptureDevicePosition:(RTMPCScreenOrientation)capturePosition
             withLivingAudioOnly:(BOOL)isAudioOnly;
/**
 *  清空主播端工具类，相当于析构函数
 */
- (void) clear;

#pragma mark Common function
/**
 *  设置音频是否传输，默认音频传输
 *
 *  @param enable 设置YES,传输音频，设置NO,不传输音频
 */
- (void)SetAudioEnable:(bool) enabled;
/**
 *  设置音频是否传输，默认视频开启
 *
 *  @param enable 设置YES,传输视频，设置NO,不传输视频
 */
- (void)SetVideoEnable:(bool) enabled;
/**
 *  设置推流模式
 *
 *  @param naMode choose RTMP_NA_Nor:普通模式；RTMP_NA_Fast:极速模式；RTMP_NA_AutoBitrate:自适应码流模式
 */
- (void)SetNetAdjustMode:(RTMPNetAdjustMode) naMode;
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
 *  设置美颜，默认
 *
 *  @param enabled YES/NO:美颜/不美颜
 */
- (void)SetBeautyEnable:(bool) enabled;
/**
 *  设置logo
 *
 *  @param logoFilePath 本地logo 路径
 */
- (void)SetVideoLogo:(NSString*)logoFilePath;
/**
 开启摄像头灯光

 @param isOn YES/NO:开启/关闭

 @return 返回成功与否
 */
- (BOOL)SetCameraTorchMode:(bool)isOn;
/**
 *  设置推流质量(手机直播，建议 RTMPC_Video_SD)
 *
 *  @param videoMode 
 *    （RTMPC_Video_HH，RTMPC_Video_4K，RTMPC_Video_2K，RTMPC_Video_1080P）:1920*1080,码率:2048
 *    （RTMPC_Video_Low，RTMPC_Video_SD，RTMPC_Video_SD）:640*360,码率:384,512,768
 *    （RTMPC_Video_HD）:960*540,码率:1024
 *    （RTMPC_Video_720P）:1280*720,码率:1280
 */
- (void)SetVideoMode:(RTMPCVideoMode) videoMode;

#pragma mark Rtmp function for push rtmp stream
/**
 *  设置推流地址
 *
 *  @param strUrl 推流地址（RTMP）
 *
 *  @return 成功/失败
 */
- (BOOL)StartPushRtmpStream:(NSString*)strUrl;
/**
 *  停止推流（如果退出直播界面，并释放主播的类，不要调用该方法，直接调用clear方法）
 */
- (void)StopRtmpStream;

#pragma mark RTC function for line
/**
 *  打开RTC功能
 *
 *  @param strAnyrtcID (anyrtc ID 或者用户所在平台唯一键值)
 *  @param strCustomID (用户所在的自己平台的ID)
 *  @param strUserData (用户所在的自己平台的相关数据，建议用jason{键:值}，头像，昵称等等)
 *  @param strRtcArea  默认为CN,为国内；设置HK,为海外（根据自己的需求设置）
 *  @return 打开RTC成功与否
 */
- (BOOL)OpenRTCLine:(NSString*)strAnyrtcID andCustomID:(NSString*)strCustomID andUserData:(NSString*)strUserData andRtcArea:(NSString*)strRtcArea;
/**
 *  主播同意游客端申请的连麦请求
 *
 *  @param strLivePeerID 对方请求的ID
 *
 *  @return 返回NO,同意连麦失败（可能超过连麦的数量）
 */
- (BOOL)AcceptRTCLine:(NSString*)strLivePeerID;
/**
 *  主播拒绝游客端的连麦
 *
 *  @param strLivePeerID 请求的ID
 *  @param banToApply
 */
- (void)RejectRTCLine:(NSString*)strLivePeerID andBanToApply:(bool) banToApply;

/**
 *  挂断连麦（已经同意了的连麦）
 *
 *  @param strLivePeerID 连麦者的请求ID
 */
- (void)HangupRTCLine:(NSString*)strLivePeerID;
/**
 *  显示游客端连麦的小视频；如果横屏：视频大小比例为4:3;如果为竖屏：视频大小的比例为3:4
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
 *  关闭RTC(一般不调用，因为Clear 的时候都清除了)
 */
- (void)CloseRTCLine;
@end

#endif /* RTMPCHosterKit_h */
