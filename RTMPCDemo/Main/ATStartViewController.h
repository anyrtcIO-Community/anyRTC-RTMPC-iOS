//
//  ATStartViewController.h
//  RTMPCDemo
//
//  Created by jh on 2017/9/22.
//  Copyright © 2017年 jh. All rights reserved.
//创建直播

#import <UIKit/UIKit.h>

@interface ATStartViewController : UIViewController

//头像
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
//随机姓名
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//直播名
@property (weak, nonatomic) IBOutlet UITextField *topicTextField;
//返回
@property (weak, nonatomic) IBOutlet UIButton *goBackButton;
//直播类型（音频、视频）
@property (weak, nonatomic) IBOutlet UIButton *typeButton;
//直播质量
@property (weak, nonatomic) IBOutlet UIButton *modeButton;
//直播方向（横屏、竖屏）
@property (weak, nonatomic) IBOutlet UIButton *directionButton;

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomY;

//标识被选中的 100 直播类型 101直播质量  102直播方向
@property (nonatomic, assign)NSInteger index;

@property (nonatomic, strong)LiveInfo *liveInfo;

@end
