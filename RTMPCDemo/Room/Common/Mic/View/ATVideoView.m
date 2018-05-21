//
//  ATVideoView.m
//  RTMPCDemo
//
//  Created by jh on 2018/4/11.
//  Copyright © 2018年 jh. All rights reserved.
//

#import "ATVideoView.h"

@implementation ATVideoView

+ (ATVideoView *)loadVideoWithName:(NSString *)name peerId:(NSString *)peerId pubId:(NSString *)pubId size:(CGSize)videoSize display:(BOOL)isDisplay{
    ATVideoView *videoView = [[[NSBundle mainBundle]loadNibNamed:@"ATVideoView" owner:self options:nil]lastObject];
    videoView.nameLabel.text = name;
    videoView.strPubId = pubId;
    videoView.strPeerId = peerId;
    videoView.videoSize = videoSize;
    videoView.isDisplay = isDisplay;
    return videoView;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    //默认不显示
    self.isDisplay ? (self.hangUpButton.hidden = NO) : (self.hangUpButton.hidden = YES);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.hangUpButton.hidden = YES;
    });
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(displayHangUpButton)];
    [self addGestureRecognizer:tap];
}

- (void)displayHangUpButton {
    if (self.isDisplay) {
        self.hangUpButton.hidden = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.hangUpButton.hidden = YES;
        });
    }
}

//挂断连麦
- (IBAction)hangUpMic:(id)sender {
    if ([self.delegate respondsToSelector:@selector(hangUpOperation:)]) {
        [self.delegate hangUpOperation:self.strPeerId];
    }
}

@end
