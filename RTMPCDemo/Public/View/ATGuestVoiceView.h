//
//  ATVoiceView.h
//  RTMPCDemo
//
//  Created by derek on 2017/9/25.
//  Copyright © 2017年 jh. All rights reserved.
//游客音频连麦视图

#import <UIKit/UIKit.h>
#import "FBWaterHeadView.h"

@interface ATGuestVoiceView : UIView
@property (weak, nonatomic) IBOutlet FBWaterHeadView *atHeadImageView;
@property (weak, nonatomic) IBOutlet UILabel *atNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *atHangUpButton;

typedef void(^RemoveGuestVoiceBlock)(ATGuestVoiceView *view);
// 删除动作
@property (nonatomic, copy) RemoveGuestVoiceBlock removeBlock;
// 标识Id
@property (nonatomic, strong) NSString *strPeerId;
// name
@property (nonatomic, strong) NSString *strName;
// head URL
@property (nonatomic, strong) NSString *strHeadUrl;
// 用户身份(是否是自己)
@property (nonatomic, assign) BOOL isMySelf;

- (void)showAnimation:(int)time;

@end
