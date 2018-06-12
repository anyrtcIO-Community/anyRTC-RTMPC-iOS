//
//  NetWorkTools.h
//  MeditationVideo
//
//  Created by 1 on 2017/2/20.
//  Copyright © 2017年 jh. All rights reserved.
//网络请求

#import <Foundation/Foundation.h>

#define App_VdnUrl @"http://vdn.anyrtc.cc/oauth/anyapi/v1/vdnUrlSign/getAppVdnUrl"

@interface NetWorkTools : NSObject

+ (instancetype)shareInstance;

//Post请求
- (void)postWithURLString:(NSString *)URLString
               parameters:(id)parameters
                  success:(void (^)(NSDictionary * dictionary))success
                  failure:(void (^)(NSError * error))failure;

// 取消请求
- (void)cancelAllRequest;

@end
