//
//  ArRealMicModel.h
//  RTMPCDemo
//
//  Created by 余生丶 on 2019/4/16.
//  Copyright © 2019 anyRTC. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ArRealMicModel : NSObject

@property (nonatomic, strong) NSString *peerId;  //标识

@property (nonatomic, strong) NSString *userId;

@property (nonatomic, strong) NSString *userData;//自定义消息

@property (nonatomic, strong) NSString *userName;//昵称

@end

NS_ASSUME_NONNULL_END
