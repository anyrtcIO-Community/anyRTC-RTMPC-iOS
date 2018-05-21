//
//  ATLivingEndController.h
//  RTMPCDemo
//
//  Created by jh on 2018/4/16.
//  Copyright © 2018年 jh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ATLivingEndController : UIViewController

//头像
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (weak, nonatomic) IBOutlet UIView *containerView;
//用户名
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

//直播时间
@property (weak, nonatomic) IBOutlet UIButton *liveTimeButton;

//直播时长（s）
@property (nonatomic, assign)NSInteger livTime ;

//主播名字
@property (nonatomic, copy)NSString *userName;

@end
