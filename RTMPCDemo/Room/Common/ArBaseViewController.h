//
//  ArBaseViewController.h
//  RTMPCDemo
//
//  Created by 余生丶 on 2019/4/15.
//  Copyright © 2019 anyRTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArRealMicModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ArBaseViewController : UIViewController

@property (strong, nonatomic) UILabel *roomIdLabel;
@property (strong, nonatomic) UILabel *onlineLabel;
@property (strong, nonatomic) UILabel *rtcLabel;
@property (strong, nonatomic) UILabel *rtmpLabel;
@property (nonatomic, strong) UITextField *messageTextField;

@property (nonatomic, strong, nullable) UIStackView *videoStackView;
@property (nonatomic, strong, nullable) UIStackView *audioStackView;
@property (strong, nonatomic) ArMessageView *messageView;
@property (nonatomic, strong) NSMutableArray *logArr;

//普通消息
- (ArMessageModel *)produceTextInfo:(NSString *)name content:(NSString *)content userId:(NSString *)userid audio:(BOOL)isAudio;
//连麦模型
- (ArRealMicModel *)produceRealModel:(NSString *)peerId userId:(NSString *)userId userData:(NSString *)userData;
//显示日志
- (void)openLogView;

@end

NS_ASSUME_NONNULL_END
