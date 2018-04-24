//
//  RTMPCHttpKit.h
//  RTMPCHybirdEngine
//
//  Created by derek on 2017/9/15.
//  Copyright © 2017年 EricTao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RTMPCHttpKit : NSObject

+ (RTMPCHttpKit*)shead;
// 获取数据
typedef void (^GetDataBlock)(NSDictionary *responseDict,NSError*error,int code);

/**
 *  获取直播列表
 *
 *  @param resultBlock 数据回调
 */
- (void)getLivingList:(GetDataBlock)resultBlock;

/**
 获取直播间在线人员列表

 @param strServerId 服务Id
 @param strRoomId 房间Id
 @param strAnyRTCId anyRTCId
 @param pageNum 当前页（每页15条数据）
 @param resultBlock 数据回调
 */
- (void)getLiveMemberList:(NSString*)strServerId withRoomId:(NSString*)strRoomId withAnyRTCId:(NSString*)strAnyRTCId withPage:(int)pageNum withResultBlock:(GetDataBlock)resultBlock;

/**
 强制关闭直播

 @param strAnyRTCId 直播间的anyRTC：在开发者业务系统中保持唯一
 @param resultBlock 数据回调
 */
- (void)forceCloseLive:(NSString*)strAnyRTCId withResultBlock:(GetDataBlock)resultBlock;

@end
