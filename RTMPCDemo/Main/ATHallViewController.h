//
//  ATHallViewController.h
//  RTMPCDemo
//
//  Created by jh on 2018/4/11.
//  Copyright © 2018年 jh. All rights reserved.
//

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

- (void)updateCell:(ATHallModel *)hallModel withOnLine:(NSString *)online;

@end

@interface ATHallViewController : UITableViewController

@end
