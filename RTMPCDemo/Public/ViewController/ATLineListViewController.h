//
//  ATLineListViewController.h
//  RTMPCDemo
//
//  Created by derek on 2017/9/23.
//  Copyright © 2017年 jh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ATLineListViewController : UIViewController

// 设置数据
- (void)setLineData:(NSMutableArray*)array;

typedef void (^AgainOrHundleUpBlock)(NSString *strPeerId, BOOL isAgain);

@property (nonatomic, copy) AgainOrHundleUpBlock requestBlock;

typedef void (^DisMissBlock)(void);

@property (nonatomic, copy) DisMissBlock dismissBlock;

@end
