//
//  ATLineItem.h
//  RTMPCDemo
//
//  Created by derek on 2017/9/23.
//  Copyright © 2017年 jh. All rights reserved.
//连麦modle

#import <Foundation/Foundation.h>

@interface ATLineItem : NSObject
// 用户请求Id
@property (nonatomic, strong) NSString *strPeerId;
// 用户Id
@property (nonatomic, strong) NSString *strUserId;
// 用户的自定义信息
@property (nonatomic, strong) NSString *strUserData;
// 用来解析名字
@property (nonatomic, strong) NSString *strUserName;

@end
