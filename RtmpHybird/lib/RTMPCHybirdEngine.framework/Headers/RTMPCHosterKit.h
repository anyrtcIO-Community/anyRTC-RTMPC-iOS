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

@property (weak, nonatomic) id<RTMPCHosterRtcDelegate> rtc_delegate;

- (instancetype)initWithDelegate:(id<RTMPCHosterRtmpDelegate>)delegate;
- (void) clear;

//* Common function
- (void)SetAudioEnable:(bool) enabled;
- (void)SetVideoEnable:(bool) enabled;
- (void)SetVideoCapturer:(UIView*) render andUseFront:(bool)front;
- (void)SwitchCamera;
- (void)SetBeautyEnable:(bool) enabled;
- (void)SetVideoLogo:(NSString*)logoFilePath;
- (void)SetVideoMode:(RTMPCVideoMode) videoMode;

//* Rtmp function for push rtmp stream
- (BOOL)StartPushRtmpStream:(NSString*)strUrl;
- (void)StopRtmpStream;

//* RTC function for line
- (BOOL)OpenRTCLine:(NSString*)strAnyrtcID andCustomID:(NSString*)strCustomID andUserData:(NSString*)strUserData;
- (BOOL)AcceptRTCLine:(NSString*)strLivePeerID;//NO:同意连线3人已满
- (void)HangupRTCLine:(NSString*)strLivePeerID;
- (void)RejectRTCLine:(NSString*)strLivePeerID andBanToApply:(bool) banToApply;
- (void)SetRTCVideoRender:(NSString*)strLivePeerID andRender:(UIView*)render;
- (BOOL)SendUserMsg:(NSString*)nsCustomName andCustomHeader:(NSString*)nsCustomHeader andContent:(NSString*)nsContent;
- (BOOL)SendBarrage:(NSString*)nsCustomName andCustomHeader:(NSString*)nsCustomHeader  andContent:(NSString*)nsContent;
- (void)CloseRTCLine;
@end

#endif /* RTMPCHosterKit_h */
