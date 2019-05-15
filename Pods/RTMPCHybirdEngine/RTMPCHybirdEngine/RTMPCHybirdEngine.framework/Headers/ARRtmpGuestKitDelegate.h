//
//  ARRtmpGuestKitDelegate.h
//  RTMPCHybirdEngine
//
//  Created by zjq on 2019/1/16.
//  Copyright © 2019 EricTao. All rights reserved.
//

#ifndef ARRtmpGuestKitDelegate_h
#define ARRtmpGuestKitDelegate_h

#import "ARRtmpEnum.h"

@protocol ARGuestRtmpDelegate <NSObject>
@required

/**
 RTMP 连接成功
 说明：RTMP服务器连接成功，视频正在缓存。
 */
- (void)onRtmpPlayerOk;

/**
 RTMP 开始播放
 说明：第一帧视频图像。
 */
- (void)onRtmpPlayerStart;

/**
 RTMP 当前播放状态
 
 @param cacheTime 缓存时间 (单位：ms)
 @param bitrate 当前码率大小（单位：byte）
 说明：当主播处于直播状态会一直调用此方法。
 */
- (void)onRtmpPlayerStatus:(int)cacheTime bitrate:(int)bitrate;

/**
 RTMP播放缓冲进度
 
 @param percent 缓冲百分比(0-100)
 说明：回调该方法时，percent为0时，页面可以进行缓冲提示，当为100时，缓冲提示去掉
 */
- (void)onRtmpPlayerLoading:(int)percent;

/**
 RTMP播放器关闭
 
 @param code 状态码
 说明：主播停止推流会回调此方法。
 */
- (void)onRtmpPlayerClosed:(ARRtmpCode)code;

@end

@protocol ARGuestRtcDelegate <NSObject>
@required

/**
 RTC服务连接结果
 
 @param code 状态码
 @param reason 错误原因，RTC错误或者token错误（错误值自己平台定义）
 说明：code为0时joinRTC服务成功，若code为其它值，可查看状态码。
 */
- (void)onRTCJoinLineResult:(ARRtmpCode)code reason:(NSString *)reason;

/**
 游客申请连麦结果回调
 
 @param code 状态码
 说明：此时应调用设置本地视频采集（setLocalVideoCapturer），code为0时意味着连麦成功，code为其它值，具体原因可查看状态码。
 */
- (void)onRTCApplyLineResult:(ARRtmpCode)code;

/**
 主播挂断游客连麦
 
 说明：此时应移除本地连麦窗口，主播挂断别人的不会走该回调
 */
- (void)onRTCHangupLine;

/**
 断开RTC服务连接
 
 @param code 状态码
 说明：主播端关闭直播断开RTC服务后会回调此方法。自己加入RTC后，断网后在链接网络，会回调此方法
 */
- (void)onRTCLineLeave:(ARRtmpCode)code;

/**
 其他游客视频连麦接通
 
 @param peerId 连麦者标识Id（用于标识连麦用户，每次连麦随机生成）
 @param pubId 连麦者视频流Id(用于标识连麦者发布的流)
 @param userId 游客业务平台的用户Id
 @param userData 游客业务平台的相关信息（昵称，头像等)
 说明：游客同样也在连麦中才会调用，此时应调用设置其它连麦者视频窗口(setRemoteVideoRender)方法用于显示连麦者图像。
 */
- (void)onRTCOpenRemoteVideoRender:(NSString *)peerId pubId:(NSString *)pubId userId:(NSString *)userId userData:(NSString *)userData;

/**
 其他游客视频连麦挂断
 
 @param peerId 连麦者标识Id（用于标识连麦用户，每次连麦随机生成)
 @param pubId 连麦者视频流Id(用于标识连麦者发布的流)
 @param userId 游客业务平台的用户Id
 说明：游客同样也在连麦中才会走该回调。不论是其他游客主动挂断连麦还是主播挂断游客连麦均会走该回调。只有在连麦中才会调用，此时应移除本地连麦者图像。
 */
- (void)onRTCCloseRemoteVideoRender:(NSString *)peerId pubId:(NSString *)pubId userId:(NSString *)userId;

/**
 其他游客音频连麦接通
 
 @param peerId 连麦者标识Id（用于标识连麦用户，每次连麦随机生成）
 @param userId 游客业务平台的用户Id
 @param userData 游客业务平台的相关信息（昵称，头像等）
 说明：仅在音频直播时有效。
 */
