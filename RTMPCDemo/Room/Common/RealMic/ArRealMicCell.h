//
//  ArRealMicCell.h
//  RTMPCDemo
//
//  Created by 余生丶 on 2019/4/17.
//  Copyright © 2019 anyRTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArRealMicModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MicResultDelegate <NSObject>

- (void)micResult:(NSString *)peerId agree:(BOOL)isAgree;

@end

@interface ArRealMicCell : UITableViewCell

@property (nonatomic, strong) ArRealMicModel *realMicModel;

@property (weak, nonatomic) id <MicResultDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
