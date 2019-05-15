//
//  ArVideoView.h
//  RTMPCDemo
//
//  Created by 余生丶 on 2019/4/16.
//  Copyright © 2019 anyRTC. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HangUpDelegate <NSObject>

//主播或自己挂断连麦
- (void)hangUpOperation:(NSString *)peerId;

@end

@interface ArVideoView : UIView

@property (nonatomic, copy) NSString *peerId;
@property (nonatomic, copy) NSString *pubId;
@property (nonatomic, assign) BOOL isDisplay;

@property (weak, nonatomic) id <HangUpDelegate> delegate;

- (instancetype)initWithPeerId:(NSString *)peerId pubId:(NSString *)pubId display:(BOOL)isDisplay;


@end

NS_ASSUME_NONNULL_END
