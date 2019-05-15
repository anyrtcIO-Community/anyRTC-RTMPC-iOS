//
//  ArNetWorkTools.h
//  RTMPCDemo
//
//  Created by 余生丶 on 2019/4/11.
//  Copyright © 2019 anyRTC. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ArNetWorkTools : NSObject

+ (instancetype)shareInstance;

//Post请求
- (void)postWithURLString:(NSString *)URLString
              parameters:(id)parameters
                 success:(void (^)(NSDictionary * dictionary))success
                 failure:(void (^)(NSError * error))failure;
// 取消请求
- (void)cancelAllRequest;

@end

NS_ASSUME_NONNULL_END
