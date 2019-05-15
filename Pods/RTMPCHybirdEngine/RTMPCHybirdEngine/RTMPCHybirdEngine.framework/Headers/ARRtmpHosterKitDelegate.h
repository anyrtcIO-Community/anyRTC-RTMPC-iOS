//
//  ARRtmpHosterKitDelegate.h
//  RTMPCHybirdEngine
//
//  Created by zjq on 2019/1/16.
//  Copyright © 2019 EricTao. All rights reserved.
//

#ifndef ARRtmpHosterKitDelegate_h
#define ARRtmpHosterKitDelegate_h

#import <AVFoundation/AVFoundation.h>
#import "ARRtmpEnum.h"

/**
 推流　RTMP 回调
 */
@protocol ARHosterRtmpDelegate <NSObject>
@required

/**
 RTMP 服务连接成功
 
 说明：RTMP连接成功，视频正在缓存。
 */
- (void)onRtmpStreamOk;

/**
 RTMP 服务重连
 
 @param times 重连次数
 */
- (void)onRtmpStreamReconnecting:(int)times;

/**
 RTMP 推流状态
 
 @param delayTime 推流的延迟时间（单位：ms）
 @param netBand 当前的上行带宽（单位：byte）
 */
- (void)onRtmpStreamStatus:(int)delayTime netBand:(int)netBand;

/**
 RTMP 服务连接失败
 
 @param code 状态码
 */
- (void)onRtmpStreamFailed:(ARRtmpCode)code;

/**
 RTMP 服务关闭
 
 说明：停止推流时回调该方法。
 */
- (void)onRtmpStreamClosed;

@end

@protocol ARHosterRtcDelegate <NSObject>

/**
 创建RTC服务连接结果
 
 @param code 状态码
 @param reason 错误原因，RTC错误或者token错误（错误值自己平台定义）
 */
- (void)onRTCCreateLineResult:(ARRtmpCode)code reason:(NSString *)reason;

/**
 主播收到游客连麦请求
 /Users/zjq/Downloads/anyRTC视频通信微信小程序集成指南.rtf
 @param peerId 连麦者标识Id（用于标识连麦用户，每次连麦随机生成)
 @param userId 游客在自己业务平台的Id
 @param userData 自定义参数（可查看游客端加入RTC连接方法)
 说明：当有游客申请连麦时将会走此回调方法，可以在回调中调用拒绝(rejectRTCLine)或同意连麦(acceptRTCLine)。
 */
- (void)onRTCApplyToLine:(NSString *)peerId userId:(NSString *)userId userData:(NSString *)userData;

/**
 游客取消连麦申请，或者连麦已满
 
 @param code 状态码
 @param peerId 连麦者标识Id（用于标识连麦用户，每次连麦随机生成）
 说明：游客取消申请连麦后将会回调此方法或者同意别人的连麦，连麦数已满
 */
- (void)onRTCCancelLine:(ARRtmpCode)code peerId:(NSString *)peerId;

/**
 RTC 服务关闭
 
 @param code 状态码
 */
- (void)onRTCLineClosed:(ARRtmpCode)code;

/**
 游客视频连麦接通
 
 @param peerId 连麦者标识Id（用于标识连麦用户，每次连麦随机生成）
 @param pubId 连麦者视频流Id(用于标识连麦者发布的流)
 @param userId 游客在开发者平台的用户Id
 @param userData 游客加入RTC连接的自定义参数体（可查看游客端加入RTC连接方法)
 说明：主播与游客的连麦接通后视频将要显示的回调，开发者需调用设置连麦者视频窗口（setRemoteVideoRender）方法。
 */
- (void)onRTCOpenRemoteVideoRender:(NSString *)peerId pubId:(NSString *)pubId userId:(NSString *)userId userData:(NSString *)userData;

/**
 游客视频连麦挂断
 
 @param peerId 连麦者标识Id（用于标识连麦用户，每次连麦随机生成)
 @param pubId 连麦者视频流Id(用于标识连麦者发布的流)
 @param userId 游客在开发者平台的用户Id
 说明：主播与游客的连麦挂断后将会回调此方法，挂断不分游客主动挂断还是主播挂断游客，均会回调此方法，需本地移除连麦者视图。
 */
- (void)onRTCCloseRemoteVideoRender:(NSString *)peerId pubId:(NSString *)pubId userId:(NSString *)userId;

/**
 游客音频连麦接通
 
 @param peerId 连麦者标识Id（用于标识连麦用户，每次连麦随机生成）
 @param userId 游客在开发者平台的用户Id
 @param userData 游客加入RTC连接的自定义参数体（可查看游客端加入RTC连接方法）
 说明：该回调仅在音频直播时有效。
 */
- (void)onRTCOpenRemoteAudioLine:(NSString *)peerId userId:(NSString *)userId userData:(NSString *)userData;

/**
 游客音频连麦挂断
 
 @param peerId 连麦者标识Id（用于标识连麦用户，每次连麦随机生成）
 @param userId 游客在开发者平台的用户Id
 说明：该回调仅在音频直播时有效。
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
 其他与会者音频检测回调
 
 @param peerId RTC服务生成的与会者标识Id（用于标识与会者用户，每次随机生成）
 @param userId 开发者自己平台的用户Id
 @param level 音频大小（0~100）
 @param time 音频检测在nTime毫秒内不会再回调该方法（单位：毫秒）
 说明：与会者关闭音频后（setLocalAudioEnable为NO）,该回调将不再回调。
 */
- (void)onRTCRemoteAudioActive:(NSString *)peerId userId:(NSString *)userId audioLevel:(int)level showTime:(int)time;

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


#pragma mark -  video data
/**
 获取视频的原始采集数据
 
 @param sampleBuffer 视频数据
 @return 视频对象（处理过或者没做处理）
 */
- (CVPixelBufferRef)onRTCCaptureVideoPixelBuffer:(CMSampleBufferRef)sampleBuffer;

@end


#endif /* ARRtmpHosterKitDelegate_h */

