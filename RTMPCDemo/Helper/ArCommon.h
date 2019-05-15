//
//  ArCommon.h
//  RTMPCDemo
//
//  Created by 余生丶 on 2019/4/11.
//  Copyright © 2019 anyRTC. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ArCommon : NSObject

//将字典转换为JSON对象
+ (NSString *)fromDicToJSONStr:(NSDictionary *)dic;

// 将字符串转换为字典
+ (id)fromJsonStr:(NSString*)jsonStrong;

//随机字符串
+ (NSString*)randomString:(int)len;

// 随机anyrtc
+ (NSString*)randomAnyRTCString:(int)len;

//md5加密
+ (NSString *)md5OfString:(NSString *)aOriginal;

// 将16进制颜色转换成UIColor
+ (UIColor *)getColor:(NSString *)color;

// 提示信息
+ (void)showAlertsStatus:(NSString *)infoTxt;

@end

NS_ASSUME_NONNULL_END
