//
//  ARRtmpEngine.h
//  RTMPCHybirdEngine
//
//  Created by zjq on 2019/1/16.
//  Copyright © 2019 EricTao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ARCommonEnum.h"

NS_ASSUME_NONNULL_BEGIN

@interface ARRtmpEngine : NSObject

/**
 配置开发者信息
 
 @param appId appId
 @param token token
 说明：该方法为配置开发者信息，上述参数均可在https://www.anyrtc.io/ 应用管理中获得；建议在AppDelegate.m调用。
 */
+ (void)initEngine:(NSString *)appId token:(NSString *)token;

/**
 配置私有云
 
 @param address 私有云服务地址；
 @param port   私有云服务端口；
 说明：配置私有云信息，当使用私有云时才需要进行配置，默认无需配置。
 */
+ (void)configServerForPriCloud:(NSString *)address port:(int)port;

/**
 获取 RTMeeting SDK 版本号
 
 @return 版本号
 */
+ (NSString *)getSDKVersion;


/**
 设置打印日志级别
 
 @levelModel 日志级别
 */

+ (void)setLogLevel:(ARLogModel)levelModel;

@end

NS_ASSUME_NONNULL_END
