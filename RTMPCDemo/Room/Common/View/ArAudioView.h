//
//  ArAudioView.h
//  RTMPCDemo
//
//  Created by 余生丶 on 2019/4/17.
//  Copyright © 2019 anyRTC. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ArAudioView : UIView

@property (nonatomic, strong) UIImageView *headImageView;

@property (nonatomic, copy) NSString *peerId;
//挂断按钮是否显示
@property (nonatomic, assign) BOOL isDisplay;

@property (weak, nonatomic) id <HangUpDelegate> delegate;

- (instancetype)initWithPeerId:(NSString *)peerId name:(NSString *)name display:(BOOL)isDisplay;

@end

NS_ASSUME_NONNULL_END
