//
//  UIColor+Category.m
//  Dropeva
//
//  Created by zjq on 15/11/6.
//  Copyright © 2015年 zjq. All rights reserved.
//

#import "UIColor+Category.h"

@implementation UIColor (Category)
+ (UIColor *)colorWithHex:(long)hexColor {
    return [UIColor colorWithHex:hexColor opacity:1.];
}

+ (UIColor *)colorWithHex:(long)hexColor opacity:(float)opacity {
    float red = ((float)((hexColor & 0xFF0000) >> 16))/255.0;
    float green = ((float)((hexColor & 0xFF00) >> 8))/255.0;
    float blue = ((float)(hexColor & 0xFF))/255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:opacity];
}

+ (UIColor *)colorWithHexString:(NSString *)str opacity:(float)opacity {
    if (str.length < 6) {
        return nil;
    }
    NSInteger delta = 0;
    if ([str hasPrefix:@"#"]) {
        delta = 1;
    }
    unsigned red,green,blue;
    NSRange range;
    range.length = 2;
    range.location = 0 + delta;
    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&red];
    range.location = 2 + delta;
    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&green];
    range.location = 4 + delta;
    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&blue];
    UIColor *color= [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:opacity];
    return color;
}

+ (UIColor *)colorWithHexString:(NSString *)str
{
    return[UIColor colorWithHexString:str opacity:1.];
}

@end
