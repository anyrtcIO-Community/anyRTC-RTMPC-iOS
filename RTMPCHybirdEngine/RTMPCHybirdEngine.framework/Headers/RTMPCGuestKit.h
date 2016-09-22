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
    VideoShowModeScaleAspectFill,  // default by height scale (高度填充整个屏幕)
    VideoShowModeCenter
};

@interface RTMPCGuestKit : NSObject {
    
}
/**
 *  Player show mode
 */
@property (nonatomic, assign)VideoShowMode videoContentMode;
/**
 *  RTC Delegate(if you want add Even wheat function，you should set it)
 */
@property (weak, nonatomic) id<RTMPCGuestRtcDelegate> rtc_delegate;
/**
 *  Initialize the guest clent
 *
 *  @param delegate RTMPCGuestRtmpDelegate
 *
 *  @return guest object
 */
- (instancetype)initWithDelegate:(id<RTMPCGuestRtmpDelegate>)delegate;
/**
 *  clear guest clent (if you leave,you must call this function)
 */
- (void) clear;

#pragma mark - Common function
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
 *  if you change the video show fream you should call this function to adapter you video view
 */
- (void)videoFreamUpdate;

#pragma mark Rtmp function for pull rtmp stream
/**
 *  start play the video
 *
 *  @param strUrl rtmp address
 *  @param render video view
 *
 *  @return scuess or failed
 */
- (BOOL)StartRtmpPlay:(NSString*)strUrl andRender:(UIView*)render;
/**
 *  stop play
 */
- (void)StopRtmpPlay;

#pragma mark RTC function for line
/**
 *  Join RTC
 *
 *  @param strAnyrtcID the anyrtc of id
 *  @param strCustomID host's user id (this id is you platform's id)
 *  @param strUserData if you want other know you platform's information，you can add it
 *
 *  @return scuess or failed
 */
- (BOOL)JoinRTCLine:(NSString*)strAnyrtcID andCustomID:(NSString*)strCustomID andUserData:(NSString*)strUserData;
/**
 *  Apply host line
 *
 *  @param strUserData you want say
 */
- (void)ApplyRTCLine:(NSString*)strUserData;
/**
 *  you hang up the line
 */
- (void)HangupRTCLine;
/**
 *  Show other's video (if you again other's request line,you will get callback,then set it)；if device landscape mode,render's size 4:3;if device portrait mode,render's size 3:4
 *
 *  @param strLivePeerID peer id
 *  @param render        video view
 */
- (void)SetRTCVideoRender:(NSString*)strLivePeerID andRender:(UIView*)render;
/**
 *  Send test message
 *
 *  @param nsCustomName   guest's nickname
 *  @param nsCustomHeader guest's header
 *  @param nsContent      you message
 *
 *  @return scuess or failed
 */
- (BOOL)SendUserMsg:(NSString*)nsCustomName andCustomHeader:(NSString*)nsCustomHeader andContent:(NSString*)nsContent;
/**
 *  Send barrage（danmu） message
 *
 *  @param nsCustomName   guest's nickname
 *  @param nsCustomHeader guest's header
 *  @param nsContent      you message
 *
 *  @return scuess or failed
 */
- (BOOL)SendBarrage:(NSString*)nsCustomName andCustomHeader:(NSString*)nsCustomHeader  andContent:(NSString*)nsContent;
/**
 *  Leave RTC
 */
- (void)LeaveRTCLine;

/**
 *  Updata Experience
 *
 *  @param exp experience value
 */
- (void)UpdataExp:(int)exp;

@end

#endif /* RTMPCGuestKit_h */
