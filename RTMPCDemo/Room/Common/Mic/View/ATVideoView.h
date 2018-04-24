//
//  ATVideoView.h
//  RTMPCDemo
//
//  Created by jh on 2018/4/11.
//  Copyright © 2018年 jh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HangUpDelegate <NSObject>

//主播或自己挂断连麦
- (void)hangUpOperation:(NSString *)peerId;

@end

@interface ATVideoView : UIView

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;    //连麦昵称

@property (weak, nonatomic) IBOutlet UIButton *hangUpButton;

@property (weak, nonatomic) IBOutlet UIView *localView;   //视图渲染

@property (nonatomic, assign) CGSize videoSize;     // 视图的分辨率大小

@property (nonatomic, copy) NSString *strPeerId;    // 标识Id

@property (nonatomic, copy) NSString *strPubId;     //标识流id

@property (nonatomic, assign) BOOL isDisplay;      //挂断按钮是否显示

@property (weak, nonatomic) id <HangUpDelegate> delegate;

+ (ATVideoView *)loadVideoWithName:(NSString *)name peerId:(NSString *)peerId pubId:(NSString *)pubId size:(CGSize)videoSize display:(BOOL)isDisplay;

@end
