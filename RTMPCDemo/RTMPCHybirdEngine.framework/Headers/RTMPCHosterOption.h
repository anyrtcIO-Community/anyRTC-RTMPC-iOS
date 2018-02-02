//
//  RTMPCHosterOption.h
//  RTMPCHybirdEngine
//
//  Created by derek on 2017/11/9.
//  Copyright © 2017年 EricTao. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "RTCCommon.h"

typedef NS_ENUM(NSInteger,RTMPCCameraType) {
    RTMPCCameraTypeNomal = 0,      // 正常的相机模式,系统自带的（效率高）
    RTMPCCameraTypeBeauty,         // 美颜相机模式
    RTMPCCameraTypeThreeFilter     // 第三方滤镜模式 eg:图图，FaceU等等;
};

typedef NS_ENUM(NSInteger,RTMPCScreenOrientationType) {
    RTMPCScreenPortraitType = 0,      // 竖屏
    RTMPCScreenLandscapeLeftType = 1,// 横屏（左边）
    RTMPCScreenLandscapeRightType = 2 // 横屏（右边）
};

typedef NS_ENUM(NSInteger,LivingMediaMode){
    LivingMediaModeVideo, //默认视频直播模式
    LivingMediaModeAudio  //音频直播模式
};


@interface RTMPCHosterOption : NSObject
/**
 使用默认配置生成一个 RTMPCHosterOption 对象
 
 @return 生成的 RTMPCHosterOption 对象
 */
+ (nonnull RTMPCHosterOption *)defaultOption;

/**
 直播模式：默认LivingMediaModeVideo视频直播模式
 注意：当为LivingMediaModeAudio的时候，对视频的配置信息将无用
 */
@property (nonatomic, assign) LivingMediaMode livingMediaMode;

/**
 是否打开音频检测（只有模式为LivingMediaModeAudio的时候，设置才有用）
 */
@property (nonatomic, assign) BOOL isAudioDetect;

/**
 是否是前置摄像头
 说明：默认前置摄像头
 */
@property (nonatomic, assign) BOOL isFont;

/**
 设置相机类型
 说明：根据自己的需求，选择相应的相机类型;默认RTMPCCameraTypeNomal
 */
@property (nonatomic, nonatomic) RTMPCCameraType cameraType;
/**
 设置推流视频质量
 RTMPC_Video_1080P:1920*1080,码率:2048
 RTMPC_Video_Low、RTMPC_Video_SD、RTMPC_Video_QHD:640*480,码率:384,512,768
 RTMPC_Video_HD:960*540,码率:1024
 
 说明:　默认：RTMPC_Video_SD
 */
@property (nonatomic, assign) RTMPCVideoMode videoMode;

/**
 视频方向：默认：RTMPCScreenPortraitType竖屏
 */
@property (nonatomic, assign) RTMPCScreenOrientationType videoScreenOrientation;

@end
