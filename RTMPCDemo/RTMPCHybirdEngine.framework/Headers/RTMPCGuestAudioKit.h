//
//  RTMPCGuestAudioKit.h
//  RTMPCHybirdEngine
//
//  Created by derek on 2017/11/9.
//  Copyright © 2017年 EricTao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RTMPCGuestDelegate.h"
#import "RTCCommon.h"

@interface RTMPCGuestAudioKit : NSObject
/**
 RTC 相关回调代理，如果不用RTC，该回调不用设置
 */
@property (weak, nonatomic) id<RTMPCGuestRtcDelegate> rtc_delegate;

/**
 实例化游客端对象
 
 @param delegate RTMP相关回调代理
 @return 游客端对象
 */
- (instancetype)initWithDelegate:(id<RTMPCGuestRtmpDelegate>)delegate withAudioDetect:(BOOL)audioDetect;
;

/**
 销毁游客端对象
 说明：销毁游客端资源，可在直播结束，页面关闭时调用。
 */
- (void)clear;

#pragma mark Rtmp function for pull rtmp stream
/**
 开始RTMP播放
 
 @param strUrl RTMP拉流地址；
 @return yes：成功 no：失败。
 */
- (BOOL)startRtmpPlay:(NSString*)strUrl;

/**
 设置音频是否传输，默认音频传输
 
 @param bEnable 设置YES,传输音频，设置NO,不传输音频
 */
- (void)setLocalAudioEnable:(bool)bEnable;

/**
 停止RTMP播放
 
 @return 成功或失败
 说明：调用此方法相当于停止拉流并且关闭RTC服务。
 */
- (BOOL)stopRtmpPlay;

#pragma mark RTC function for line

/**
 加入RTC连接
 
 @param strAnyRTCId 主播对应的strAnyRTCId；
 @param strUserId 游客业务平台的业务Id，可选，如果不设置strUserId，发消息接口不能使用；
 @param strUserData 游客业务平台的相关信息（昵称，头像等），可选；(限制512字节)
 @return 打开RTC成功与否，成功后可以进行连麦等操作；
 说明：
 strUserId,若不设置，发消息接口不能使用。
 strUserData,将会出现在游客连麦回调中，若不设置，人员上下线接口将无用，建议设置，此方法需在startRtmpPlay之后调用。
 
 */
- (BOOL)joinRTCLine:(NSString*)strAnyRTCId andUserID:(NSString*)strUserId andUserData:(NSString*)strUserData;

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
 
 @param nType 消息类型:0:普通消息;1:弹幕消息；
 @param strUserName 用户昵称(最大256字节)，不能为空，否则发送失败；
 @param strUserHeaderUrl 用户头像，可选；
 @param strContent 消息内容(最大1024字节)，不能为空，否则发送失败；
 @return YES/NO 发送成功/发送失败；
 说明：默认普通消息，以上参数均会出现在游客/主播消息回调方法中, 如果加入RTC连麦（joinRTCLine）没有设置strUserId，发送失败。
 */

- (BOOL)sendUserMessage:(int)nType withUserName:(NSString*)strUserName andUserHeader:(NSString*)strUserHeaderUrl andContent:(NSString*)strContent;

/**
 关闭RTC连接
 说明：用于关闭RTC服务，将无法进行聊天互动，人员上下线等。
 */
- (void)leaveRTCLine;

@end
