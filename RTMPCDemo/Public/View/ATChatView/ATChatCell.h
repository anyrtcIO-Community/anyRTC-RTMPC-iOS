//
//  ATChatCell.h
//  RTMPCDemo
//
//  Created by derek on 2017/9/22.
//  Copyright © 2017年 jh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATChatItem.h"

@interface ATChatCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *atContactLabel;
@property (nonatomic, strong) ATChatItem *messageItem;
@end
