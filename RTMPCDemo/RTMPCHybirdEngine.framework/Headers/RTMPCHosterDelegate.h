//
//  RTMPCHosterDelegate.h
//  RTMPCHosterDelegate
//
//  Created by EricTao on 16/7/16.
//  Copyright © 2016年 EricTao. All rights reserved.
//

#ifndef RTMPCHosterDelegate_h
#define RTMPCHosterDelegate_h
#import <AVFoundation/AVFoundation.h>

/**
 推流　RTMP 回调
 */
@protocol RTMPCHosterRtmpDelegate <NSObject>
@required
/**
 RTMP 服务连接成功
 说明：RTMP连接成功，视频正在缓存。
 */
- (void)onRtmpStreamOk;
/**
 RTMP服务重连

 @param nTimes 重连次数
 说明：RTMP服务重连。
 */
- (void)onRtmpStreamReconnecting:(int)nTimes;

/**
 RTMP 推流状态

 @param nDelayTime 推流的延迟时间（单位：ms）；
 @param nNetBand 当前的上行带宽（单位：byte）；
 说明：RTMP推流状态。
 */
- (void)onRtmpStreamStatus:(int)nDelayTime withNetBand:(int)nNetBand;

/**
 RTMP 服务连接失败

 @param nCode 状态码
 说明：RTMP推流失败,错误原因可查看nCode对应原因。
 */
- (void)onRtmpStreamFailed:(int)nCode;

/**
 RTMP 服务关闭
 说明:停止推流时回调该方法。
 */
- (void)onRtmpStreamClosed;

/**
 获取视频的原始采集数据

 @param sampleBuffer 视频数据
 说明：必须在RTMPCHybirdEngineKit　中调用useThreeCameraFilterSdk方法，该回调才有用。
 */
- (void)cameraSourceDidGetPixelBuffer:(CMSampleBufferRef)sampleBuffer;

@end

@protocol RTMPCHosterRtcDelegate <NSObject>
@required

/**
 创建RTC服务连接结果

 @param nCode 状态码
 说明:nCode==0的时，连接服务成功,nCode为其他值时均为失败，具体可查看nCode对应原因
 */
- (void)onRTCCreateLineResult:(int)nCode;
/**
 主播收到游客连麦请求

 @param strLivePeerId 连麦者标识id（用于标识连麦用户，每次连麦随机生成)；
 @param strUserId 游客在自己业务平台的Id；
 @param strUserData 游客加入RTC连接的自定义参数体（可查看游客端加入RTC连接方法)；
 说明：当有游客申请连麦时将会走此回调方法，可以在回调中调用拒绝（rejectRTCLine）或同意连麦（acceptRTCLine）。
 */
- (void)onRTCApplyToLine:(NSString*)strLivePeerId withUserId:(NSString*)strUserId withUserData:(NSString*)strUserData;

/**
 游客取消连麦申请，或者连麦已满

 @param nCode 状态码
 @param strLivePeerId 连麦者标识id（用于标识连麦用户，每次连麦随机生成）
 说明：游客取消申请连麦后将会回调此方法，或者同意别人的连麦，连麦数已满
 */
- (void)onRTCCancelLine:(int)nCode withLivePeerId:(NSString*)strLivePeerId;

/**
 RTC 服务关闭

 @param nCode 状态码
 说明：nCode==0成功 其他均为失败,具体请查看nCode对应的原因
 */
- (void)onRTCLineClosed:(int)nCode;

/**
 游客视频连麦接通

 @param strLivePeerId 连麦者标识id（用于标识连麦用户，每次连麦随机生成）
 @param strUserId 游客在开发者平台的用户Id；
 @param strUserData 游客加入RTC连接的自定义参数体（可查看游客端加入RTC连接方法)；
 说明：主播与游客的连麦接通后视频将要显示的回调，开发者需调用设置连麦者视频窗口（setRTCVideoRender）方法。*具体使用请查看主播端主要方法-设置连麦者视频窗口。
 */
- (void)onRTCOpenVideoRender:(NSString*)strLivePeerId withUserId:(NSString *)strUserId withUserData:(NSString*)strUserData;


/**
 游客视频连麦挂断

 @param strLivePeerId 连麦者标识Id（用于标识连麦用户，每次连麦随机生成)；
 @param strUserId 游客在开发者平台的用户Id；
 说明：主播与游客的连麦挂断后将会回调此方法；挂断不分游客主动挂断还是主播挂断游客，均会回调此方法，需本地移除连麦者视图。
 */
- (void)onRTCCloseVideoRender:(NSString*)strLivePeerId withUserId:(NSString *)strUserId;

/**
 游客音频连麦接通

 @param strLivePeerId 连麦者标识id（用于标识连麦用户，每次连麦随机生成）
 @param strUserId 游客在开发者平台的用户Id；
 strUserData: 游客加入RTC连接的自定义参数体（可查看游客端加入RTC连接方法）。
 说明：仅在音频直播时有效。
 */
- (void)onRTCOpenAudioLine:(NSString*)strLivePeerId withUserId:(NSString *)strUserId withUserData:(NSString*)strUserData;
/**
 游客音频连麦挂断
 
 @param strLivePeerId 连麦者标识Id（用于标识连麦用户，每次连麦随机生成）；
 @param strUserId 游客在开发者平台的用户Id；
 说明：仅在音频直播时有效。
 */
- (void)onRTCCloseAudioLine:(NSString*)strLivePeerId withUserId:(NSString *)strUserId;
/**
 视频窗口大小改变
 
 @param videoView 视频显示窗口
 @param size 视频大小
 说明：连麦以及主播视频窗口大小变化的回调。一般处理连麦视频窗口第一针视频显示。
 */
-(void) onRTCViewChanged:(UIView*)videoView didChangeVideoSize:(CGSize)size;
/**
 RTC音频检测
 
 @param strLivePeerId RTC服务生成的连麦者标识Id（用于标识连麦用户，每次连麦随机生成）
 @param strUserId  连麦者在自己平台的用户Id
 @param nTime 音频检测在nTime毫秒内不会再回调该方法（单位：毫秒）；
 说明：只有设置了音频模式（setAudioModel）才会有回调
 */
- (void)onRTCAudioActive:(NSString *)strLivePeerId withUserId:(NSString *)strUserId withShowTime:(int)nTime;

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
@end

#endif /* RTMPCHosterDelegate_h */
