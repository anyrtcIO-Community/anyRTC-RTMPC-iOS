//
//  ATHosterViewController.h
//  RTMPDemo
//
//  Created by jh on 2017/9/14.
//  Copyright © 2017年 jh. All rights reserved.
//主播端视频

#import <UIKit/UIKit.h>

@interface ATHosterViewController : UIViewController

@property(nonatomic ,strong) RTMPCHosterKit *mHosterKit;

//推流地址
@property (nonatomic, copy) NSString *rtmpUrl;

//拉流地址（录像地址）
@property (nonatomic, copy) NSString *rtmpPullUrl;

//hls地址
@property (nonatomic, copy) NSString *hlsUrl;

//显示主播画面
@property (strong, nonatomic) UIView *hostView;

//当前连麦者
@property (nonatomic, strong) NSMutableArray *videoArr;

@property (nonatomic, strong) LiveInfo *liveInfo;

@property (nonatomic, strong) ATListViewController  *listVc;

@end
