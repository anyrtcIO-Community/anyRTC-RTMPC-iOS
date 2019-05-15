//
//  ArRealTimeMicController.h
//  RTMPCDemo
//
//  Created by 余生丶 on 2019/4/16.
//  Copyright © 2019 anyRTC. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ArRealTimeMicController : UIViewController

@property (nonatomic, strong) NSMutableArray *micArr;
@property (nonatomic, strong) ARRtmpHosterKit *hosterKit;

@end

NS_ASSUME_NONNULL_END
