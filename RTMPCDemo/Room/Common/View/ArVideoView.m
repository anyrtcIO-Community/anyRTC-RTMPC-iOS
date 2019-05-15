//
//  ArVideoView.m
//  RTMPCDemo
//
//  Created by 余生丶 on 2019/4/16.
//  Copyright © 2019 anyRTC. All rights reserved.
//

#import "ArVideoView.h"

@interface ArVideoView()

@property (nonatomic, strong) UIButton *hangupButton;

@end

@implementation ArVideoView

- (instancetype)initWithPeerId:(NSString *)peerId pubId:(NSString *)pubId display:(BOOL)isDisplay {
    if (self = [super init]) {
        self.peerId = peerId;
        self.pubId = pubId;
        self.isDisplay = isDisplay;
        if (isDisplay) {
            //挂断按钮
            self.hangupButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.hangupButton setBackgroundImage:[UIImage imageNamed:@"img_hangup"] forState:UIControlStateNormal];
            [self.hangupButton addTarget:self action:@selector(hangUpMic) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:self.hangupButton];
            [self.hangupButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self).offset(-5);
                make.width.height.equalTo(@(35));
                make.centerX.equalTo(self);
            }];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(displayHangUpButton)];
            [self addGestureRecognizer:tap];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.hangupButton.hidden = YES;
            });
        }
    }
    return self;
}

- (void)displayHangUpButton {
    if (self.isDisplay) {
        self.hangupButton.hidden = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.hangupButton.hidden = YES;
        });
    }
}

- (void)hangUpMic {
    if (self.delegate && [self.delegate respondsToSelector:@selector(hangUpOperation:)]) {
        [self.delegate hangUpOperation:self.peerId];
    }
}

@end
