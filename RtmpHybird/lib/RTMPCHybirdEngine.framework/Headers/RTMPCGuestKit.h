//
//  RTMPCGuestKit.h
//  RTMPCHybirdEngine
//
//  Created by EricTao on 16/7/16.
//  Copyright © 2016年 EricTao. All rights reserved.
//

#ifndef RTMPCGuestKit_h
#define RTMPCGuestKit_h
#import <UIKit/UIKit.h>
#import "RTMPCGuestDelegate.h"

typedef NS_ENUM(NSInteger,VideoShowMode){
    VideoShowModeScaleAspectFit,
    VideoShowModeScaleAspectFill,  // default by width scale
    VideoShowModeCenter
};

@interface RTMPCGuestKit : NSObject {
    
}
@property (nonatomic, assign)VideoShowMode videoContentMode;

@property (weak, nonatomic) id<RTMPCGuestRtcDelegate> rtc_delegate;

- (instancetype)initWithDelegate:(id<RTMPCGuestRtmpDelegate>)delegate;
- (void) clear;

//* Common function
- (void)SetAudioEnable:(bool) enabled;
- (void)SetVideoEnable:(bool) enabled;
- (void)SetVideoCapturer:(UIView*) render andUseFront:(bool)front;

//* Rtmp function for pull rtmp stream
- (BOOL)StartRtmpPlay:(NSString*)strUrl andRender:(UIView*)render;
- (void)StopRtmpPlay;

//* RTC function for line
- (BOOL)JoinRTCLine:(NSString*)strAnyrtcID andCustomID:(NSString*)strCustomID andCustomName:(NSString*)strCustomName andUserData:(NSString*)strUserData;
- (void)ApplyRTCLine:(NSString*)strUserData;
- (void)HangupRTCLine;
- (void)SetRTCVideoRender:(NSString*)strLivePeerID andRender:(UIView*)render;
- (BOOL)SendUserMsg:(NSString*)nsCustomName andCustomHeader:(NSString*)nsCustomHeader andContent:(NSString*)nsContent;
- (BOOL)SendBarrage:(NSString*)nsCustomName andCustomHeader:(NSString*)nsCustomHeader  andContent:(NSString*)nsContent;
- (void)LeaveRTCLine;
@end

#endif /* RTMPCGuestKit_h */
