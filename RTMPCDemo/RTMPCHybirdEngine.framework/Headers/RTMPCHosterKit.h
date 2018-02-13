//
//  RTMPCHosterKit.h
//  RTMPCHybirdEngine
//
//  Created by EricTao on 16/7/16.
//  Copyright © 2016年 EricTao. All rights reserved.
//

#ifndef RTMPCHosterKit_h
#define RTMPCHosterKit_h
#import <UIKit/UIKit.h>
#import "RTMPCHosterDelegate.h"
#import "RTMPCHosterOption.h"


@interface RTMPCHosterKit : NSObject {
    
}
/**
 RTC 相关回调代理，如果不用RTC，该回调不用设置
 */
@property (weak, nonatomic) id<RTMPCHosterRtcDelegate> rtc_delegate;

/**
 实例化主播对象

 @param delegate RTMP推流相关回调代理
 @param option 配置项
 @return 主播对象
 */
- (instancetype)initWithDelegate:(id<RTMPCHosterRtmpDelegate>)delegate andOption:(RTMPCHosterOption *)option;

/**
 销毁主播对象，相当于析构函数
 */
- (void)clear;

/**
 视频数据外部视频流
 
 @param pixelBuffer 视频流（可能是原始的，也可能是处理过的）
 */
- (void)capturePixelBuffer:(CVPixelBufferRef)pixelBuffer;

#pragma mark Common function
/**
 设置本地视频采集窗口

 @param render 视频显示对象
 说明：该方法用于本地视频采集。
 */
- (void)setLocalVideoCapturer:(UIView*)render;
/**
 设置录像地址
 
 @param strRecordUrl 需要录像流的地址；
 说明：设置Rtmp录制地址，需放在开始开始推流方法前（开启录像服务
 需现在www.anyrtc.io官网开通录像服务）
 */
- (void)setRtmpRecordUrl:(NSString*)strRecordUrl;

/**
 开始推流

 @param strUrl RTMP推流地址
 @return yes为推流成功，no为推流失败。
 */
- (BOOL)startPushRtmpStream:(NSString*)strUrl;

/**
 停止推流
 说明：调用此方法停止推流并且关闭RTC服务，直播关闭
 */
- (void)stopRtmpStream;

/**
 设置本地音频是否传输

 @param bEnable 打开或关闭本地音频
 说明：yes为传输音频,no为不传输音频，默认传输
 */
- (void)setLocalAudioEnable:(BOOL)bEnable;

/**
 设置本地视频是否传输

 @param bEnable 打开或关闭本地视频
 说明：yes为传输视频，no为不传输视频，默认视频传输
 */
- (void)setLocalVideoEnable:(BOOL)bEnable;

/**
 切换前后摄像头
 说明:切换本地前后摄像头。
 */
- (void)switchCamera;

/**
 开启美颜:使用系统美颜，默认是打开的

 @param bEnable YES/NO:美颜/不美颜
 */
- (void)setBeautyEnable:(BOOL) bEnable;
/**
 打开手机闪光灯

 @param bOn YES为打开，NO为关闭；

 @return 返回成功与否
 说明：打开手机闪光灯。
 */
- (BOOL)openCameraTorchMode:(BOOL)bOn;

/**
 打开对焦功能(iOS特有)

 @param image 点击自动对焦时的图片；
　说明：默认关闭自动对焦。
 */
- (void)setCameraFocusImage:(UIImage*)image;

/**
 设置相机焦距

 @param fDistance 焦距调整（1.0~3.0）；
 说明：默认为1.0。
 */
- (void)setCameraZoom:(CGFloat)fDistance;

/**
 获取相机当前焦距

 @return 焦距（1.0~3.0）
 返回值：相机当前焦距
 */
- (CGFloat)getCameraZoom;

/**
 设置前置摄像头镜像是否打开
 
 @param bEnable YES为打开，NO为关闭
 说明：默认关闭
 */
- (void)setFontCameraMirrorEnable:(BOOL)bEnable;

#pragma mark RTC function for line
/**
 创建RTC链接

 @param strAnyRTCId 开发者业务系统中保持唯一的id（必填）；
 @param strUserId 播在开发者自己平台的id，可选
 @param strUserData 播在开发者自己平台的相关信息（昵称，头像等），可选。(限制512字节)
 @param strLiveInfo 直播间相关信息（推流地址，直播间名称等），可选。（限制1024字节）
 @return 打开RTC成功与否
 说明:
 strUserId，若不设置，发消息接口不能使用。
 strUserData，将会出现在游客连麦回调中，若不设置，人员上下线接口将无用。
 strLiveInfo,该信息在RTMPCHttpKit类中getLivingList方法中获取。若不设置，获取直播列表信息为空。
 该方法须在开始推流（StartPushRtmpStream）方法后调用
 */
