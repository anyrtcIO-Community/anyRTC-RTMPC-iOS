//
//  RTMeetOption.h
//  RTMeetEngine
//
//  Created by derek on 2017/11/20.
//  Copyright © 2017年 EricTao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RTCCommon.h"

typedef NS_ENUM(NSInteger,RTMeetCameraType) {
    RTMeetCameraTypeNomal = 0,      // 正常的相机模式,系统自带的（效率高）
    RTMeetCameraTypeBeauty         // 美颜相机模式
};

typedef NS_ENUM(NSInteger,AnyMeetingType) {
    AnyMeetingTypeNomal = 0, //一般模式：大家进入会议互相观看
    AnyMeetingTypeHoster = 1//主持模式：主持人进入，可以看到所有人，其他人员只看到主持人
};
@interface RTMeetOption : NSObject
/**
 使用默认配置生成一个 RTMeetOption 对象
 
 @return 生成的 RTMeetOption 对象
 */
+ (nonnull RTMeetOption *)defaultOption;


/**
 是否是前置摄像头
 说明：默认前置摄像头
 */
@property (nonatomic, assign) BOOL isFont;

/**
 设置推流视频质量
 AnyRTCVideoQuality_Low1 = 0,      // 320*240 - 128kbps
 AnyRTCVideoQuality_Low2,          // 352*288 - 256kbps
 AnyRTCVideoQuality_Low3,          // 352*288 - 384kbps
 AnyRTCVideoQuality_Medium1,       // 640*480 - 384kbps
 AnyRTCVideoQuality_Medium2,       // 640*480 - 512kbps
 AnyRTCVideoQuality_Medium3,       // 640*480 - 768kbps
 AnyRTCVideoQuality_Height1,       // 960*540 - 768kbps
 AnyRTCVideoQuality_Height2,       // 1280*720 - 1024kbps
 AnyRTCVideoQuality_Height3,       // 1920*1080 - 2048kbps
 
 说明:　默认：AnyRTCVideoQuality_Medium2
 */
@property (nonatomic, assign) AnyRTCVideoQualityModel videoMode;

/**
 视频方向：默认：RTC_SCRN_Portrait竖屏
 */
@property (nonatomic, assign) RTCScreenOrientation videoScreenOrientation;

/**
 自动旋转(这里只支持 left 变 right  portrait 变 portraitUpsideDown)
 */
@property (nonatomic, assign) BOOL autorotate;
/**
 设置显示模板。人数上限默认为4个，根据个人需要联系客服开通更多人会议。
 说明：默认：RTC_V_1X3
 　　　RTC_V_1X3为小型会议模式，视频窗口比例默认为３：４，根据设置videoMode而定；
 　　　RTC_V_3X3_auto为多人小型会议模式，窗口比例为１：１，该模式下分辨率为288*288
 */
@property (nonatomic, assign) RTCVideoLayout videoLayOut;

/**
 设置会议模式：默认为：AnyMeetingTypeNomal
 */
@property (nonatomic, assign) AnyMeetingType meetingType;

/**
 设置相机类型
 说明：根据自己的需求，选择相应的相机类型;默认RTMeetCameraTypeNomal
 */
@property (nonatomic, nonatomic) RTMeetCameraType cameraType;

/**
 视频会议最大人数(默认为4人，根据自己需求更改，建议不要超过9人)
 说明：该参数会在joinRTC的时候告诉服务最大支持人数：对应字段：MaxJoiner,请保持android、iOS、以及其他端保持统一。
 */
@property (nonatomic, assign) int maxNum;
@end
