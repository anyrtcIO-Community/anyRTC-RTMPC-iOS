//
//  ArMainViewController.h
//  RTMPCDemo
//
//  Created by 余生丶 on 2019/4/10.
//  Copyright © 2019 anyRTC. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ArMainCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *topicLabel;
@property (weak, nonatomic) IBOutlet UIButton *typeButton;
@property (weak, nonatomic) IBOutlet UIButton *onlineButton;

- (void)updateCell:(ArMainModel *)hallModel withOnLine:(NSString *)online;

@end


@interface ArMainViewController : UIViewController

@end

NS_ASSUME_NONNULL_END
