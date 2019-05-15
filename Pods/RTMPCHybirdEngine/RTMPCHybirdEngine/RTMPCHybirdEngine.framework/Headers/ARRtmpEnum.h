//
//  ARRtmpEnum.h
//  RTMPCHybirdEngine
//
//  Created by zjq on 2019/1/16.
//  Copyright © 2019 EricTao. All rights reserved.
//

#ifndef ARRtmpEnum_h
#define ARRtmpEnum_h

#import "ARCommonEnum.h"


typedef NS_ENUM(NSInteger,ARRtmpCode) {
    ARRtmp_OK = 0,                      // 正常
    ARRtmp_UNKNOW = 1,                  // 未知错误
    ARRtmp_EXCEPTION = 2,               // SDK调用异常
    ARRtmp_EXP_UNINIT = 3,              // SDK未初始化
    ARRtmp_EXP_PARAMS_INVALIDE = 4,     // 参数非法
    ARRtmp_EXP_NO_NETWORK = 5,          // 没有网络链接
    ARRtmp_EXP_NOT_FOUND_CAMERA = 6,    // 没有找到摄像头设备
    ARRtmp_EXP_NO_CAMERA_PERMISSION = 7,// 没有打开摄像头权限
    ARRtmp_EXP_NO_AUDIO_PERMISSION = 8, // 没有音频录音权限
    ARRtmp_EXP_NOT_SUPPORT_WEBRTC = 9,  // 浏览器不支持原生的webrtc
    
    
    ARRtmp_NET_ERR = 100,               // 网络错误
    ARRtmp_NET_DISSCONNECT = 101,       // 网络断开
    ARRtmp_LIVE_ERR    = 102,           // 直播出错
    ARRtmp_EXP_ERR = 103,               // 异常错误
    ARRtmp_EXP_Unauthorized = 104,      // 服务未授权(仅可能出现在私有云项目)
    
    ARRtmp_BAD_REQ = 201,               // 服务不支持的错误请求
    ARRtmp_AUTH_FAIL = 202,             // 认证失败
    ARRtmp_NO_USER = 203,               // 此开发者信息不存在
    ARRtmp_SVR_ERR = 204,               // 服务器内部错误
    ARRtmp_SQL_ERR = 205,               // 服务器内部数据库错误
    ARRtmp_ARREARS = 206,               // 账号欠费
    ARRtmp_LOCKED = 207,                // 账号被锁定
    ARRtmp_SERVER_NOT_OPEN = 208,       // 服务未开通
    ARRtmp_ALLOC_NO_RES = 209,          // 没有服务器资源
    ARRtmp_SERVER_NOT_SURPPORT = 210,   // 不支持的服务
    ARRtmp_FORCE_EXIT = 211,            // 强制离开
    ARRtmp_AUTH_TIMEOUT = 212,          // 验证超时
    ARRtmp_NEED_VERTIFY_TOKEN = 213,    // 需要验证userToken
    
    ARRtmp_NOT_START = 600,             // 直播未开始
    ARRtmp_HOSTER_REJECT = 601,         // 主播拒绝连麦
    ARRtmp_LINE_FULL = 602,             // 连麦已满
    ARRtmp_CLOSE_ERR = 603,             // 游客关闭错误，onRtmpPlayerClosed
    ARRtmp_HAS_OPENED = 604,            // 直播已经开始，不能重复开启
    ARRtmp_IS_STOP = 605,               // 直播已结束
};

// 相机类型
typedef NS_ENUM(NSInteger,ARRtmpCameraType) {
    ARRtmpCameraTypeNomal = 0,      // 正常的相机模式,系统自带的（效率高）
    ARRtmpCameraTypeBeauty,         // 美颜相机模式
    ARRtmpCameraTypeThreeFilter     // 第三方滤镜模式 eg:图图、Face++、商汤等等;
};

// 摄像头方向
typedef NS_ENUM(NSInteger,ARRtmpCameraOrientation) {
    ARRtmpCameraPortraitType = 0,       // 竖屏
    ARRtmpCameraLandscapeLeftType = 1,  // 横屏（左边）
    ARRtmpCameraLandscapeRightType = 2  // 横屏（右边）
};

// 直播的媒体模式：是音视频直播，还是音频直播
typedef NS_ENUM(NSInteger,ARLivingMediaMode){
    ARLivingMediaModeVideo = 0, //默认视频直播模式
    ARLivingMediaModeAudio      //音频直播模式
};

// 连麦的媒体模式：是音视频连麦，还是音频连麦
typedef NS_ENUM(NSInteger,ARLinkMediaMode){
    ARLinkMediaModeVideo = 0, //默认音视频连麦模式
    ARLinkMediaModeAudio      //音频连麦模式
};

// 消息类型
typedef NS_ENUM (NSInteger, ARMessageType) {
    ARNomalMessageType = 0,
    ARBarrageMessageType
};

// RTMP视频流合成模板
typedef NS_ENUM (NSInteger, ARMixVideoLayoutModel) {
    ARMixVideoFullModel = 0,          // 默认模式：主播全屏，副主播小屏
    ARMixVideoOneEqualOtherModel,     // 主播跟副主播视频大小一致
    ARMixVideoOneBigThreeSmallModel   // 主播大屏（非全屏）副主播小屏
};

// 水平排版样式
typedef NS_ENUM (NSInteger, ARMixVideoHorModel) {
    ARMixVideoHorLeftModel = 0,
    ARMixVideoHorCenterModel,
    ARMixVideoHorRightModel,
};

// 垂直排版样式
typedef NS_ENUM (NSInteger, ARMixVideoVerModel) {
    ARMixVideoVerTopModel = 0,
    ARMixVideoVerCenterModel,
    ARMixVideoVerBottomModel,
};

// 排版样式
typedef NS_ENUM (NSInteger, ARMixVideoDirModel) {
    ARMixVideoDirHorModel = 0,
    ARMixVideoDirVerModel,
};

#endif /* ARRtmpEnum_h */
