//
//  RTMPCHybirdEngineKit.h
//  RTMPCHybirdEngine
//
//  Created by EricTao on 16/7/21.
//  Copyright © 2016年 EricTao. All rights reserved.
//

#ifndef RTMPCHybirdEngineKit_h
#define RTMPCHybirdEngineKit_h
#import <UIKit/UIKit.h>


@interface RTMPCHybirdEngineKit : NSObject {
    
}

/**
 *  配置 AnyRtc
 *
 *  @param nsDevelopID   开发者ID(在www.anyrtc.ios注册开发者后平台会分配用户一个开发者ID)
 *  @param nsAppID       AppID(开发者创建一个应用，平台会为该App分配一个AppID)
 *  @param nsKey         AppKey(开发者创建一个应用，平台会为该App分配一个AppKey)
 *  @param nsToken       AppToken(开发者创建一个应用，平台会为该App分配一个Token)
 */
+ (void) InitEngineWithAnyrtcInfo:(NSString*)nsDevelopID andAppId:(NSString*)nsAppID andKey:(NSString*)nsKey andToke:(NSString*)nsToken;
/**
 *  配置私有云
 *
 *  @param nsSvrAddr 私有云地址
 *  @param nSvrPort  私有云端口
 */
+ (void) ConfigServerForPriCloud:(NSString*)nsSvrAddr andPort:(int)nSvrPort;
/**
 *  获取RTC服务地址
 *
 *  @return RTC服务地址
 */
+ (NSString*) GetHttpAddr;
/**
 *  获取 RTMPC SDK 版本号
 *
 *  @return  版本号
 */
+ (NSString*)GetRTMPCSdkVersion;
@end

#endif /* RTMPCHybirdEngineKit_h */
