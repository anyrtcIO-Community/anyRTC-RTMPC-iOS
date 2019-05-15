//
//  ARHosterOption.h
//  RTMPCHybirdEngine
//
//  Created by zjq on 2019/1/16.
//  Copyright © 2019 EricTao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ARRtmpEnum.h"

NS_ASSUME_NONNULL_BEGIN

@interface ARHosterOption : NSObject

/**
 使用默认配置生成一个 ARHosterOption 对象
 
 @return 生成的 ARHosterOption 对象
 */
+ (nonnull ARHosterOption *)defaultOption;

/**
 直播模式：默认ARLivingMediaModeVideo视频直播模式
 注意：当为ARLivingMediaModeAudio的时候，对视频的配置信息将无用
 */
@property (nonatomic, assign) ARLivingMediaMode livingMediaMode;

/**
 设置相机类型
 说明：根据自己的需求，选择相应的相机类型;默认ARRtmpCameraTypeNomal
 */
@property (nonatomic, nonatomic) ARRtmpCameraType cameraType;


/**
 是否是前置摄像头
 说明：默认前置摄像头
 */
@property (nonatomic, assign) BOOL isFont;


/**
 视频分辨率：默认:ARVideoProfile360x640
 */
@property (nonatomic, assign) ARVideoProfile videoProfile;


/**
 视频帧率：默认:ARVideoFrameRateFps15
 */
@property (nonatomic, assign) ARVideoFrameRate videoFrameRate;

/**
 视频方向：默认：ARRtmpCameraPortraitType竖屏
 */
@property (nonatomic, assign) ARRtmpCameraOrientation cameraOrientation;

/**
 自动旋转(这里只支持 left 变 right  portrait 变 portraitUpsideDown)
 */
@property (nonatomic, assign) BOOL autorotate;

@end

NS_ASSUME_NONNULL_END