- (BOOL)createRTCLine:(NSString*)strAnyRTCId andUserId:(NSString*)strUserId andUserData:(NSString*)strUserData andLiveInfo:(NSString*)strLiveInfo;
/**
 同意游客连麦请求

 @param strLivePeerId RTC服务生成的连麦者标识Id 。(用于标识连麦用户，每次连麦随机生成)
 @return yes为同意连麦；no为同意连麦失败（可能超过连麦数量）
 说明：调用此方法即可同意游客的连麦请求。同意后，视频直播模式下将会回调游客视频连麦接通方法，具体操作可查看 游客视频连麦接通 回调。音频直播模式下将会回调游客音频连麦接通方法，具体操作可查看 游客音频连麦接通回调。
 */
- (BOOL)acceptRTCLine:(NSString*)strLivePeerId;

/**
 拒绝游客连麦请求

 @param strLivePeerId RTC服务生成的连麦者标识Id 。(用于标识连麦用户，每次连麦随机生成)
 说明：当有游客请求连麦时，可调用此方法拒绝
 */
- (void)rejectRTCLine:(NSString*)strLivePeerId;

/**
 设置连麦者视频窗口
 
 @param strRTCPubId 连麦者视频流id(用于标识连麦者发布的流)；
 @param render 对方视频的窗口，本地设置；
 说明：该方法用于游客申请连麦接通后，游客视频连麦接通回调中（onRTCOpenVideoRender）使用。
 */
- (void)setRTCVideoRender:(NSString*)strRTCPubId andRender:(UIView*)render;

/**
 挂断游客连麦

 @param strLivePeerId RTC服务生成的连麦者标识Id 。(用于标识连麦用户，每次连麦随机生成)
 说明:与游客连麦过程中，可调用此方法挂断与他的连麦
 */
- (void)hangupRTCLine:(NSString*)strLivePeerId;

/**
 发送消息

 @param eType 消息类型:RTMPC_Nomal_Message_Type:普通消息;RTMPC_Barrage_Message_Type:弹幕消息
 @param strUserName 用户昵称(最大256字节)，不能为空，否则发送失败；
 @param strUserHeaderUrl 用户头像(最大512字节)，可选
 @param strContent 消息内容(最大1024字节)不能为空，否则发送失败；
 @return YES/NO 发送成功/发送失败
 说明：默认普通消息。以上参数均会出现在游客/主播消息回调方法中，如果创建RTC连接（createRTCLine）没有设置strUserid，发送失败。
 */

- (int)sendUserMessage:(RTMPCMessageType)eType withUserName:(NSString*)strUserName andUserHeader:(NSString*)strUserHeaderUrl andContent:(NSString*)strContent;

/**
 关闭RTC链接
 说明：主播端如果调用此方法，将会关闭RTC服务，若开启了直播在线功能（可在www.anyrtc.io 应用管理中心开通），游客端会收到主播已离开(onRTCLineLeave)的回调。
 */
- (void)closeRTCLine;


/**
 设置副视频、连麦用户关闭视频后显示填充图（vip专用接口，预想使用，请联系商务）
 
 @param bgFilePath 图片的地址（jpg,jpeg格式的图片）
 */
- (void)setVideoSubBackground:(NSString *)bgFilePath;

/**
 设置合成视频显示模板
 
 @param eLayoutModel 模板类型
 RTMPC_LINE_V_Fullscrn        // 默认模式：主播全屏，副主播小屏
 RTMPC_LINE_V_1_equal_others  // 主播跟副主播视频大小一致
 RTMPC_LINE_V_1big_3small     // 主播大屏（非全屏）副主播小屏
 说明：该方法配合setVideoTemplate方法使用。
 */
- (void)setMixVideoModel:(RTMPCLineVideoLayout)eLayoutModel;

/**
 设置合成流显示位置

 @param eHor 水平排布）RTMPC_V_T_HOR_LEFT :水平左边  RTMPC_V_T_HOR_CENTER：水平中间 RTMPC_V_T_HOR_RIGHT：水平右边
 @param eVer （竖直排布）RTMPC_V_T_VER_TOP ：垂直顶部  RTMPC_V_T_VER_CENTER：垂直居中 RTMPC_V_T_VER_BOTTOM：垂直底部
 @param eDir （排布方向）RTMPC_V_T_DIR_HOR：水平排布 RTMPC_V_T_DIR_VER：垂直排布
 @param nPadhor 水平的间距（左右间距：最左边或者最后边的视频离边框的距离）
 @param nPadver 垂直的间距（上下间距：最上面或者最下面离边框的距离）
 @param nLineWidth 小窗口的边框的宽度（边框为白色）
 */
- (void)setVideoTemplate:(RTMPCVideoTempHor)eHor temVer:(RTMPCVideoTempVer)eVer temDir:(RTMPCVideoTempDir)eDir padhor:(int)nPadhor padver:(int)nPadver lineWidth:(int)nLineWidth;

@end
#endif /* RTMPCHosterKit_h */
