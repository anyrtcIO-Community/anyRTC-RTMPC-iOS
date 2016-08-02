//
//  UIColor+Category.h
//  Dropeva
//
//  Created by zjq on 15/11/6.
//  Copyright © 2015年 zjq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Category)
//0x2d3f4a
+ (UIColor *)colorWithHex:(long)hexColor;
+ (UIColor *)colorWithHex:(long)hexColor opacity:(float)opacity;
//@"ffffff" or @"#ffffff"
+ (UIColor *)colorWithHexString:(NSString *)str;
+ (UIColor *)colorWithHexString:(NSString *)str opacity:(float)opacity;
@end
