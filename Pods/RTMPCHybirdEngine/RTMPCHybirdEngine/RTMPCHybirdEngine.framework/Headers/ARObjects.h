//
//  ARObjects.h
//  RTCLib
//
//  Created by zjq on 2019/1/15.
//  Copyright © 2019 MaoZongWu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ARCommonEnum.h"

NS_ASSUME_NONNULL_BEGIN

// 用户信息
@interface ARUserItem : NSObject

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *peerId;
@property (nonatomic, copy) NSString *pubId;
@property (nonatomic, copy) NSString *userData;
@property (nonatomic, assign) BOOL audioEnable;
@property (nonatomic, assign) BOOL videoEnable;
@end

@interface ARObjects : NSObject

@end

@interface ARVideoConfig : NSObject
/**
 是否是前置摄像头
 说明：默认前置摄像头
 */
@property (nonatomic, assign) BOOL isFont;

/**
 设置视频质量
 
 说明:　默认：ARVideoProfile480x640
 */
@property (nonatomic, assign) ARVideoProfile videoProfile;

/**
 设置视频帧率
 说明：默认：RTMeetVideoFrameRateFps15
 */
@property (nonatomic, assign) ARVideoFrameRate videoFrameRate;

/**
 视频码率：如果不配置，使用分辨率默认的;
 说明：区间大小（65~1280)
 */
@property (nonatomic, assign) int  bitrate;
/**
 视频方向：默认：ARCameraPortrait 竖屏
 */
@property (nonatomic, assign) ARCameraOrientation cameraOrientation;

/**
 自动旋转：默认为NO
 说明:设置为YES；这里只支持 left 变 right  portrait 变 portraitUpsideDown
 */
@property (nonatomic, assign) BOOL autorotate;

@end

NS_ASSUME_NONNULL_END
