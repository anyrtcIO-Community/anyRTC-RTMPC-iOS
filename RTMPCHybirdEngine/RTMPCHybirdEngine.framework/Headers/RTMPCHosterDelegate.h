//
//  RTMPCHosterDelegate.h
//  RTMPCHosterDelegate
//
//  Created by EricTao on 16/7/16.
//  Copyright © 2016年 EricTao. All rights reserved.
//

#ifndef RTMPCHosterDelegate_h
#define RTMPCHosterDelegate_h

//* 所有的回调都在主线程上
@protocol RTMPCHosterRtmpDelegate <NSObject>
@required
/**
 *   RTMP 服务连接成功
 */
- (void)OnRtmpStreamOK;
/**
 *  RTMP 服务重连
 *
 *  @param times 重连次数
 */
- (void)OnRtmpStreamReconnecting:(int) times;
/**
 *  RTMP 流数据的延迟时间，以及网络带宽
 *
 *  @param delayMs 延迟时间 (ms)
 *  @param netBand 网络带宽
 */
- (void)OnRtmpStreamStatus:(int) delayMs withNetBand:(int) netBand;
/**
 *  RTMP 服务连接失败的回调
 *
 *  @param code 失败原因（RTCCommon.h 原因参照）
 */
- (void)OnRtmpStreamFailed:(int) code;
/**
 *  RTMP 服务关闭的回调
 */
- (void)OnRtmpStreamClosed;
/**
 音频监测回调
 
 @param nsCustomID 用户所在平台的ID(每秒回调2次)
 @param leave 0~100 （1~5可能是杂音所致，根据自己的需求而定）
 */
- (void)OnRtmpAudioLevel:(NSString *)nsCustomID withLevel:(int)Level;

@end


@protocol RTMPCHosterRtcDelegate <NSObject>
@required
/**
 *  RTC 服务连接状态的回调
 *
 *  @param code      如果是0，成功，其他失败
 *  @param strReason 原因
 */
- (void)OnRTCOpenLineResult:(int) code withReason:(NSString*)strReason;
/**
 *  主播收到游客的连麦请求
 *
 *  @param strLivePeerID 游客的请求ID
 *  @param strCustomID   游客所在平台的ID
 *  @param strUserData   游客所在平台的相关信息，数据最好是jason格式(eg:头像 、昵称等等;)
 */
- (void)OnRTCApplyToLine:(NSString*)strLivePeerID withCustomID:(NSString*)strCustomID withUserData:(NSString*)strUserData;
/**
 *  收到游客端挂断连麦
 *
 *  @param strLivePeerID 游客的请求ID（跟申请连麦的时候的请求ID是一致的）
 */
- (void)OnRTCCancelLine:(NSString*)strLivePeerID;
/**
 *  RTC 服务关闭
 *
 *  @param code      如果是0，成功，其他失败
 *  @param strReason 原因
 */
- (void)OnRTCLineClosed:(int) code withReason:(NSString*)strReason;
/**
 *  主播同意游客端的连麦请求，视频将要显示的回调。
 *
 *  @param strLivePeerID 游客端的请求ID
 */
- (void)OnRTCOpenVideoRender:(NSString*)strLivePeerID withCustomID:(NSString *)nsCustomID;
/**
 *  主播收到其他游客端连麦结束的回调（一般是先收到OnRTCCancelLine 后执行 OnRTCCloseVideoRender）
 *
 *  @param strLivePeerID other's peer id
 *  @param nsCustomID 连麦用户的第三方ID(第三方ID，是自己平台的用户ID,请保持平台唯一)
 */
- (void)OnRTCCloseVideoRender:(NSString*)strLivePeerID withCustomID:(NSString *)nsCustomID;

/**
 音频连麦成功回调接口(自己和其他人连麦都会回调)

 @param strLivePeerID 请求ID
 @param nsCustomID 连麦用户的第三方ID(第三方ID，是自己平台的用户ID,请保持平台唯一) 
 @param nsCustomID 连麦用户的第三方ID(第三方ID，是自己平台的用户ID,请保持平台唯一)
 */
- (void)OnRTCOpenAudioLine:(NSString*)strLivePeerID withCustomID:(NSString *)nsCustomID;
/**
 音频连麦结束回调接口(自己和其他人连麦都会回调)
 
 @param strLivePeerID 请求ID
 @param nsCustomID 连麦用户的第三方ID(第三方ID，是自己平台的用户ID,请保持平台唯一)
 */
- (void)OnRTCCloseAudioLine:(NSString*)strLivePeerID withCustomID:(NSString *)nsCustomID;

@optional
/**
 *  Messages
 *
 *  @param nsCustomId other's platform  user id
 *  @param nsCustomName other's platform  user nick name
 *  @param nsCustomHeader other's platform user header url
 *  @param nsContent  message
 */
- (void)OnRTCUserMessage:(NSString*)nsCustomId withCustomName:(NSString*)nsCustomName withCustomHeader:(NSString*)nsCustomHeader withContent:(NSString*)nsContent;
/**
 *  Barrage
 *
 *  @param nsCustomId other's platform  user id
 *  @param nsCustomName other's platform  user nick name
 *  @param nsCustomHeader other's platform user header url
 *  @param nsContent  barrage
 */
- (void)OnRTCUserBarrage:(NSString*)nsCustomId withCustomName:(NSString*)nsCustomName withCustomHeader:(NSString*)nsCustomHeader withContent:(NSString*)nsContent;
/**
 *  All member count in this live.
 *
 *  @param nTotal all member count
 */
- (void)OnRTCMemberListWillUpdate:(int)nTotalMember;
/**
 *   Got online member
 *
 *  @param nsCustomId other's platform  user id
 *  @param nsUserData other's platform user data
 */
- (void)OnRTCMember:(NSString*)nsCustomId withUserData:(NSString*)nsUserData;
/**
 *   Got member list is done
 */
- (void)OnRTCMemberListUpdateDone;
@end

#endif /* RTMPCHosterDelegate_h */
