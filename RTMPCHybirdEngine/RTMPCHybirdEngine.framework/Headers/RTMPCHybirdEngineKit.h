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
 *  Configuration AnyRtc object.
 *
 *  @param nsDevelopID   the developer ID of RTMPC on the platform
 *  @param nsAppID       the user's app Name on the platform
 *  @param nsKey         the user's app key on the platform
 *  @param nsToken       the user's app token on the platform
 */
+ (void) InitEngineWithAnyrtcInfo:(NSString*)nsDevelopID andAppId:(NSString*)nsAppID andKey:(NSString*)nsKey andToke:(NSString*)nsToken;
/**
 *  Config private server
 *
 *  @param nsSvrAddr server address
 *  @param nSvrPort  server port
 */
+ (void) ConfigServerForPriCloud:(NSString*)nsSvrAddr andPort:(int)nSvrPort;
/**
 *  Get the server address
 *
 *  @return server address
 */
+ (NSString*) GetHttpAddr;
/**
 *  Get the version of RTMPC SDK.
 *
 *  @return  sdk version
 */
+ (NSString*)GetRTMPCSdkVersion;
@end

#endif /* RTMPCHybirdEngineKit_h */
