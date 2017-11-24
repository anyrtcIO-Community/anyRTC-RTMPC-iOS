//
//  ATLivingEndViewController.h
//  RTMPCDemo
//
//  Created by jh on 2017/9/25.
//  Copyright © 2017年 jh. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface ATLivingEndViewController : UIViewController

//头像
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

//用户名
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

//直播时间
@property (weak, nonatomic) IBOutlet UIButton *liveTimeButton;

//QQ群
@property (weak, nonatomic) IBOutlet UIButton *qqButton;

//回到首屏
@property (weak, nonatomic) IBOutlet UIButton *goBackButton;

//问题反馈
@property (weak, nonatomic) IBOutlet UIButton *feedbackButton;

//直播时长（s）
@property (nonatomic, assign)NSInteger livTime ;

//主播名字
@property (nonatomic, copy)NSString *userName;

@end
