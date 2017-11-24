//
//  ATHallViewController.h
//  RTMPDemo
//
//  Created by jh on 2017/9/14.
//  Copyright © 2017年 jh. All rights reserved.
//直播大厅列表

@interface ATHallViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *hallTableView;

//头像
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

//游客名
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

//游客信息
@property (nonatomic, strong) GuestInfo *gestInfo;



@end
