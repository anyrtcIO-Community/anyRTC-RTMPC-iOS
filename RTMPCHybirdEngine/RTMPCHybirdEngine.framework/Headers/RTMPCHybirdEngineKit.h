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

+ (void) InitEngineWithAnyrtcInfo:(NSString*)nsDevelopID andAppId:(NSString*)nsAppID andKey:(NSString*)nsKey andToke:(NSString*)nsToken;

+ (void) ConfigServerForPriCloud:(NSString*)nsSvrAddr andPort:(int)nSvrPort;

+ (NSString*) GetHttpAddr;

@end

#endif /* RTMPCHybirdEngineKit_h */
