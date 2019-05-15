//
//  ArMainModel.h
//  RTMPCDemo
//
//  Created by 余生丶 on 2019/4/11.
//  Copyright © 2019 anyRTC. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ArMainModel : NSObject

//拉流地址
@property (nonatomic ,copy) NSString *rtmpUrl;
//hls地址（分享）
@property (nonatomic ,copy) NSString *hlsUrl;
@property (nonatomic ,copy) NSString *liveTopic;
//anyrtcId
@property (nonatomic ,copy) NSString *anyrtcId;
//方向  0竖屏 1横屏
@property (nonatomic ,assign) int isLiveLandscape;
//音视频 0视频 1音频
@property (nonatomic ,assign) int isAudioLive;
@property (nonatomic ,copy) NSString *hosterName;

@end

@interface ArLiveInfo : NSObject

@property (nonatomic, copy) NSString *anyrtcId;
@property (nonatomic ,copy) NSString *push_url;
@property (nonatomic ,copy) NSString *pull_url;
@property (nonatomic ,copy) NSString *hls_url;

@end

NS_ASSUME_NONNULL_END
