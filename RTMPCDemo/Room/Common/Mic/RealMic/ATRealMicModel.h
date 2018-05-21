//
//  ATRealMicModel.h
//  RTMPCDemo
//
//  Created by jh on 2018/4/12.
//  Copyright © 2018年 jh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATRealMicModel : NSObject

@property (nonatomic, strong) NSString *peerId;  //标识

@property (nonatomic, strong) NSString *userId;

@property (nonatomic, strong) NSString *userData;//自定义消息

@property (nonatomic, strong) NSString *userName;//昵称

@end
