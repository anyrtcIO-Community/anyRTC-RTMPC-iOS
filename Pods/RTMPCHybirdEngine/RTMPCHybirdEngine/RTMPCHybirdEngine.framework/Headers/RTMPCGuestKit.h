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
#import "RTCCommon.h"
#import "RTMPCGuestOption.h"
#import "AnyRTCUserShareBlockDelegate.h"

@interface RTMPCGuestKit : NSObject {
    
}

/**
 RTC 相关回调代理，如果不用RTC，该回调不用设置
 */
@property (weak, nonatomic) id<RTMPCGuestRtcDelegate> rtc_delegate;

/**
 实例化游客端对象

 @param delegate RTMP相关回调代理
 @param option 配置项
 @return 游客端对象
 */
- (instancetype)initWithDelegate:(id<RTMPCGuestRtmpDelegate>)delegate andOption:(RTMPCGuestOption *)option;
;

/**
 销毁游客端对象
 说明：销毁游客端资源，可在直播结束，页面关闭时调用。
 */
- (void)clear;

#pragma mark - Common function

/**
 设置音频是否传输，默认音频传输

 @param bEnable 设置YES,传输音频，设置NO,不传输音频
 */
- (void)setLocalAudioEnable:(bool)bEnable;
/**
 设置音频是否传输，默认视频传输

 @param bEnable 设置YES,传输视频，设置NO,不传输视频
 */
- (void)setLocalVideoEnable:(bool)bEnable;

/**
 设置本地视频采集

 @param render 视频显示对象;
 说明：方法用于申请连麦结果回调方法中（onRTCApplyLineResult）。连麦接通后，设置本地连麦图像采集。
 */
- (void)setLocalVideoCapturer:(UIView*)render;

/**
 设置其他连麦者视频窗口

 @param strRTCPubId 连麦者视频流id(用于标识连麦者发布的流)；
 @param render 显示对方视频；
 说明：该方法用于其他游客视频连麦接通回调方法（onRTCOpenVideoRender）中，设置其他游客连麦视频窗口。
 */
- (void)setRTCVideoRender:(NSString*)strRTCPubId andRender:(UIView*)render;

/**
 切换前后摄像头
 */
- (void)switchCamera;

/**
 打开手机闪光灯
 
 @param bOn YES为打开，NO为关闭；
 
 @return 返回成功与否
 说明：打开手机闪光灯。
 */
-(BOOL)openCameraTorchMode:(bool)bOn;

/**
 打开对焦功能(iOS特有)
 
 @param image 点击自动对焦时的图片；
 　说明：默认关闭自动对焦。
 */
- (void)setCameraFocusImage:(UIImage*)image;
/**
 设置相机焦距
 
 @param fDistance 焦距调整（1.0~3.0）；
 说明：默认为1.0。
 */
- (void)setCameraZoom:(CGFloat)fDistance;
/**
 获取相机当前焦距
 
 @return 焦距（1.0~3.0）
 返回值：相机当前焦距
 */
- (CGFloat)getCameraZoom;

 /**
 设置本地前置摄像头镜像是否打开
 
 @param bEnable YES为打开，NO为关闭
 @return 镜像成功与否
 说明：默认打开
 */
- (BOOL)setFontCameraMirrorEnable:(BOOL)bEnable;


#pragma mark Rtmp function for pull rtmp stream
/**
 开始RTMP播放

 @param strUrl RTMP拉流地址；
 @param render 视频显示对象；
 @return yes：成功 no：失败。
 */
- (BOOL)startRtmpPlay:(NSString*)strUrl andRender:(UIView*)render;
/**
 设置播放器显示模式
 
 @param eVideoRenderMode 显示模式
 说明：默认：AnyRTCVideoRenderScaleAspectFill，等比例填充视图模式
 */
- (void)updatePlayerRenderModel:(AnyRTCVideoRenderMode)eVideoRenderMode;


/**
 停止RTMP播放

 @return 成功或失败
 说明：调用此方法相当于停止拉流并且关闭RTC服务。
 */
- (BOOL)stopRtmpPlay;


#pragma mark RTC function for line

/**
 加入RTC连接

 @param strAnyRTCID 主播对应的strAnyRTCID；
 @param strUserID 游客业务平台的业务Id，可选，如果不设置strUserID，发消息接口不能使用；
 @param strUserData 游客业务平台的相关信息（昵称，头像等），可选；(限制512字节)
 @return 打开RTC成功与否，成功后可以进行连麦等操作；
 说明：
 strUserId,若不设置，发消息接口不能使用。
 strUserData,将会出现在游客连麦回调中，若不设置，人员上下线接口将无用，建议设置，此方法需在startRtmpPlay之后调用。

 */
- (BOOL)joinRTCLine:(NSString*)strAnyRTCID andUserID:(NSString*)strUserID andUserData:(NSString*)strUserData;

/**
 申请连麦

 @return YES:申请成功；NO:申请失败；
 说明：申请失败的时候，注意输出日志，权限问题。
 */
- (BOOL)applyRTCLine;

/**
 挂断连麦
 说明：游客取消连麦/挂断连麦均调此方法。
 */
- (void)hangupRTCLine;

/**
 发送消息
 
 @param eType 消息类型:RTC_Nomal_Message_Type:普通消息;RTC_Barrage_Message_Type:弹幕消息
 @param strUserName 用户昵称(最大256字节)，不能为空，否则发送失败；
 @param strUserHeaderUrl 用户头像，可选；
 @param strContent 消息内容(最大1024字节)，不能为空，否则发送失败；
 @return YES/NO 发送成功/发送失败；
 说明：默认普通消息，以上参数均会出现在游客/主播消息回调方法中, 如果加入RTC连麦（joinRTCLine）没有设置strUserId，发送失败。
 */

- (BOOL)sendUserMessage:(RTCMessageType)eType withUserName:(NSString*)strUserName andUserHeader:(NSString*)strUserHeaderUrl andContent:(NSString*)strContent;

/**
 关闭RTC连接
 说明：用于关闭RTC服务，将无法进行聊天互动，人员上下线等。
 */
- (void)leaveRTCLine;

#pragma mark - 白板功能模块

/**
 设置媒体共享回调
 */
@property (nonatomic, weak)id<AnyRTCUserShareBlockDelegate> share_delegate;


@end

#endif /* RTMPCGuestKit_h */
