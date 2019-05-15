//
//  ARRtmpHosterKit.h
//  RTMPCHybirdEngine
//
//  Created by zjq on 2019/1/16.
//  Copyright © 2019 EricTao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ARRtmpHosterKitDelegate.h"
#import "ARHosterOption.h"
#import "ARRtmpEnum.h"


NS_ASSUME_NONNULL_BEGIN

@interface ARRtmpHosterKit : NSObject

/**
 RTC 相关回调代理，如果不用RTC，该回调不用设置
 */
@property (weak, nonatomic) id<ARHosterRtcDelegate> rtc_delegate;

/**
 实例化主播对象
 
 @param delegate RTMP推流相关回调代理
 @param option 配置项
 @return 主播对象
 */
- (instancetype)initWithDelegate:(id<ARHosterRtmpDelegate>)delegate option:(ARHosterOption *)option;

/**
 销毁主播对象
 
 说明：相当于析构函数
 */
- (void)clear;

#pragma mark Common function

/**
 设置本地视频采集窗口
 
 @param render 视频显示对象
 */
- (void)setLocalVideoCapturer:(UIView *)render;

/**
 开始推流
 
 @param pushUrl RTMP推流地址
 @return YES为推流成功，NO为推流失败。
 */
- (BOOL)startPushRtmpStream:(NSString *)pushUrl;

/**
 停止推流
 
 说明：调用此方法停止推流并且关闭RTC服务，直播关闭。
 */
- (void)stopRtmpStream;

/**
 设置本地音频是否传输
 
 @param enable YES为传输音频，NO为不传输音频，默认传输
 */
- (void)setLocalAudioEnable:(BOOL)enable;

/**
 设置本地视频是否传输
 
 @param enable YES为传输视频，NO为不传输视频，默认视频传输
 */
- (void)setLocalVideoEnable:(BOOL)enable;

/**
 切换前后摄像头
 */
- (void)switchCamera;

/**
 设置滤镜
 
 @param filter 滤镜模式
 说明：使用美颜相机模式，默认开启美颜。
 */
- (void)setCameraFilter:(ARCameraFilterMode)filter;

/**
 打开手机闪光灯
 
 @param on YES为打开，NO为关闭
 @return 操作是否成功
 */
- (BOOL)openCameraTorchMode:(BOOL)on;

/**
 打开对焦功能(iOS特有)
 
 @param image 点击自动对焦时的图片
 说明：默认关闭自动对焦。
 */
- (void)setCameraFocusImage:(UIImage *)image;

/**
 设置相机焦距
 
 @param distance 焦距调整(1.0~3.0)，默认为1.0
 */
- (void)setCameraZoom:(CGFloat)distance;

/**
 获取相机当前焦距
 
 @return 焦距(1.0~3.0)
 */
- (CGFloat)getCameraZoom;

/**
 设置本地前置摄像头镜像是否打开
 
 @param enable YES为打开，NO为关闭，默认打开
 @return 操作是否成功
 */
- (BOOL)setFontCameraMirrorEnable:(BOOL)enable;

/**
 设置水印
 
 @param logoView 水印视图
 说明：只有美颜相机才有用。
 */
- (void)setLogoView:(UIView *)logoView;

#pragma mark RTC function for line

/**
 创建RTC直播间

 @param token 令牌:客户端向自己服务申请获得，参考企业级安全指南()
 @param liveId 直播间Id,系统业务自己管理
 @param userId 主播用户id
 @param userData 主播其他相关信息（昵称，头像等）(限制512字节)
 @param liveInfo 直播间相关信息（推流地址，直播间名称等）（限制1024字节）
 @return 创建成果与失败
 说明：userId若不设置，发消息接口不能使用。userData，将会出现在游客连麦回调中，若不设置，人员上下线接口将无用。liveInfo该信息在ARRtmpHttpKit类中getLivingList方法中获取。若不设置，获取直播列表信息为空。该方法须在开始推流（startPushRtmpStream）方法后调用
 */
- (BOOL)createRTCLineByToken:(NSString* _Nullable)token
                      liveId:(NSString *)liveId
                      userId:(NSString *)userId
                    userData:(NSString *)userData
                    liveInfo:(NSString *)liveInfo;

