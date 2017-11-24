//
//  ATChatItem.h
//  RTMPCDemo
//
//  Created by derek on 2017/9/22.
//  Copyright © 2017年 jh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATChatItem : NSObject
// 消息Id
@property (nonatomic, strong) NSString *strUserId;
// 消息昵称
@property (nonatomic, strong) NSString *strNickName;
// 消息头像
@property (nonatomic, strong) NSString *strHeadUrl;
// 消息内容
@property (nonatomic, strong) NSString *strContact;
// 是否是主播
@property (nonatomic, assign) BOOL isHost;
@end
