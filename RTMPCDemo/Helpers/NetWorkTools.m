//
//  NetWorkTools.m
//  MeditationVideo
//
//  Created by 1 on 2017/2/20.
//  Copyright © 2017年 jh. All rights reserved.
//

#import "NetWorkTools.h"

#define TIMEOUT 5.0f

@implementation NetWorkTools

+ (instancetype)shareInstance{
    static dispatch_once_t onceToken;
    static NetWorkTools *tools = nil;
    dispatch_once(&onceToken, ^{
        tools = [[NetWorkTools alloc]init];
        [self toMonitoringNetwork];
    });
    return tools;
}

+ (void)toMonitoringNetwork{//监测网络
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
            {
                //未知网络
            }
                break;
            case AFNetworkReachabilityStatusNotReachable:
            {
                // 没有网
                [[NetWorkTools shareInstance] cancelAllRequest];
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
                // 手机网络(当前使用的是2G/3G/4G网络)
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                // WIFI(当前在WIFI网络下)
            }
        }
    }];
}

static AFHTTPSessionManager *manager = NULL;
-(AFHTTPSessionManager *)baseHtppRequest{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //设置网络请求为忽略本地缓存  直接请求服务器
    manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    [manager.requestSerializer setTimeoutInterval:TIMEOUT];
    manager.operationQueue.maxConcurrentOperationCount = 5;
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
   // manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/json", @"text/html", @"application/json", nil];
    return manager;
}

- (void)postWithURLString:(NSString *)URLString
               parameters:(id)parameters
                  success:(void (^)(NSDictionary * dictionary))success
                  failure:(void (^)(NSError *error))failure{
    
    AFHTTPSessionManager *manager = [self baseHtppRequest];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.securityPolicy.validatesDomainName = NO;
    
    [manager POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if (success) {
            success(responseDic);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

// 取消所有的请求
- (void)cancelAllRequest {
    AFHTTPSessionManager *manager = [self baseHtppRequest];
    [manager.operationQueue cancelAllOperations];
}

@end
