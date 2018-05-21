//
//  ATBarragesView.h
//  RTMPCDemo
//
//  Created by jh on 2018/4/18.
//  Copyright © 2018年 jh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATHallModel.h"

@interface ATBarragesCell : UITableViewCell

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) ATBarragesModel *barrageModel;

@end

@interface ATBarragesView : UIView

@property (nonatomic, strong) NSMutableArray *infoArr;

- (void)addMessage:(ATBarragesModel *)model;

@end
