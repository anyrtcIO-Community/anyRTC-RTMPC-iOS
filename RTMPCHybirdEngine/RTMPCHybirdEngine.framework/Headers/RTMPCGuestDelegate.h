//
//  RTMPCGuestDelegate.h
//  RTMPCHybirdEngine
//
//  Created by EricTao on 16/7/16.
//  Copyright © 2016年 EricTao. All rights reserved.
//

#ifndef RTMPCGuestDelegate_h
#define RTMPCGuestDelegate_h
//* All callback event is on main thread, so it's mean developer
//* could operate UI method in callback directly.
@protocol RTMPCGuestRtmpDelegate <NSObject>
@required
/**
 *   RTMP service connection is successful callback
 */
- (void)OnRtmplayerOK;
/**
 *  RTMP's cache time and the current Bit rate
 *
 *  @param cacheTime delay time (ms)
 *  @param curBitrate Bit rate
 */
- (void)OnRtmplayerStatus:(int) cacheTime withBitrate:(int) curBitrate;
/**
 *   RTMP Player start play
 */
- (void)OnRtmplayerStart;
/**
 *  cache time
 *
 *  @param time (ms)
 */
- (void)OnRtmplayerCache:(int) time;
/**
 *  rtmp player close
 *
 *  @param errcode eror code
 */
- (void)OnRtmplayerClosed:(int) errcode;
@end

@protocol RTMPCGuestRtcDelegate <NSObject>
@required
/**
 *  Join RTC service  callback
 *
 *  @param code      if 0,scuess
 *  @param strReason reason
 */
- (void)OnRTCJoinLineResult:(int) code withReason:(NSString*)strReason;
/**
 *  Apply line to host callback
 *
 *  @param code if 0,scuess
 */
- (void)OnRTCApplyLineResult:(int) code;
/**
 *  Get other join RTC callback
 *
 *  @param strLivePeerID peer id
 *  @param strCustomID   other's user id
 *  @param strUserData   other's custom data(eg:picture or nickname;)
 */
- (void)OnRTCOtherLineOpen:(NSString*)strLivePeerID withCustomID:(NSString*)strCustomID withUserData:(NSString*)strUserData;
/**
 *  Get other leave RTC callback
 *
 *  @param strLivePeerID peerID
 */
- (void)OnRTCOtherLineClose:(NSString*)strLivePeerID;
/**
 *  Host hang up you line
 */
- (void)OnRTCHangupLine;

/**
 *  RTC server close
 *
 *  @param code      if 0 scuess;other's failure
 *  @param strReason reason
 */
- (void)OnRTCLineLeave:(int) code withReason:(NSString*)strReason;
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

#endif /* RTMPCGuestDelegate_h */