/**
 同意游客连麦请求
 
 @param peerId RTC服务生成的连麦者标识Id 。(用于标识连麦用户，每次连麦随机生成)
 @return YES为同意连麦，NO为同意连麦失败（可能超过连麦数量）
 说明：调用此方法即可同意游客的连麦请求。同意后视频直播模式下将会回调游客视频连麦接通方法，具体操作可查看ARRtmpHosterKitDelegate回调。音频直播模式下将会回调游客音频连麦接通方法，具体操作可查看 游客音频连麦接通回调。
 */
- (BOOL)acceptRTCLine:(NSString *)peerId;

/**
 拒绝游客连麦请求
 
 @param peerId RTC服务生成的连麦者标识Id 。(用于标识连麦用户，每次连麦随机生成)
 说明：当有游客请求连麦时，可调用此方法拒绝。
 */
- (void)rejectRTCLine:(NSString *)peerId;

/**
 设置连麦者视频窗口
 
 @param render 对方视频的窗口，本地设置
 @param pubId 连麦者视频流id(用于标识连麦者发布的流)
 说明：该方法用于游客申请连麦接通后，游客视频连麦接通回调中(onRTCOpenRemoteVideoRender)使用。
 */
- (void)setRemoteVideoRender:(UIView *)render pubId:(NSString *)pubId;

/**
 挂断游客连麦
 
 @param peerId RTC服务生成的连麦者标识Id 。(用于标识连麦用户，每次连麦随机生成)
 说明：与游客连麦过程中，可调用此方法挂断连麦
 */
- (void)hangupRTCLine:(NSString *)peerId;

/**
 发送消息
 
 @param type 消息类型，ARNomalMessageType普通消息，ARBarrageMessageType弹幕消息
 @param userName 用户昵称，不能为空，否则发送失败(最大256字节)
 @param headerUrl 用户头像，可选(最大512字节)
 @param content 消息内容不能为空，否则发送失败(最大1024字节)
 @return YES发送成功，NO发送失败
 说明：默认普通消息，以上参数均会出现在游客/主播消息回调方法中，如果创建RTC连接（createRTCLine）没有设置userId，发送失败。
 */

- (BOOL)sendUserMessage:(ARMessageType)type userName:(NSString *)userName userHeader:(NSString *)headerUrl content:(NSString *)content;

/**
 关闭RTC链接
 
 说明：主播端如果调用此方法，将会关闭RTC服务，若开启了直播在线功能（可在www.anyrtc.io 应用管理中心开通），游客端会收到主播已离开(onRTCLineLeave)的回调。
 */
- (void)closeRTCLine;

#pragma mark - 合成模板设置

/**
 设置副视频、连麦用户关闭视频后显示填充图
 
 @param filePath 图片的地址（jpg,jpeg格式的图片）
 说明：vip专用接口，预想使用，请联系商务。
 */
- (void)setVideoSubBackground:(NSString *)filePath;

/**
 设置合成视频显示模板
 
 @param mixModel 模板类型
 说明：该方法配合setVideoTemplate方法使用。
 */
- (void)setMixVideoModel:(ARMixVideoLayoutModel)mixModel;

/**
 设置副主播合成流显示位置（ARMixVideoFullModel模式）
 
 @param hor 水平排布 ARMixVideoHorLeftModel/ARMixVideoHorCenterModel/ARMixVideoHorRightModel:水平左边/水平中间/水平右边
 @param ver 竖直排布 ARMixVideoVerTopModel/ARMixVideoVerCenterModel/ARMixVideoVerBottomModel:垂直顶部/垂直居中/垂直底部
 @param dir 排布方向 ARMixVideoDirHorModel/ARMixVideoDirVerModel:水平排布/垂直排布
 @param horPad 水平的间距（左右间距：最左边或者最后边的视频离边框的距离）
 @param verPad 垂直的间距（上下间距：最上面或者最下面离边框的距离）
 @param borderWidth 小窗口的边框的宽度（边框为白色）
 */
- (void)setVideoTemplate:(ARMixVideoHorModel)hor ver:(ARMixVideoVerModel)ver dir:(ARMixVideoDirModel)dir horPad:(int)horPad verPad:(int)verPad borderWidth:(int)borderWidth;

@end

NS_ASSUME_NONNULL_END

