//
//  ATHostVoiceView.h
//  RTMPCDemo
//
//  Created by derek on 2017/9/25.
//  Copyright © 2017年 jh. All rights reserved.
//主播音频连麦视图

#import <UIKit/UIKit.h>
#import "FBWaterHeadView.h"

@interface ATHostVoiceView : UIView

@property (weak, nonatomic) IBOutlet FBWaterHeadView *atHeadImageView;
@property (weak, nonatomic) IBOutlet UILabel *atNameLabel;

typedef void(^RemoveHostVoiceBlock)(ATHostVoiceView *view);
// 删除动作
@property (nonatomic, copy) RemoveHostVoiceBlock removeBlock;
// 标识Id
@property (nonatomic, strong) NSString *strPeerId;
// name
@property (nonatomic, strong) NSString *strName;
// head URL
@property (nonatomic, strong) NSString *strHeadUrl;

- (void)showAnimation:(int)time;

@end
