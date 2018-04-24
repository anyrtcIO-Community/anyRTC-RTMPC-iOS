//
//  ATRealTimeMicController.h
//  RTMPCDemo
//
//  Created by jh on 2018/4/12.
//  Copyright © 2018年 jh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ATRealTimeMicController : UIViewController

@property (nonatomic, strong) NSMutableArray *micArr;

@property (nonatomic, strong) RTMPCHosterKit *mHosterKit;

@property (nonatomic, strong) RTMPCHosterAudioKit *mHosterAudioKit;

@end
