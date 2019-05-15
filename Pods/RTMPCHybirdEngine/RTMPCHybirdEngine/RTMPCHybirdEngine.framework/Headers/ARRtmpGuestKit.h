//
//  ARRtmpGuestKit.h
//  RTMPCHybirdEngine
//
//  Created by zjq on 2019/1/16.
//  Copyright © 2019 EricTao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ARRtmpGuestKitDelegate.h"
#import "ARShareDelegate.h"
#import "ARGuestOption.h"

NS_ASSUME_NONNULL_BEGIN

@interface ARRtmpGuestKit : NSObject

/**
 RTC 相关回调代理，如果不用RTC，该回调不用设置
 */
@property (weak, nonatomic) id<ARGuestRtcDelegate> rtc_delegate;

/**
 实例化游客对象
 
 @param delegate RTMP相关回调代理
 @param option 配置项
 @return 游客端对象
 */
- (instancetype)initWithDelegate:(id<ARGuestRtmpDelegate>)delegate option:(ARGuestOption *)option;

/**
 销毁游客端对象
 
 说明：销毁游客端资源，可在直播结束，页面关闭时调用。
 */
- (void)clear;

#pragma mark - Common function

/**
 设置音频是否传输
 
 @param enable YES传输音频，NO不传输音频，默认音频传输
 */
- (void)setLocalAudioEnable:(BOOL)enable;

/**
 设置视频是否传输
 
 @param enable YES传输视频，NO不传输视频，默认视频传输
 */
- (void)setLocalVideoEnable:(BOOL)enable;

/**
 设置本地视频采集
 
 @param render 视频显示对象
 说明：用于连麦接通后(onRTCApplyLineResult)，设置本地连麦图像采集。
 */
- (void)setLocalVideoCapturer:(UIView *)render;

/**
 设置其他连麦者视频窗口
 
 @param render 显示对方视频
 @param pubId 连麦者视频流id(用于标识连麦者发布的流)
 说明：该方法用于其他游客视频连麦接通回调方法（onRTCOpenRemoteVideoRender）中，设置其他游客连麦视频窗口
 */
- (void)setRemoteVideoRender:(UIView *)render pubId:(NSString *)pubId;

/**
 切换前后摄像头
 */
- (void)switchCamera;

/**
 打开手机闪光灯
 
 @param on YES打开，NO关闭
 @return 操作是否成功
 */
-(BOOL)openCameraTorchMode:(BOOL)on;

/**
 打开对焦功能(iOS特有)
 
 @param image 点击自动对焦时的图片
 说明：默认关闭自动对焦。
 */
- (void)setCameraFocusImage:(UIImage *)image;

/**
 设置相机焦距
 
 @param distance 焦距调整(1.0~3.0)，默认为1.0
 */
- (void)setCameraZoom:(CGFloat)distance;

/**
 获取相机当前焦距
 
 @return 相机当前焦距(1.0~3.0)
 */
- (CGFloat)getCameraZoom;

/**
 设置本地前置摄像头镜像是否打开
 
 @param enable YES为打开，NO为关闭，默认打开
 @return 镜像成功与否
 */
- (BOOL)setFontCameraMirrorEnable:(BOOL)enable;


#pragma mark Rtmp function for pull rtmp stream

/**
 开始RTMP播放
 
 @param rtmpUrl RTMP拉流地址
 @param render 视频显示窗口,该参数可为空
 @return YES成功，NO失败
 */
- (BOOL)startRtmpPlay:(NSString *)rtmpUrl render:(UIView *)render;

/**
 设置播放器显示模式
 
 @param videoRenderMode 显示模式，默认ARVideoRenderScaleAspectFill，等比例填充视图模式
 */
- (void)updatePlayerRenderModel:(ARVideoRenderMode)videoRenderMode;

/**
 停止RTMP播放
 
 @return操作是否成功。
 说明：调用此方法相当于停止拉流并且关闭RTC服务。
 */
- (BOOL)stopRtmpPlay;


#pragma mark RTC function for line

/**
 加入RTC直播间

 @param token 令牌:客户端向自己服务申请获得，参考企业级安全指南()
 @param liveId 对应主播端的liveId
 @param userId 游客用户id
 @param userData 游客其他相关信息（昵称，头像等）(限制512字节)
 @return 加入RTC成功与否，成功后可以进行连麦等操作
 说明：userId若不设置，发消息接口不能使用。userData将会出现在游客连麦回调中，若不设置，人员上下线接口将无用，建议设置，此方法需在startRtmpPlay之后调用。
 */
- (BOOL)joinRTCLineByToken:(NSString* _Nullable)token
                    liveId:(NSString*)liveId
                    userID:(NSString *)userId
                  userData:(NSString *)userData;
/**
 申请连麦
 
 @return YES申请成功，NO申请失败
 说明：申请失败的时候，注意输出日志，权限问题。
 */
- (BOOL)applyRTCLine;

/**
 挂断连麦
 
 说明：游客取消连麦、挂断连麦均调此方法。
 */
- (void)hangupRTCLine;

/**
 发送消息
 
 @param type 消息类型，ARNomalMessageType普通消息，ARBarrageMessageType弹幕消息
 @param userName 用户昵称，不能为空，否则发送失败(最大256字节)
 @param headerUrl 用户头像，可选(最大512字节)
 @param content 消息内容，不能为空，否则发送失败(最大1024字节)
 @return YES发送成功，NO发送失败
 说明：默认普通消息，以上参数均会出现在游客/主播消息回调方法中, 如果加入RTC连麦（joinRTCLine）没有设置userId，发送失败。
 */

- (BOOL)sendUserMessage:(ARMessageType)type userName:(NSString *)userName userHeader:(NSString *)headerUrl content:(NSString *)content;

/**
 关闭RTC连接
 
 说明：用于关闭RTC服务，将无法进行聊天互动，人员上下线等。
 */
- (void)leaveRTCLine;

#pragma mark - 白板功能模块

/**
 设置媒体共享回调
 */
@property (nonatomic, weak)id<ARShareDelegate> share_delegate;


@end

NS_ASSUME_NONNULL_END

