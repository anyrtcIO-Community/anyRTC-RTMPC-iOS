//
//  UIImage+Extension.h
//  RTMPCDemo
//
//  Created by derek on 2017/9/25.
//  Copyright © 2017年 jh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)
/**
 *  返回原型图片
 */
- (instancetype)circleImage;

/**
 *  返回原型图片
 */
+ (instancetype)circleImage:(NSString *)image;

+ (instancetype)circleImageWithImage:(UIImage *)image;

@end
