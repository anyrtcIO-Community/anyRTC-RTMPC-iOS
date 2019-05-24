//
//  ArAudioView.m
//  RTMPCDemo
//
//  Created by 余生丶 on 2019/4/17.
//  Copyright © 2019 anyRTC. All rights reserved.
//

#import "ArAudioView.h"

@interface ArAudioView()

@property (nonatomic, strong) UIButton *hangupButton;

@end

@implementation ArAudioView

- (instancetype)initWithPeerId:(NSString *)peerId name:(NSString *)name display:(BOOL)isDisplay {
    if (self = [super init]) {
        self.peerId = peerId;
        self.isDisplay = isDisplay;
        
        self.headImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guest_head"]];
        [self addSubview:self.headImageView];
        [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.centerX.equalTo(self);
            make.height.width.equalTo(@(100));
        }];
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.textColor = [UIColor lightGrayColor];
        nameLabel.font = [UIFont systemFontOfSize:12];
        nameLabel.text = name;
        [self addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headImageView.mas_bottom);
            make.centerX.equalTo(self);
            make.height.equalTo(@(20));
        }];
        
        if (isDisplay) {
            self.hangupButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.hangupButton setImage:[UIImage imageNamed:@"img_hangup"] forState:UIControlStateNormal];
            [self.hangupButton addTarget:self action:@selector(hangUpMic) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:self.hangupButton];
            [self.hangupButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(nameLabel.mas_bottom);
                make.centerX.equalTo(self.headImageView);
                make.width.height.equalTo(@(50));
            }];
        }
    }
    return self;
}

- (void)hangUpMic {
    if (self.delegate && [self.delegate respondsToSelector:@selector(hangUpOperation:)]) {
        [self.delegate hangUpOperation:self.peerId];
    }
}

@end
