//
//  UIImage+Extension.m
//  RTMPCDemo
//
//  Created by derek on 2017/9/25.
//  Copyright © 2017年 jh. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)
- (instancetype)circleImage
{
    UIGraphicsBeginImageContext(self.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextAddEllipseInRect(ctx, rect);
    CGContextClip(ctx);
    [self drawInRect:rect];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (instancetype)circleImage:(NSString *)image
{
    return [[self imageNamed:image] circleImage];
}
+ (instancetype)circleImageWithImage:(UIImage *)image {
    UIImage *original = image;
    CGRect frame = CGRectMake(0, 0, original.size.width, original.size.height);
    // 开始一个Image的上下文
    UIGraphicsBeginImageContextWithOptions(original.size, NO, 1.0);
    // 添加圆角
    [[UIBezierPath bezierPathWithRoundedRect:frame
                                cornerRadius:frame.size.height/2] addClip];
    // 绘制图片
    [original drawInRect:frame];
    // 接受绘制成功的图片
    UIImage *images = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return images;
}
@end
