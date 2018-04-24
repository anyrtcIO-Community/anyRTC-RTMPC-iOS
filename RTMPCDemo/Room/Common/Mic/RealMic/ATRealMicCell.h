//
//  ATRealMicCell.h
//  RTMPCDemo
//
//  Created by jh on 2018/4/12.
//  Copyright © 2018年 jh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATRealMicModel.h"

@protocol MicResultDelegate <NSObject>

- (void)micResult:(NSString *)peerId agree:(BOOL)isAgree;

@end


@interface ATRealMicCell : UITableViewCell

@property (nonatomic, strong) ATRealMicModel *realMicModel;

@property (weak, nonatomic) id <MicResultDelegate> delegate;

@end
