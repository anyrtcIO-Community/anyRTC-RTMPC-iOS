//
//  ATHallCell.h
//  RTMPCDemo
//
//  Created by jh on 2017/9/23.
//  Copyright © 2017年 jh. All rights reserved.
//直播大厅cell

#import <UIKit/UIKit.h>

@interface ATHallCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *audioImageView;

//房间名
@property (weak, nonatomic) IBOutlet UILabel *topicLabel;

//主播昵称
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

//房间id
@property (weak, nonatomic) IBOutlet UILabel *roomIdLabel;

//在线人数
@property (weak, nonatomic) IBOutlet UILabel *onlineLabel;

- (void)updateCell:(LiveList *)listModel withOnLine:(NSString *)online;

@end
