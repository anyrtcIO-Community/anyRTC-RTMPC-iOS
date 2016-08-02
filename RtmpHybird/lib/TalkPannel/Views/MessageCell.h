//
//  MessageCell.h
//  MessageLivingDemo
//
//  Created by jianqiangzhang on 16/5/12.
//  Copyright © 2016年 jianqiangzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"
#import "TYAttributedLabel.h"

@interface MessageCell : UITableViewCell

@property (nonatomic, weak, readonly) TYAttributedLabel *label;

@property (nonatomic,strong)MessageModel *model;

@end
