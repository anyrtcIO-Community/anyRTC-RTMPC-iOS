//
//  RTMPCGuestOption.h
//  RTMPCHybirdEngine
//
//  Created by derek on 2017/11/9.
//  Copyright © 2017年 EricTao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RTMPCHosterOption.h"

typedef NS_ENUM(NSInteger,VideoShowMode){
    VideoShowModeScaleAspectFit,
    VideoShowModeScaleAspectFill,  // default by height scale (高度填充整个屏幕)
    VideoShowModeCenter
};

typedef NS_ENUM(NSInteger,LinkMediaMode){
    LinkMediaModeVideo, //默认视频连麦模式
    LinkMediaModeAudio  //音频连麦模式
};

@interface RTMPCGuestOption : NSObject
/**
 使用默认配置生成一个 RTMPCGuestOption 对象
 
 @return 生成的 RTMPCGuestOption 对象
 */
+ (nonnull RTMPCGuestOption *)defaultOption;

/**
 是否是前置摄像头
 说明：默认前置摄像头
 */
@property (nonatomic, assign) BOOL isFont;

/**
 连麦模式（默认为LinkMediaModeVideo）
 */
@property (nonatomic, assign) LinkMediaMode linkMediaModel;


/**
 是否打开音频检测（只有模式为LinkMediaModeAudio的时候，设置才有用）
 */
@property (nonatomic, assign) BOOL isAudioDetect;

/**
 视频方向：默认：RTMPCScreenPortraitType竖屏
 说明：请跟主播端保持一致
 */
@property (nonatomic, assign) RTMPCScreenOrientationType videoScreenOrientation;

/**
 播放器显示模式
 说明：默认：VideoShowModeScaleAspectFill
 */
@property (nonatomic, assign) VideoShowMode videoContentMode;

@end