- (void)onRTCOpenRemoteAudioLine:(NSString *)peerId userId:(NSString *)userId userData:(NSString *)userData;

/**
 其他游客连麦音频挂断
 
 @param peerId 连麦者标识Id（用于标识连麦用户，每次连麦随机生成）
 @param userId 连麦用户的第三方Id，请保持平台唯一
 说明：仅在音频直播时有效。
 */
- (void)onRTCCloseRemoteAudioLine:(NSString *)peerId userId:(NSString *)userId;

#pragma mark - 音视频状态回调

/**
 其他人对音视频的操作
 
 @param peerId RTC服务生成的标识Id (用于标识与会者，每次加入会议随机生成)
 @param audio YES为打开音频，NO为关闭音频
 @param video YES为打开视频，NO为关闭视频
 */
- (void)onRTCRemoteAVStatus:(NSString *)peerId audio:(BOOL)audio video:(BOOL)video;

#pragma mark - 视频第一帧的回调、视频大小变化回调

/**
 本地Player播放第一帧
 
 @param size 视频窗口大小
 */
- (void)onRTCFirstPlayerVideoFrame:(CGSize)size;

/**
 本地视频第一帧
 
 @param size 视频窗口大小
 */
- (void)onRTCFirstLocalVideoFrame:(CGSize)size;

/**
 远程视频第一帧
 
 @param size 视频窗口大小
 @param pubId RTC服务生成流的Id (用于标识与会者发布的流)
 */
- (void)onRTCFirstRemoteVideoFrame:(CGSize)size pubId:(NSString *)pubId;

/**
 本地Player窗口大小的回调
 
 @param size 视频窗口大小
 */
- (void)onRTCPlayerViewChanged:(CGSize)size ;

/**
 本地窗口大小的回调
 
 @param size 视频窗口大小
 */
- (void)onRTCLocalVideoViewChanged:(CGSize)size;

/**
 远程窗口大小的回调
 
 @param size 视频窗口大小
 @param pubId RTC服务生成流的Id (用于标识与会者发布的流)
 */
- (void)onRTCRemoteVideoViewChanged:(CGSize)size pubId:(NSString *)pubId;

#pragma mark - 音频检测

/**
 本地音频检测回调
 
 @param level 音频大小（0~100）
 @param time 音频检测在nTime毫秒内不会再回调该方法（单位：毫秒）
 说明：本地关闭音频后（setLocalAudioEnable为NO）,该回调将不再回调。
 */
- (void)onRTCLocalAudioActive:(int)level showTime:(int)time;

/**
 主持人音频检测
 
 @param userId 主持人的用户Id
 @param level 音频大小（0~100）
 @param time 音频检测在nTime毫秒内不会再回调该方法（单位：毫秒）
 */
- (void)onRTCHosterAudioActive:(NSString *)userId audioLevel:(int)level showTime:(int)time;

/**
 其他与会者音频检测回调
 
 @param peerId RTC服务生成的与会者标识Id（用于标识与会者用户，每次随机生成）
 @param userId 开发者自己平台的用户Id
 @param level 音频大小（0~100）
 @param time 音频检测在nTime毫秒内不会再回调该方法（单位：毫秒）
 说明：与会者关闭音频后（setLocalAudioEnable为NO）,该回调将不再回调。
 */
- (void)onRTCRemoteAudioActive:(NSString *)peerId userId:(NSString *)userId audioLevel:(int)level showTime:(int)time;

#pragma mark - 消息以及人员变化通知
@optional
/**
 收到消息回调
 
 @param type 消息类型，ARNomalMessageType普通消息，ARBarrageMessageType弹幕消息
 @param userId 发送消息者在自己平台下的Id
 @param userName 发送消息者的昵称
 @param headerUrl 发送者的头像
 @param content 消息内容
 */
- (void)onRTCUserMessage:(ARMessageType)type userId:(NSString *)userId userName:(NSString *)userName userHeader:(NSString *)headerUrl content:(NSString *)content;

/**
 直播间实时在线人数变化通知
 
 @param serverId 服务器Id
 @param roomId 房间Id
 @param totalMember 当前在线人数
 说明：serverId和roomId参数用于请求人员列表。
 */
- (void)onRTCMemberListNotify:(NSString *)serverId roomId:(NSString *)roomId allMember:(int)totalMember;

/**
 直播开始
 */
- (void)onRTCLiveStart;

/**
 直播结束
 */
- (void)onRTCLiveStop;

@end

#endif /* ARRtmpGuestKitDelegate_h */

