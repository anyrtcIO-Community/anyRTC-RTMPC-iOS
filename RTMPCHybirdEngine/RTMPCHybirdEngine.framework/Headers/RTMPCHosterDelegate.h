//
//  RTMPCHosterDelegate.h
//  RTMPCHosterDelegate
//
//  Created by EricTao on 16/7/16.
//  Copyright © 2016年 EricTao. All rights reserved.
//

#ifndef RTMPCHosterDelegate_h
#define RTMPCHosterDelegate_h

//* All callback event is on main thread, so it's mean developer
//* could operate UI method in callback directly.
@protocol RTMPCHosterRtmpDelegate <NSObject>
@required
/**
 *   RTMP service connection is successful callback
 */
- (void)OnRtmpStreamOK;
/**
 *  RTMP service reconnection callback
 *
 *  @param times reconnection times
 */
- (void)OnRtmpStreamReconnecting:(int) times;
/**
 *  RTMP's delay time and the current network bandwidth
 *
 *  @param delayMs delay time (ms)
 *  @param netBand network bandwidth
 */
- (void)OnRtmpStreamStatus:(int) delayMs withNetBand:(int) netBand;
/**
 *  RTMP service connection is failure callback
 *
 *  @param code why
 */
- (void)OnRtmpStreamFailed:(int) code;
/**
 *  RTMP server close callback
 */
- (void)OnRtmpStreamClosed;
@end


@protocol RTMPCHosterRtcDelegate <NSObject>
@required
/**
 *  RTC service connection callback
 *
 *  @param code      if 0,scuess
 *  @param strReason reason
 */
- (void)OnRTCOpenLineResult:(int) code withReason:(NSString*)strReason;
/**
 *  Receive others line request
 *
 *  @param strLivePeerID other's peer id
 *  @param strCustomID   other's user id
 *  @param strUserData   other's custom data(eg:picture or nickname;)
 */
- (void)OnRTCApplyToLine:(NSString*)strLivePeerID withCustomID:(NSString*)strCustomID withUserData:(NSString*)strUserData;
/**
 *  Receive other's hang up line(The premise You have established connection to others)
 *
 *  @param strLivePeerID other's peer id
 */
- (void)OnRTCCancelLine:(NSString*)strLivePeerID;
/**
 *  RTC server close
 *
 *  @param code      if 0 scuess;other's failure
 *  @param strReason reason
 */
- (void)OnRTCLineClosed:(int) code withReason:(NSString*)strReason;
/**
 *  The attachment successfully，after you get this callback,You should do show this video
 *
 *  @param strLivePeerID other's peer id
 */
- (void)OnRTCOpenVideoRender:(NSString*)strLivePeerID;
/**
 *  Attachment to disconnect，after you get this callback,You should clean up the display
 *
 *  @param strLivePeerID other's peer id
 */
- (void)OnRTCCloseVideoRender:(NSString*)strLivePeerID;
@optional
/**
 *  Messages
 *
 *  @param nsCustomId other's platform  user id
 *  @param nsCustomName other's platform  user nick name
 *  @param nsCustomHeader other's platform user header url
 *  @param nsContent  message
 */
- (void)OnRTCUserMessage:(NSString*)nsCustomId withCustomName:(NSString*)nsCustomName withCustomHeader:(NSString*)nsCustomHeader withContent:(NSString*)nsContent;
/**
 *  Barrage
 *
 *  @param nsCustomId other's platform  user id
 *  @param nsCustomName other's platform  user nick name
 *  @param nsCustomHeader other's platform user header url
 *  @param nsContent  barrage
 */
- (void)OnRTCUserBarrage:(NSString*)nsCustomId withCustomName:(NSString*)nsCustomName withCustomHeader:(NSString*)nsCustomHeader withContent:(NSString*)nsContent;
/**
 *  All member count in this live.
 *
 *  @param nTotal all member count
 */
- (void)OnRTCMemberListWillUpdate:(int)nTotalMember;
/**
 *   Got online member
 *
 *  @param nsCustomId other's platform  user id
 *  @param nsUserData other's platform user data
 */
- (void)OnRTCMember:(NSString*)nsCustomId withUserData:(NSString*)nsUserData;
/**
 *   Got member list is done
 */
- (void)OnRTCMemberListUpdateDone;
@end

#endif /* RTMPCHosterDelegate_h */
