//
//  ATAudioView.m
//  RTMPCDemo
//
//  Created by jh on 2018/4/11.
//  Copyright © 2018年 jh. All rights reserved.
//

#import "ATAudioView.h"

@implementation ATAudioView

+ (ATAudioView *)loadAudioWithName:(NSString *)name peerId:(NSString *)peerId display:(BOOL)isDisplay{
    ATAudioView *audioView = [[[NSBundle mainBundle]loadNibNamed:@"ATAudioView" owner:self options:nil]lastObject];
    audioView.nameLabel.text = name;
    audioView.peerId = peerId;
    isDisplay ? (audioView.hangUpButton.hidden = NO) : (audioView.hangUpButton.hidden = YES);
    return audioView;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.isDisplay ? (self.hangUpButton.hidden = NO) : (self.hangUpButton.hidden = YES);
}

- (IBAction)hangUpMic:(id)sender {
    if ([self.delegate respondsToSelector:@selector(hangUpOperation:)]) {
        [self.delegate hangUpOperation:self.peerId];
    }
}

@end
