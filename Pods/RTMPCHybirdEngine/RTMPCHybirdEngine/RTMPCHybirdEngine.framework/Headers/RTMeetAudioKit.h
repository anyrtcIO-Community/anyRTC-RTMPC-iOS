//
//  RTMeetAudioKit.h
//  RTMeetEngine
//
//  Created by derek on 2017/10/19.
//  Copyright © 2017年 EricTao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RTMeetAudioKitDelegate.h"
#import "AnyRTCUserShareBlockDelegate.h"
#import "RTMeetOption.h"

@interface RTMeetAudioKit : NSObject

/**
 实例化会议对象
 
 @param delegate RTC相关回调代理
 @param nMeetType 会议类型
 @return 会议对象
 */
- (instancetype)initWithDelegate:(id<RTMeetAudioKitDelegate>)delegate withMeetingType:(AnyMeetingType)nMeetType;

/**
 设置本地音频是否传输
 
 @param bEnable 打开或关闭本地音频
 说明：yes为传输音频,no为不传输音频，默认传输
 */
- (void)setLocalAudioEnable:(bool)bEnable;
/**
 设置扬声器开关
 
 @param bOn YES:打开扬声器，NO:关闭扬声器
 说明：扬声器默认打开
 */
- (void)setSpeakerOn:(bool)bOn;

/**
 设置音频检测

 @param bOn 是否开启音频检测
 说明：默认打开
 */
- (void)setAudioActiveCheck:(bool)bOn;
#pragma mark RTC function for line

/**
 加入会议
 
 @param strAnyRTCId strAnyRTCId 会议号（可以在AnyRTC 平台获得，也可以根据自己平台，分配唯一的一个ID号）
 @param isHoster 是否是主持人
 @param strUserId 播在开发者自己平台的id，可选
 @param strUserData 播在开发者自己平台的相关信息（昵称，头像等），可选。(限制512字节)
 @return 加入会议成功或者失败
 */
- (BOOL)joinRTC:(NSString*)strAnyRTCId andIsHoster:(BOOL)isHoster andUserId:(NSString*)strUserId andUserData:(NSString*)strUserData;

/**
 离开会议室
 说明：相当于析构函数
 */
- (void)leaveRTC;
#pragma mark - 视频流信息监测
- (void)setNetworkStatus:(BOOL)bEnable;
- (BOOL)networkStatusEnabled;

#pragma mark - 消息
/**
 发送消息
 
 @param strUserName 用户昵称(最大256字节)，不能为空，否则发送失败；
 @param strUserHeaderUrl 用户头像(最大512字节)，可选
 @param strContent 消息内容(最大1024字节)不能为空，否则发送失败；
 @return YES/NO 发送成功/发送失败
 说明：默认普通消息。以上参数均会出现在参会者的消息回调方法中，如果加入RTC（joinRTC）没有设置strUserid，发送失败。
 */

- (int)sendUserMessage:(NSString*)strUserName andUserHeader:(NSString*)strUserHeaderUrl andContent:(NSString*)strContent;

/**
 设置某路视频广播
 
 @param bEnable 广播与取消广播
 @param strRTCPeerId 视频流Id
 */
- (void)setRTCBroadCast:(BOOL)bEnable andRTCPeerId:(NSString*)strRTCPeerId;

/**
 授课1v1模式与否
 
 @param bEnable 1v1与取消1v1
 @param strRTCPeerId 视频流Id
 */
- (void)setRTCTalkOnly:(BOOL)bEnable andRTCPeerId:(NSString*)strRTCPeerId;

#pragma mark - 白板功能模块
/**
 设置白板相关回调
 */
@property (nonatomic, weak)id<AnyRTCUserShareBlockDelegate>delegate;
/**
 判断是否可以共享
 
 @param nType 共享类型
 说明：类型，自己平台设定，比如1:为白板，２:为文档
 */
- (void)canShareUser:(int)nType;
/**
 打开共享信息
 
 @param strShearInfo 共享相关信息(限制512字节)
 说明：打开白板成功与失败，参考onRTCSetWhiteBoardEnableResult 回调方法
 */
- (void)openUserShareInfo:(NSString *)strShearInfo;

/**
 关闭共享
 */
- (void)closeUserShare;
@end
