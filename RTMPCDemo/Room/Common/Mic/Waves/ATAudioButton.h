//
//  ATAudioButton.h
//  RTMPCDemo
//
//  Created by jh on 2018/4/16.
//  Copyright © 2018年 jh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ATWavesView : UIView

@end

@interface ATAudioButton : UIButton

@property (nonatomic, strong) NSTimer *timer;

- (void)startAudioAnimation;

@end
