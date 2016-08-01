//
//  NetUtils.h
//  RtmpHybird
//
//  Created by jianqiangzhang on 16/7/27.
//  Copyright © 2016年 jianqiangzhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewController.h"
#import "AppDelegate.h"


@interface NetUtils : NSObject

+ (NetUtils*)shead;
typedef void (^GetLivingListsBlock)(NSArray *array,NSError*error,int code);

- (void)getLivingList:(GetLivingListsBlock)resultBlock;

@end
