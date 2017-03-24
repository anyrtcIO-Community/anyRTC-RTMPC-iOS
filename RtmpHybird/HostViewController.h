//
//  HostViewController.h
//  RTMPCDemo
//
//  Created by jianqiangzhang on 16/7/21.
//  Copyright © 2016年 EricTao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RTMPCHybirdEngine/RTMPCCommon.h>

@interface HostViewController : UIViewController
@property (nonatomic, strong) NSString *livingName;
@property (nonatomic, assign) RTMPCVideoMode rtmpVideoMode;
@property (nonatomic, assign) BOOL isAudioLiving;
@property (nonatomic, assign) BOOL isVideoAudioLiving;   // 视频直播音频连麦
@end
