//
//  RTMPCGuestDelegate.h
//  RTMPCHybirdEngine
//
//  Created by EricTao on 16/7/16.
//  Copyright © 2016年 EricTao. All rights reserved.
//

#ifndef RTMPCGuestDelegate_h
#define RTMPCGuestDelegate_h

/**
 播放rtmp流的相关回调
 - (BOOL)startRtmpPlay:(NSString*)strUrl andRender:(UIView*)render;
 */
@protocol RTMPCGuestRtmpDelegate <NSObject>
@required

/**
 RTMP 连接成功
 说明：RTMP服务器连接成功，视频正在缓存。
 */
- (void)onRtmpPlayerOk;

/**
 RTMP 开始播放
　说明：第一帧视频图像
 */
- (void)onRtmpPlayerStart;

/**
 RTMP 当前播放状态

 @param nCacheTime 缓存时间 (单位：ms)；
 @param nBitrate 当前码率大小（单位：byte）；
 说明：当主播处于直播状态会一直调用此方法。
 */
- (void)onRtmpPlayerStatus:(int)nCacheTime withBitrate:(int)nBitrate;

/**
 RTMP播放缓冲进度

 @param nPercent 缓冲百分比，0-100
 说明：回调该方法时，nPercent为0时，页面可以进行缓冲提示。当为100时，缓冲提示去掉。
 */
- (void)onRtmpPlayerLoading:(int)nPercent;

/**
 RTMP播放器关闭

 @param nCode 状态码
 说明：主播停止推流会回调此方法。
 */
- (void)onRtmpPlayerClosed:(int)nCode;
@end

@protocol RTMPCGuestRtcDelegate <NSObject>
@required

/**
 RTC服务连接结果

 @param nCode 状态码;
 说明：nCode==0时joinRTC服务成功，nCode为其它值，具体原因可查看状态码
 */
- (void)onRTCJoinLineResult:(int)nCode;

/**
 游客申请连麦结果回调

 @param nCode 状态码；
 说明：此时应调用设置本地视频采集（setVideoCapturer），nCode==0的时候意味着连麦成功，nCode为其它值，具体原因可查看状态码
 */
- (void)onRTCApplyLineResult:(int)nCode;

/**
 主播挂断游客连麦
 说明：此时应移除本地连麦窗口，主播挂断别人的不会走该回调
 */
- (void)onRTCHangupLine;

/**
 断开RTC服务连接

 @param nCode 状态码
 说明：１：主播端关闭直播断开RTC服务后会回调此方法。２：自己加入RTC后，断网后在链接网络，会回调此方法
 */
- (void)onRTCLineLeave:(int)nCode;

/**
 其他游客视频连麦接通

 @param strLivePeerId 连麦者标识id（用于标识连麦用户，每次连麦随机生成）
 @param strRTCPubId 连麦者视频流id(用于标识连麦者发布的流)；
 @param strUserId 游客业务平台的用户id；
 @param strUserData 游客业务平台的相关信息（昵称，头像等)；
 说明：游客同样也在连麦中才会调用，此时应调用设置其它连麦者视频窗口（setRTCVideoRender）方法用于显示连麦者图像。
 */
- (void)onRTCOpenVideoRender:(NSString*)strLivePeerId withRTCPubId:(NSString *)strRTCPubId withUserId:(NSString *)strUserId withUserData:(NSString*)strUserData;

/**
 其他游客视频连麦挂断

 @param strLivePeerId 连麦者标识id（用于标识连麦用户，每次连麦随机生成)
 @param strRTCPubId 连麦者视频流id(用于标识连麦者发布的流)；
 @param strUserId 游客业务平台的用户id
 说明：
 1.游客同样也在连麦中才会走该回调；
 2.不论是其他游客主动挂断连麦还是主播挂断游客连麦均会走该回调。
 只有在连麦中才会调用，此时应移除本地连麦者图像。
 */
- (void)onRTCCloseVideoRender:(NSString*)strLivePeerId withRTCPubId:(NSString *)strRTCPubId withUserId:(NSString *)strUserId;
/**
 其他游客音频连麦接通
 
 @param strLivePeerId 连麦者标识id（用于标识连麦用户，每次连麦随机生成）
 @param strUserId 游客业务平台的用户id
 @param strUserData 游客业务平台的相关信息（昵称，头像等）
 说明:仅在音频直播时有效。
 */
- (void)onRTCOpenAudioLine:(NSString*)strLivePeerId withUserId:(NSString *)strUserId withUserData:(NSString*)strUserData;
/**
 其他游客连麦音频挂断
 
 @param strLivePeerId 请求ID
 @param strUserId 连麦用户的第三方ID(第三方ID，是自己平台的用户ID,请保持平台唯一)
 说明：仅在音频直播时有效。
 */
- (void)onRTCCloseAudioLine:(NSString*)strLivePeerId withUserId:(NSString *)strUserId;

/**
 RTC音频检测
 
 @param strLivePeerId RTC服务生成的连麦者标识Id（用于标识连麦用户，每次连麦随机生成）
 @param strUserId  连麦者在自己平台的用户Id
 @param nTime 音频检测在nTime毫秒内不会再回调该方法（单位：毫秒）；
 说明：只有设置了音频模式（setAudioModel）才会有回调
 */
- (void)onRTCAudioActive:(NSString *)strLivePeerId withUserId:(NSString *)strUserId withShowTime:(int)nTime;

/**
 其他连麦者或主播视频窗口的对音视频的操作
 
 @param strRTCPeerId  RTC服务生成的标识Id (用于标识与会者，每次加入会议随机生成)；
 @param bAudio yes为打开音频，no为关闭音频
 @param bVideo yes为打开视频，no为关闭视频
 说明：比如对方关闭了音频，对方关闭了视频
 */
-(void)onRTCAVStatus:(NSString*) strRTCPeerId withAudio:(BOOL)bAudio withVideo:(BOOL)bVideo;


/**
 视频窗口大小改变
 
 @param videoView 视频显示窗口
 @param size 视频大小
 说明：连麦以及主播视频窗口大小变化的回调。一般处理连麦视频窗口第一针视频显示。
 */
-(void) onRTCViewChanged:(UIView*)videoView didChangeVideoSize:(CGSize)size;

@optional
/**
 收到消息回调
 
 @param nType 消息类型:0:普通消息;1:弹幕消息
 @param strUserId 发送消息者在自己平台下的Id；
 @param strUserName 发送消息者的昵称
 @param strUserHeaderUrl 发送者的头像
 @param strContent 消息内容
 说明：该参数来源均为发送消息时所带参数。
 */
- (void)onRTCUserMessage:(int)nType withUserId:(NSString*)strUserId withUserName:(NSString*)strUserName withUserHeader:(NSString*)strUserHeaderUrl withContent:(NSString*)strContent;

/**
 直播间实时在线人数变化通知
 
 @param strServerId 服务器Id，用于请求人员列表的参数
 @param strRoomId 房间Id,用于请求人员列表的参数
 @param nTotalMember 当前在线人数
 说明:strServerId和strRoomId参数用于请求人员列表。
 */
-(void)onRTCMemberListNotify:(NSString*)strServerId withRoomId:(NSString*)strRoomId withAllMember:(int) nTotalMember;

- (void)onRTCLiveStart;
- (void)onRTCLiveStop;
@end

#endif /* RTMPCGuestDelegate_h */
