//
//  AudioShowView.h
//  RTMPCDemo
//
//  Created by jianqiangzhang on 2016/11/23.
//  Copyright © 2016年 EricTao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AudioShowView : UIView

@property (nonatomic, strong) NSString *userID;

- (void)show;

- (void)headUrl:(NSString*)url withName:(NSString*)name withID:(NSString*)peerID;

@end
