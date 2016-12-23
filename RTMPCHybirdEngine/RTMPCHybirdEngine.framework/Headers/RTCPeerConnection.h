//
//  RTCPeerConnection.h
//  RTMPCHybirdEngine
//
//  Created by EricTao on 16/12/2.
//  Copyright © 2016年 EricTao. All rights reserved.
//

#ifndef RTCPeerConnection_h
#define RTCPeerConnection_h
#import <UIKit/UIKit.h>
#import "RTCIceCandidate.h"
#import "RTCSessionDescription.h"

@protocol RTCPeerConnectionDelegate <NSObject>
@required
- (void)OnRtcOfferDescription:(RTCSessionDescription*)desc withPeerID:(NSString *)peerID;
- (void)OnRtcAnswerDescription:(RTCSessionDescription*)desc withPeerID:(NSString *)peerID;
- (void)OnRtcIceCandidate:(RTCIceCandidate*)candidate withPeerID:(NSString *)peerID;
- (void)OnRtcStats:(NSString*)strStats withPeerID:(NSString *)peerID;

- (void)OnRTCOpenVideoRender:(NSString *)peerID;
- (void)OnRTCCloseVideoRender:(NSString *)peerID;
@end

#pragma - mark RTCPeerConnections
@interface RTCPeerConnectionMgr : NSObject {
    
}
+ (instancetype)sharedInstance;
typedef void(^CameraViewSizeBlock)(UIView *videoView,CGSize size);
/**
 *  设置本地视频显示窗口
 *
 *  @param render 视频窗口 
 *  @param front  摄像头前置，还是后置; YES:前置；NO:后置
 */
- (void)SetVideoCapturer:(UIView*) render andUseFront:(bool)front withSizeBlock:(CameraViewSizeBlock)sizeBlock;
/**
 *  更改前置跟后置摄像头
 */
- (void)SwitchCamera;

/**
 *  设置音频是否传输，默认音频传输
 *
 *  @param enable 设置YES,传输音频，设置NO,不传输音频
 */
- (void)SetLocalAudioEnable:(bool) enabled;
/**
 *  设置音频是否传输，默认视频开启
 *
 *  @param enable 设置YES,传输视频，设置NO,不传输视频
 */
- (void)SetLocalVideoEnable:(bool) enabled;

@end


#pragma - mark RTCPeerConnection
@interface RTCPeerConnection : NSObject {
    
}
/**
 *  RTC 相关回调代理
 */

- (instancetype)initWithDelegate:(id<RTCPeerConnectionDelegate>)delegate;

#pragma - mark RTCPeerConnection Common function
/**
 *  设置音频是否传输，默认音频传输
 *
 *  @param enable 设置YES,传输音频，设置NO,不传输音频
 */
- (void)SetAudioEnable:(bool) enabled;
/**
 *  设置音频是否传输，默认视频开启
 *
 *  @param enable 设置YES,传输视频，设置NO,不传输视频
 */
- (void)SetVideoEnable:(bool) enabled;

- (void)GenerateOffer:(NSString*)strUserID;

- (void)ProcessOffer:(RTCSessionDescription*) desc;

- (void)ProcessAnswer:(RTCSessionDescription*) desc;

- (void)AddRemoteIceCandidate:(RTCIceCandidate*) candidate;

/**
 *  显示游客端连麦的小视频；如果横屏：视频大小比例为4:3;如果为竖屏：视频大小的比例为3:4
 *  @param render        显示对方视频的View
 */
- (void)SetRTCVideoRender:(UIView*)render;

- (NSString *)GetPeerID;

- (void)Close;
@end

#endif /* RTCPeerConnection_h */
