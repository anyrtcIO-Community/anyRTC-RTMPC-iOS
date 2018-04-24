//
//  ATListModel.h
//  RTMPCDemo
//
//  Created by jh on 2017/9/29.
//  Copyright © 2017年 jh. All rights reserved.
//实时在线人员model

#import <Foundation/Foundation.h>

@class UserData;

@interface ATListModel : NSObject


@property (nonatomic, assign) NSInteger Total;

@property (nonatomic, copy) NSString *CMD;

@property (nonatomic, strong) NSArray<NSString *> *UserId;

@property (nonatomic, assign) NSInteger MemSize;

@property (nonatomic, strong) NSArray<UserData *> *UserData;

@property (nonatomic, strong) NSArray<NSString *> *NickName;


@end

@interface UserData : NSObject  //实时在线人员列表

@property (nonatomic ,copy)NSString *headUrl;

@property (nonatomic ,copy)NSString *nickName;

@property (nonatomic ,copy)NSString *userId;

@property (nonatomic ,copy)NSString *isHost;

@end
