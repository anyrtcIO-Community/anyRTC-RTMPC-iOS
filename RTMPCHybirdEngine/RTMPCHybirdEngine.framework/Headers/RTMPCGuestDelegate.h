//
//  RTMPCGuestDelegate.h
//  RTMPCHybirdEngine
//
//  Created by EricTao on 16/7/16.
//  Copyright © 2016年 EricTao. All rights reserved.
//

#ifndef RTMPCGuestDelegate_h
#define RTMPCGuestDelegate_h
//* 所有的回调都在主线程上
@protocol RTMPCGuestRtmpDelegate <NSObject>
@required
/**
 *    RTMP 服务连接成功
 */
- (void)OnRtmplayerOK;
/**
 *  RTMP 缓存状态以及当前码率
 *
 *  @param cacheTime 缓存时间 (ms)
 *  @param curBitrate 码率
 */
- (void)OnRtmplayerStatus:(int) cacheTime withBitrate:(int) curBitrate;
/**
 *   RTMP 播放器开始播放（用于第一针播放，或者播放过程中缓存后继续播放）
 */
- (void)OnRtmplayerStart;
/**
 *  缓存时间（ms）
 *
 *  @param time (ms)
 */
- (void)OnRtmplayerCache:(int) time;
/**
 *  rtmp 播放器关闭
 *
 *  @param errcode 错误code
 */
- (void)OnRtmplayerClosed:(int) errcode;

/**
 音频监测回到

 @param nsCustomID 用户所在平台的ID(每秒回调2次)
 @param leave 0~100 （1~5可能是杂音所致，根据自己的需求而定）
 */
- (void)OnRtmpAudioLevel:(NSString *)nsCustomID withLevel:(int)Level;

@end

@protocol RTMPCGuestRtcDelegate <NSObject>
@required
/**
 *  加入RTC的状态回调
 *
 *  @param code      如果是0成功，其他的失败
 *  @param strReason 原因
 */
- (void)OnRTCJoinLineResult:(int) code withReason:(NSString*)strReason;
/**
 *  游客申请向主播连麦，主播同意和不同意的回调
 *
 *  @param code 0 同意，其他不同意
 */
- (void)OnRTCApplyLineResult:(int) code;

/**
 *  游客收到主播挂断自己连麦的回调
 */
- (void)OnRTCHangupLine;

/**
 *  RTC 服务关闭
 *
 *  @param code      0关闭成功，其他关闭失败
 *  @param strReason 原因
 */
- (void)OnRTCLineLeave:(int) code withReason:(NSString*)strReason;
/**
 *  游客连麦后收到视频即将显示的回调，和连麦后收到其他用户的连麦窗口
 *
 *  @param strLivePeerID 游客请求的ID(可以判断是自己还是别人)
 *  @param nsCustomID 连麦用户的第三方ID(第三方ID，是自己平台的用户ID,请保持平台唯一)
 */
- (void)OnRTCOpenVideoRender:(NSString*)strLivePeerID withCustomID:(NSString *)nsCustomID;
/**
 *  取消连麦后收到视频即将消失的回调
 *
 *  @param strLivePeerID 游客请求的ID(可以判断是自己还是别人)
 *  @param nsCustomID 连麦用户的第三方ID(第三方ID，是自己平台的用户ID,请保持平台唯一)
 */
- (void)OnRTCCloseVideoRender:(NSString*)strLivePeerID withCustomID:(NSString *)nsCustomID;
/**
 音频连麦成功回调接口(自己和其他人连麦都会回调)
 
 @param strLivePeerID 请求ID
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
/**
 该直播间开始直播（前提：RTC服务打开）
 
 @param nsLiveInfo 直播间信息
 */
- (void)OnRTCLiveStart;

/**
 直播间停止直播
 */
- (void)OnRTCLiveStop;

@end

#endif /* RTMPCGuestDelegate_h */
