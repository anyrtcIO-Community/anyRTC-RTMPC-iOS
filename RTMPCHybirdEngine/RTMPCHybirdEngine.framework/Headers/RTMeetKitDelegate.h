//
//  RTMeetKitDelegate.h
//  RTMeetEngine
//
//  Created by EricTao on 16/11/10.
//  Copyright © 2016年 EricTao. All rights reserved.
//

#ifndef RTMeetKitDelegate_h
#define RTMeetKitDelegate_h

@protocol RTMeetKitDelegate <NSObject>
@required
/**
 *  加入会议成功的回调
 *
 *  @param strAnyrtcId 会议号
 */
- (void)OnRTCJoinMeetOK:(NSString*)strAnyrtcId;
/**
 *  加入会议室失败的回调
 *
 *  @param strAnyrtcId 会议号
 *  @param code        失败的code,可以根据code知道原因
 *  @param strReason   失败的原因
 */
- (void)OnRTCJoinMeetFailed:(NSString*)strAnyrtcId withCode:(int)code withReaso:(NSString*)strReason;
/**
 *  离开会议的回调
 *
 *  @param code      如果code的值为0 表示成功；如果非0，侧不成功
 */
- (void)OnRTCLeaveMeet:(int) code;
/**
 *  其他会议者进入会议的回调（收到该回调，调用- (void)SetRTCVideoRender:(NSString*)strLivePeerID andRender:(UIView*)render;方法，设置对方的显示窗口）
 *
 *  @param strLivePeerID 其他会议者的ID
 */
- (void)OnRTCOpenVideoRender:(NSString*)strLivePeerID;
/**
 *  其他会议者离开的回调
 *
 *  @param strLivePeerID 其他会议者的ID（收到该回调，删除本地显示的对应的视频窗口）
 */
- (void)OnRTCCloseVideoRender:(NSString*)strLivePeerID;
/**
 *  其他会议者视频窗口的对音视频的操作的回调（比如对方关闭了音频，对方关闭了视频）
 *
 *  @param strLivePeerID 其他会议者的ID
 */
- (void)OnRTCAVStatus:(NSString*)strLivePeerID withAudio:(BOOL)audio withVideo:(BOOL)video;

/**
 *  音频监测（当别人关闭视频聊天的时候，会有音频监测的回调）
 *
 *  @param strLivePeerID 其他会议者的ID
 *  @time  音频在该段时间内不会有回调
 */
- (void)OnRTCAudioActive:(NSString*)strLivePeerID withShowTime:(int)time;

/**
 视频窗口大小的回调

 @param videoView 视频窗口
 @param size 视频的大小
 */
-(void) OnRtcViewChanged:(UIView*)videoView didChangeVideoSize:(CGSize)size;
@end

#endif /* RTMeetKitDelegate_h */
