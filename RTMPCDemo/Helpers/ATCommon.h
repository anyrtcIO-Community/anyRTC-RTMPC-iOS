//
//  ATCommon.h
//  RTMPCDemo
//
//  Created by jh on 2017/9/20.
//  Copyright © 2017年 jh. All rights reserved.
//公共类

#import <Foundation/Foundation.h>

@interface ATCommon : NSObject

//将字典转换为JSON对象
+ (NSString *)fromDicToJSONStr:(NSDictionary *)dic;

// 将字符串转换为字典
+ (id)fromJsonStr:(NSString*)jsonStrong;

//随机字符串
+ (NSString*)randomString:(int)len;

// 随机anyrtc
+ (NSString*)randomAnyRTCString:(int)len;

// 将16进制颜色转换成UIColor
+(UIColor *)getColor:(NSString *)color;

//随机生成汉字
+ (NSMutableString*)randomCreatChinese:(NSInteger)count;

//隐藏界面上所有键盘
+ (void)hideKeyBoard;

//返回一张未被渲染图片
+ (UIImage *)applyColoursDrawing:(UIImage *)image;

// 拨打电话
+ (void)callPhone:(NSString *)phoneNum control:(UIButton *)sender;

//富文本(图片+文字)
+ (NSMutableAttributedString *)getAttributedString:(NSString *)textStr imageSize:(CGRect)imageSize image:(UIImage *)image index:(NSInteger)index;

//传入 秒  得到  xx分钟xx秒
+ (NSString *)getMMSSFromSS:(NSString *)totalTime;

//字符串包含
+ (BOOL)isStringContains:(NSString *)str string:(NSString *)smallStr;

@end
