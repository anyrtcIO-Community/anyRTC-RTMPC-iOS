//
//  RTMPCHosterAudioKit.h
//  RTMPCHybirdEngine
//
//  Created by derek on 2017/11/8.
//  Copyright © 2017年 EricTao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RTMPCHosterDelegate.h"
#import "RTCCommon.h"

@interface RTMPCHosterAudioKit : NSObject
/**
 RTC 相关回调代理，如果不用RTC，该回调不用设置
 */
@property (weak, nonatomic) id<RTMPCHosterRtcDelegate> rtc_delegate;

/**
 实例化主播对象

 @param delegate TMP推流相关回调代理
 @param audioDetect 是否打开音频检测
 @return 主播对象
 */
- (instancetype)initWithDelegate:(id<RTMPCHosterRtmpDelegate>)delegate withAudioDetect:(BOOL)audioDetect;

/**
 销毁主播对象，相当于析构函数
 */
- (void)clear;

/**
 设置录像地址
 
 @param strRecordUrl 需要录像流的地址；
 说明：设置Rtmp录制地址，需放在开始推流方法前（开启录像服务
 需前往www.anyrtc.io官网开通录像服务）
 */
- (void)setRtmpRecordUrl:(NSString*)strRecordUrl;

/**
 开始推流
 
 @param strUrl RTMP推流地址
 @return yes为推流成功，no为推流失败。
 */
- (BOOL)startPushRtmpStream:(NSString*)strUrl;

/**
 停止推流
 说明：调用此方法停止推流并且关闭RTC服务，直播关闭
 */
- (void)stopRtmpStream;

/**
 设置本地音频是否传输
 
 @param bEnable 打开或关闭本地音频
 说明：yes为传输音频,no为不传输音频，默认传输
 */
- (void)setLocalAudioEnable:(bool)bEnable;

#pragma mark RTC function for line
/**
 创建RTC链接
 
 @param strAnyRTCId 开发者业务系统中保持唯一的id（必填）；
 @param strUserId 播在开发者自己平台的id，可选
 @param strUserData 播在开发者自己平台的相关信息（昵称，头像等），可选。(限制512字节)
 @param strLiveInfo 直播间相关信息（推流地址，直播间名称等），可选。（限制1024字节）
 @return 打开RTC成功与否
 说明:
 strUserId，若不设置，发消息接口不能使用。
 strUserData，将会出现在游客连麦回调中，若不设置，人员上下线接口将无用。
 strLiveInfo,该信息在RTMPCHttpKit类中getLivingList方法中获取。若不设置，获取直播列表信息为空。
 该方法须在开始推流（StartPushRtmpStream）方法后调用
 */
- (BOOL)createRTCLine:(NSString*)strAnyRTCId andUserId:(NSString*)strUserId andUserData:(NSString*)strUserData andLiveInfo:(NSString*)strLiveInfo;
/**
 同意游客连麦请求
 
 @param strLivePeerId RTC服务生成的连麦者标识Id 。(用于标识连麦用户，每次连麦随机生成)
 @return yes为同意连麦；no为同意连麦失败（可能超过连麦数量）
 说明：调用此方法即可同意游客的连麦请求。同意后，视频直播模式下将会回调游客视频连麦接通方法，具体操作可查看 游客视频连麦接通 回调。音频直播模式下将会回调游客音频连麦接通方法，具体操作可查看 游客音频连麦接通回调。
 */
- (BOOL)acceptRTCLine:(NSString*)strLivePeerId;

/**
 拒绝游客连麦请求
 
 @param strLivePeerId RTC服务生成的连麦者标识Id 。(用于标识连麦用户，每次连麦随机生成)
 说明：当有游客请求连麦时，可调用此方法拒绝
 */
- (void)rejectRTCLine:(NSString*)strLivePeerId;

/**
 挂断游客连麦
 
 @param strLivePeerId RTC服务生成的连麦者标识Id 。(用于标识连麦用户，每次连麦随机生成)
 说明:与游客连麦过程中，可调用此方法挂断与他的连麦
 */
- (void)hangupRTCLine:(NSString*)strLivePeerId;

/**
 发送消息
 
 @param nType 消息类型:0:普通消息;1:弹幕消息
 @param strUserName 用户昵称(最大256字节)，不能为空，否则发送失败；
 @param strUserHeaderUrl 用户头像(最大512字节)，可选
 @param strContent 消息内容(最大1024字节)不能为空，否则发送失败；
 @return YES/NO 发送成功/发送失败
 说明：默认普通消息。以上参数均会出现在游客/主播消息回调方法中，如果创建RTC连接（createRTCLine）没有设置strUserid，发送失败。
 */

- (BOOL)sendUserMessage:(RTCMessageType)nType withUserName:(NSString*)strUserName andUserHeader:(NSString*)strUserHeaderUrl andContent:(NSString*)strContent;

/**
 关闭RTC链接
 说明：主播端如果调用此方法，将会关闭RTC服务，若开启了直播在线功能（可在www.anyrtc.io 应用管理中心开通），游客端会收到主播已离开(onRTCLineLeave)的回调。
 */
- (void)closeRTCLine;


@end
