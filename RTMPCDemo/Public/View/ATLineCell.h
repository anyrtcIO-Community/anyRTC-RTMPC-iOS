//
//  ATLineCell.h
//  RTMPCDemo
//
//  Created by derek on 2017/9/23.
//  Copyright © 2017年 jh. All rights reserved.
//连麦cell

#import <UIKit/UIKit.h>
#import "ATLineItem.h"

@interface ATLineCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *againButton;
@property (weak, nonatomic) IBOutlet UILabel *atTitleLabel;
@property (nonatomic, strong) ATLineItem *lineItem;

typedef void(^LineRequestBlock)(ATLineItem *lineItem,BOOL isAgain);

@property (nonatomic, copy) LineRequestBlock requestBlock;

@end
