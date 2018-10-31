//
//  RTMeetAudioKitDelegate.h
//  RTMeetEngine
//
//  Created by derek on 2017/10/19.
//  Copyright © 2017年 EricTao. All rights reserved.
//

#ifndef RTMeetAudioKitDelegate_h
#define RTMeetAudioKitDelegate_h

#import <UIKit/UIKit.h>

@protocol RTMeetAudioKitDelegate <NSObject>

@optional
/**
 加入会议成功的回调
 
 @param strAnyRTCId 会议号(在开发者业务系统中保持唯一的Id)；
 说明：加入会议成功。
 */
- (void)onRTCJoinMeetOK:(NSString*)strAnyRTCId;

/**
 加入会议失败
 
 @param strAnyRTCId 会议号(在开发者业务系统中保持唯一的Id)；
 @param nCode 状态码，错误原因可查看nCode对应原因；
 说明：加入会议失败。
 */
- (void)onRTCJoinMeetFailed:(NSString*)strAnyRTCId withCode:(int)nCode;

/**
 离开会议
 
 @param nCode 状态码，错误原因可查看nCode对应原因；
 说明：离开会议状态回调。
 */
-(void)onRTCLeaveMeet:(int) nCode;

-(void)onRTCUnPublic:(NSString*)strRTCPeerId withReason:(NSString*)strReason;
/**
 其他与会者加入（音频）
 
 @param strRTCPeerId RTC服务生成的标识Id (用于标识与会者，每次加入会议随机生成)；
 @param strUserId 开发者自己平台的Id；
 @param strUserData 开发者自己平台的相关信息（昵称，头像等)；
 说明：其他与会者进入会议的回调。
 */
- (void)onRTCOpenAudioTrack:(NSString*)strRTCPeerId withUserId:(NSString *)strUserId withUserData:(NSString*)strUserData;
/**
 其他与会者离开（音频）
 
 @param strRTCPeerId RTC服务生成的标识Id (用于标识与会者，每次加入会议随机生成)；
 @param strUserId 与开发者自己平台的Id；
 说明：其他与会者离开会议的回调。
 */
- (void)onRTCCloseAudioTrack:(NSString*)strRTCPeerId withUserId:(NSString *)strUserId;

/**
 其他与会者视频窗口的对音视频的操作
 
 @param strRTCPeerId  RTC服务生成的标识Id (用于标识与会者，每次加入会议随机生成)；
 @param bAudio yes为打开音频，no为关闭音频
 说明：比如对方关闭了音频，对方关闭了视频
 */
-(void)onRTCAVStatus:(NSString*) strRTCPeerId withAudio:(BOOL)bAudio;

/**
 RTC音频检测
 
 @param strRTCPeerId RTC服务生成的与会者标识Id（用于标识与会者用户，每次随机生成）
 @param strUserId 连麦者在自己平台的用户Id；
 @param nLevel 音频检测音量；（0~100）
 @param nTime 音频检测在nTime毫秒内不会再回调该方法（单位：毫秒）；
 说明：对方关闭音频后（setLocalAudioEnable为NO）,该回调将不再回调；对方关闭音频检测后（setAudioActiveCheck为NO）,该回调也将不再回调。
 */
-(void)onRTCAudioActive:(NSString*)strRTCPeerId withUserId:(NSString *)strUserId withAudioLevel:(int)nLevel withShowTime:(int)nTime;

/**
 网络状态
 
 @param strRTCPeerId RTC服务生成的与会者标识Id（用于标识与会者用户，每次随机生成）
 @param strUserId 连麦者在自己平台的用户Id；
 @param nNetSpeed 网络上行
 @param nPacketLost 丢包率
 */
- (void)onRtcNetworkStatus:(NSString*)strRTCPeerId withUserId:(NSString *)strUserId withNetSpeed:(int)nNetSpeed withPacketLost:(int)nPacketLost;

/**
 收到消息回调
 
 @param strUserId 发送消息者在自己平台下的Id；
 @param strUserName 发送消息者的昵称
 @param strUserHeaderUrl 发送者的头像
 @param strContent 消息内容
 说明：该参数来源均为发送消息时所带参数。
 */
- (void)onRTCUserMessage:(NSString*)strUserId withUserName:(NSString*)strUserName withUserHeader:(NSString*)strUserHeaderUrl withContent:(NSString*)strContent;

/**
 主持人上线（只有主持模式下的游客身份登录才有用）
 
 @param strRTCPeerId RTC服务生成的标识Id (用于标识与会者，每次加入会议随机生成)；
 @param strUserId 开发者自己平台的Id；
 @param strUserData 开发者自己平台的相关信息（昵称，头像等)；
 */
- (void)onRTCHosterOnLine:(NSString*)strRTCPeerId withUserId:(NSString*)strUserId withUserData:(NSString*)strUserData;

/**
 主持人下线（只有主持模式下的游客身份登录才有用）
 
 @param strRTCPeerId RTC服务生成的标识Id (用于标识与会者，每次加入会议随机生成)；
 */
- (void)onRTCHosterOffLine:(NSString*)strRTCPeerId;
/**
 1v1开启
 
 @param strRTCPeerId RTC服务生成的标识Id (用于标识与会者，每次加入会议随机生成)；
 @param strUserId 开发者自己平台的Id；
 @param strUserData 开发者自己平台的相关信息（昵称，头像等)；
 */
- (void)onRTCTalkOnlyOn:(NSString*)strRTCPeerId withUserId:(NSString*)strUserId withUserData:(NSString*)strUserData;

/**
 1v1关闭
 
 @param strRTCPeerId RTC服务生成的标识Id (用于标识与会者，每次加入会议随机生成)；
 */
- (void)onRtcTalkOnlyOff:(NSString*)strRTCPeerId;

/**
 检测服务链接与否
 
 @param bOk YES/NO 成功／失败
 */
- (void)onRTCCheckConnectionRealtime:(BOOL)bOk;


@end

#endif /* RTMeetAudioKitDelegate_h */
