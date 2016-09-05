//
//  RTMPCHosterKit.h
//  RTMPCHybirdEngine
//
//  Created by EricTao on 16/7/16.
//  Copyright © 2016年 EricTao. All rights reserved.
//

#ifndef RTMPCHosterKit_h
#define RTMPCHosterKit_h
#import <UIKit/UIKit.h>
#import "RTMPCHosterDelegate.h"
#include "RTMPCCommon.h"

@interface RTMPCHosterKit : NSObject {
    
}
/**
 *  RTC Delegate(if you want add Even wheat function，you should set it)
 */
@property (weak, nonatomic) id<RTMPCHosterRtcDelegate> rtc_delegate;
/**
 *  Initialize the hoster clent
 *
 *  @param delegate RTMPCHosterRtmpDelegate
 *
 *  @return hoster object
 */
- (instancetype)initWithDelegate:(id<RTMPCHosterRtmpDelegate>)delegate;
/**
 *  clear host clent (if you leave,you must call this function)
 */
- (void) clear;

#pragma mark Common function
/**
 *  audio setting (default is YES)
 *
 *  @param enable set YES to enable, NO to disable.
 */
- (void)SetAudioEnable:(bool) enabled;
/**
 *  video setting (default is YES)
 *
 *  @param enable set YES to enable, NO to disable.
 */
- (void)SetVideoEnable:(bool) enabled;
/**
 *  push the media stream setting
 *
 *  @param naMode choose different mode,you will have different effect，advice choose RTMP_NA_Fast
 */
- (void)SetNetAdjustMode:(RTMPNetAdjustMode) naMode;
/**
 *  video view show and setting
 *
 *  @param render video view
 *  @param front  camera front or back  if yes front or back
 */
- (void)SetVideoCapturer:(UIView*) render andUseFront:(bool)front;
/**
 *  change camera front or back
 */
- (void)SwitchCamera;
/**
 *  Set the beauty
 *
 *  @param enabled YES/NO:beauty or normal
 */
- (void)SetBeautyEnable:(bool) enabled;
/**
 *  logo setting
 *
 *  @param logoFilePath local picture file path
 */
- (void)SetVideoLogo:(NSString*)logoFilePath;
/**
 *  The video quality setting
 *
 *  @param videoMode quality type
 */
- (void)SetVideoMode:(RTMPCVideoMode) videoMode;

#pragma mark Rtmp function for push rtmp stream
/**
 *  start push stream server
 *
 *  @param strUrl server address
 *
 *  @return scuess or failed
 */
- (BOOL)StartPushRtmpStream:(NSString*)strUrl;
/**
 *  stop push stream to the server
 */
- (void)StopRtmpStream;

#pragma mark RTC function for line
/**
 *  Open RTC function
 *
 *  @param strAnyrtcID the anyrtc of id
 *  @param strCustomID host's user id (this id is you platform's id)
 *  @param strUserData if you want other know you platform's information，you can add it
 *
 *  @return scuess or failed
 */
- (BOOL)OpenRTCLine:(NSString*)strAnyrtcID andCustomID:(NSString*)strCustomID andUserData:(NSString*)strUserData;
/**
 *  Host again other's request line
 *
 *  @param strLivePeerID other's peer id
 *
 *  @return if no ,you line other's failed(Agree to attachment 3 people is full)
 */
- (BOOL)AcceptRTCLine:(NSString*)strLivePeerID;
/**
 *  Host reject other's line
 *
 *  @param strLivePeerID peer ID
 *  @param banToApply
 */
- (void)RejectRTCLine:(NSString*)strLivePeerID andBanToApply:(bool) banToApply;

/**
 *  Host hung up other's video(close line)
 *
 *  @param strLivePeerID peer id
 */
- (void)HangupRTCLine:(NSString*)strLivePeerID;
/**
 *  Show other's video (if you again other's request line,you will get callback,then set it)
 *
 *  @param strLivePeerID peer id
 *  @param render        video view
 */
- (void)SetRTCVideoRender:(NSString*)strLivePeerID andRender:(UIView*)render;
/**
 *  Send test message
 *
 *  @param nsCustomName   host's nickname
 *  @param nsCustomHeader host's header
 *  @param nsContent      you message
 *
 *  @return scuess or failed
 */
- (BOOL)SendUserMsg:(NSString*)nsCustomName andCustomHeader:(NSString*)nsCustomHeader andContent:(NSString*)nsContent;
/**
 *  Send barrage（danmu） message
 *
 *  @param nsCustomName   host's nickname
 *  @param nsCustomHeader host's header
 *  @param nsContent      you message
 *
 *  @return scuess or failed
 */
- (BOOL)SendBarrage:(NSString*)nsCustomName andCustomHeader:(NSString*)nsCustomHeader  andContent:(NSString*)nsContent;
/**
 *  Close RTC
 */
- (void)CloseRTCLine;
@end

#endif /* RTMPCHosterKit_h */
