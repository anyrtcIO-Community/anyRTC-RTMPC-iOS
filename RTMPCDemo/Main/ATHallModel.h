//
//  ATHallModel.h
//  RTMPCDemo
//
//  Created by jh on 2018/4/13.
//  Copyright © 2018年 jh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATHallModel : NSObject

//拉流地址
@property (nonatomic ,copy)NSString *rtmpUrl;

//hls地址（分享）
@property (nonatomic ,copy)NSString *hlsUrl;

@property (nonatomic ,copy)NSString *liveTopic;

//anyrtcId（唯一）
@property (nonatomic ,copy)NSString *anyrtcId;

//方向  0竖屏 1横屏
@property (nonatomic ,assign)int isLiveLandscape;

//音视频 0视频 1音频
@property (nonatomic ,assign)int isAudioLive;

@property (nonatomic ,copy)NSString *hosterName;

@end

@interface LiveInfo : NSObject //创建直播信息

//anyrtcId（唯一）
@property (nonatomic ,copy)NSString *anyrtcId;

//房间名
@property (nonatomic ,copy)NSString *liveTopic;

//随机名
@property(nonatomic ,copy)NSString *userName;

//用户头像
@property(nonatomic, copy)NSString *headUrl;

//方向  0竖屏 1横屏
@property (nonatomic ,assign)int isLiveLandscape;

//音视频 0视频 1音频
@property (nonatomic ,assign)int isAudioLive;

//直播质量
@property (nonatomic ,copy)NSString *videoMode;

@property (nonatomic ,copy)NSString *push_url;

@property (nonatomic ,copy)NSString *pull_url;

@property (nonatomic ,copy)NSString *hls_url;

@end

@interface GuestInfo: NSObject //用户平台信息

//用户id
@property (nonatomic ,copy)NSString *userId;

//用户头像
@property (nonatomic ,copy)NSString *headUrl;

//用户昵称
@property (nonatomic ,copy)NSString *userName;

@end

@interface ATBarragesModel: NSObject //消息

//用户昵称
@property (nonatomic ,copy)NSString *userName;

//消息内容
@property (nonatomic ,copy)NSString *content;

//是否是主播
@property (nonatomic ,assign)BOOL isHost;

@end
