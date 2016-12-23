//
//  PersonItem.h
//  RTMPCDemo
//
//  Created by jianqiangzhang on 2016/12/19.
//  Copyright © 2016年 EricTao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonItem : NSObject

@property (nonatomic, strong) NSString *headURl;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, assign) BOOL isSpeak;  // 是否正在说话
@end
