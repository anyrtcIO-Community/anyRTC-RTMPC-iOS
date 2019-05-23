//
//  ARGuestOption.h
//  RTMPCHybirdEngine
//
//  Created by zjq on 2019/1/16.
//  Copyright © 2019 EricTao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ARRtmpEnum.h"

NS_ASSUME_NONNULL_BEGIN

@interface ARGuestOption : NSObject
/**
 使用默认配置生成一个 ARGuestOption 对象
 
 @return 生成的 ARGuestOption 对象
 */
+ (nonnull ARGuestOption *)defaultOption;


/**
 连麦模式：默认为音视频连麦模式
 */
@property (nonatomic, assign) ARLinkMediaMode linkMediaModel;

/**
 是否是前置摄像头
 说明：默认前置摄像头
 */
@property (nonatomic, assign) BOOL isFont;

/**
 视频方向：默认：ARRtmpCameraPortraitType竖屏
 */
@property (nonatomic, assign) ARRtmpCameraOrientation cameraOrientation;

/**
 播放器显示模式
 说明：默认：ARVideoRenderScaleAspectFill
 */
@property (nonatomic, assign) ARVideoRenderMode videoRenderMode;

/**
 自动旋转(这里只支持 left 变 right  portrait 变 portraitUpsideDown)
 说明：只有连麦的时候才有用
 */
@property (nonatomic, assign) BOOL autorotate;


/**
 是否需要camera数据：默认为NO;
 说明：设置YES:将会有onRTCCaptureVideoPixelBuffer回调
 */
@property (nonatomic, assign) BOOL needCarmeraData;


@end

NS_ASSUME_NONNULL_END
