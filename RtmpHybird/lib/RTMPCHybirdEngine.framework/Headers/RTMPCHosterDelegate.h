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
- (void)OnRtmpStreamOK;
- (void)OnRtmpStreamReconnecting:(int) times;
- (void)OnRtmpStreamStatus:(int) delayMs withNetBand:(int) netBand;
- (void)OnRtmpStreamFailed:(int) code;
- (void)OnRtmpStreamClosed;
@end


@protocol RTMPCHosterRtcDelegate <NSObject>
@required
- (void)OnRTCOpenLineResult:(int) code/*0:OK */ withReason:(NSString*)strReason;
//@RtcLite
- (void)OnRTCApplyToLine:(NSString*)strLivePeerID withCustomID:(NSString*)strCustomID withUserData:(NSString*)strUserData;
- (void)OnRTCCancelLine:(NSString*)strLivePeerID;
//@RtcLite end
- (void)OnRTCLineClosed:(int) code/*0:OK */ withReason:(NSString*)strReason;

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

#endif /* RTMPCHosterDelegate_h */
