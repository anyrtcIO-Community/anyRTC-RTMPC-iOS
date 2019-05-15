//
//  ARRtmpHttpKit.h
//  RTMPCHybirdEngine
//
//  Created by zjq on 2019/1/16.
//  Copyright © 2019 EricTao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ARRtmpHttpKit : NSObject

+ (ARRtmpHttpKit*)shead;
// 获取数据
typedef void (^GetDataBlock)(NSDictionary *responseDict,NSError *error,int code);

/**
 *  获取直播列表
 *
 *  @param resultBlock 数据回调
 */
- (void)getLivingList:(GetDataBlock)resultBlock;

/**
 获取直播间在线人员列表
 
 @param serverId 服务Id
 @param roomId 房间Id
 @param anyRTCId anyRTCId
 @param pageNum 当前页（每页15条数据，从0页开始）
 @param resultBlock 数据回调
 */
- (void)getLiveMemberList:(NSString *)serverId roomId:(NSString *)roomId anyRTCId:(NSString *)anyRTCId page:(int)pageNum resultBlock:(GetDataBlock)resultBlock;


@end

NS_ASSUME_NONNULL_END

