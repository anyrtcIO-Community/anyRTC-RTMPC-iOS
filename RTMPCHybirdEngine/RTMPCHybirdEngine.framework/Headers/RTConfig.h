//
//  RTConfig.h
//  RTMPCHybirdEngine
//
//  Created by EricTao on 2017/3/9.
//  Copyright © 2017年 EricTao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RTCCommon.h"
@interface RTConfig : NSObject {
    
}

+ (void) SetVideoLayout:(RTCVideoLayout)layout;

+ (RTCVideoLayout) VideoLayout;

//  VideoLayout 为RTC_V_1X3的时候，设置该功能。
+ (void) SetVideoOrientation:(RTCScreenOrientation)orientation;

+ (RTCScreenOrientation) VideoOritentation;

@end
