//
//  RTMPCHybirdEngineKit.h
//  RTMPCHybirdEngine
//
//  Created by EricTao on 16/7/21.
//  Copyright © 2016年 EricTao. All rights reserved.
//

#ifndef RTMPCHybridEngineKit_h
#define RTMPCHybridEngineKit_h
#import <UIKit/UIKit.h>
#include "RTCCommon.h"

@interface RTMPCHybridEngineKit : NSObject {
    
}
/**
 配置开发者信息

 @param strDeveloperId 开发者Id；
 @param strAppId     AppId；
 @param strAppKey    AppKey；
 @param strAppToken  AppToken；
 说明：该方法为配置开发者信息，上述参数均可在https://www.anyrtc.io/ manage创建应用后,管理中心获得；建议在AppDelegate.m调用。
 */
+ (void)initEngineWithAnyRTCInfo:(NSString*)strDeveloperId andAppId:(NSString*)strAppId andKey:(NSString*)strAppKey andToke:(NSString*)strAppToken;

/**
 配置私有云

 @param strAddress 私有云服务地址；
 @param nPort   私有云服务端口；
 说明：配置私有云信息，当使用私有云时才需要进行配置，默认无需配置。
 */
+ (void)configServerForPriCloud:(NSString*)strAddress andPort:(int)nPort;

/**
 获取 RTMPC SDK 版本号

 @return 版本号
 */
+ (NSString*)getSdkVersion;


///**
// 设置相机类型
//
// @param cameraType 相机模式
// 说明：根据自己的需求，选择相应的相机类型
// */
//+ (void)setCameraType:(RTMPCCameraType) cameraType;
//
///**
// 设置视频竖屏
//
// @param bTop YES:上朝向
// 　　　　　　　　NO:下朝向
// 说明：默认竖屏
// */
//+ (void)setScreenToPortrait:(BOOL)bTop;
///**
// 设置视频横屏
//
// @param bLeft YES:左朝向;
//      　       NO:右朝向
// 说明：如果为横屏横屏，必须设置，如果不设置，录像以及连麦合成流会出错
// */
//+ (void)setScreenToLandscape:(BOOL)bLeft;

@end

#endif /* RTMPCHybirdEngineKit_h */
