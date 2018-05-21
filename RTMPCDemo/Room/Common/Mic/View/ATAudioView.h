//
//  ATAudioView.h
//  RTMPCDemo
//
//  Created by jh on 2018/4/11.
//  Copyright © 2018年 jh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATAudioButton.h"

@interface ATAudioView : UIView

@property (weak, nonatomic) IBOutlet ATAudioButton *headButton;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//挂断
@property (weak, nonatomic) IBOutlet UIButton *hangUpButton;

@property (nonatomic, copy) NSString *peerId;
//挂断按钮是否显示
@property (nonatomic, assign) BOOL isDisplay;

@property (weak, nonatomic) id <HangUpDelegate> delegate;

+ (ATAudioView *)loadAudioWithName:(NSString *)name peerId:(NSString *)peerId display:(BOOL)isDisplay;

@end
