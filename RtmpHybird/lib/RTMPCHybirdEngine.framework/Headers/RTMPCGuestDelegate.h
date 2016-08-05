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
- (void)OnRtmplayerOK;
- (void)OnRtmplayerStatus:(int) cacheTime withBitrate:(int) curBitrate;
- (void)OnRtmplayerCache:(int) time;
- (void)OnRtmplayerClosed:(int) errcode;
@end

@protocol RTMPCGuestRtcDelegate <NSObject>
@required
- (void)OnRTCJoinLineResult:(int) code/*0:OK */ withReason:(NSString*)strReason;
//@RtcLite
- (void)OnRTCApplyLineResult:(int) code/*0:OK */;
- (void)OnRTCOtherLineOpen:(NSString*)strLivePeerID withCustomID:(NSString*)strCustomID withUserData:(NSString*)strUserData;
- (void)OnRTCOtherLineClose:(NSString*)strLivePeerID;
- (void)OnRTCHangupLine;
//@RtcLite end
- (void)OnRTCLineLeave:(int) code/*0:OK */ withReason:(NSString*)strReason;

- (void)OnRTCOpenVideoRender:(NSString*)strLivePeerID;
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
