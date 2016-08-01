//
//  HostSettingViewController.h
//  RTMPCDemo
//
//  Created by jianqiangzhang on 16/7/27.
//  Copyright © 2016年 EricTao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextFieldEnterView:UIView
typedef void(^TapEventBlock)();
@property (nonatomic, copy)void(^TapEventBlock)(NSString *hostName);
@end

@interface HostSettingViewController : UIViewController

@end
