//
//  XHToast.h

//  Copyright (c) 2016 XHToast ( https://github.com/CoderZhuXH/XHToast )

//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

/**
 版本: 1.4.0
 发布: 2017.09.22
 */
#pragma mark - 1.在window上显示
@interface XHToast : NSObject

#pragma mark-中间显示
/**
*  中间显示
*
*  @param text 内容
*/
+ (void)showCenterWithText:(NSString *)text;
/**
 *  中间显示+自定义停留时间
 *
 *  @param text     内容
 *  @param duration 停留时间
 */
+ (void)showCenterWithText:(NSString *)text duration:(CGFloat)duration;

#pragma mark-上方显示
/**
 *  上方显示
 *
 *  @param text 内容
 */
+ (void)showTopWithText:(NSString *)text;
/**
 *  上方显示+自定义停留时间
 *
 *  @param text     内容
 *  @param duration 停留时间
 */
+ (void)showTopWithText:(NSString *)text duration:(CGFloat)duration;
/**
 *  上方显示+自定义距顶端距离
 *
 *  @param text      内容
 *  @param topOffset 到顶端距离
 */
+ (void)showTopWithText:(NSString *)text topOffset:(CGFloat)topOffset;
/**
 *  上方显示+自定义距顶端距离+自定义停留时间
 *
 *  @param text      内容
 *  @param topOffset 到顶端距离
 *  @param duration  停留时间
 */
+ (void)showTopWithText:(NSString *)text topOffset:(CGFloat)topOffset duration:(CGFloat)duration;

#pragma mark-下方显示
/**
 *  下方显示
 *
 *  @param text 内容
 */
+ (void)showBottomWithText:(NSString *)text;
/**
 *  下方显示+自定义停留时间
 *
 *  @param text     内容
 *  @param duration 停留时间
 */
+ (void)showBottomWithText:(NSString *)text duration:(CGFloat)duration;
/**
 *  下方显示+自定义距底端距离
 *
 *  @param text         内容
 *  @param bottomOffset 距底端距离
 */
+ (void)showBottomWithText:(NSString *)text bottomOffset:(CGFloat)bottomOffset;
/**
 *  下方显示+自定义距底端距离+自定义停留时间
 *
 *  @param text         内容
 *  @param bottomOffset 距底端距离
 *  @param duration     停留时间
 */
+ (void)showBottomWithText:(NSString *)text bottomOffset:(CGFloat)bottomOffset duration:(CGFloat)duration;

@end

#pragma mark - 2.在view上显示
@interface UIView (XHToast)

#pragma mark-中间显示
/**
 *  中间显示
 *
 *  @param text 内容
 */
- (void)showXHToastCenterWithText:(NSString *)text;
/**
 *  中间显示+自定义停留时间
 *
 *  @param text     内容
 *  @param duration 停留时间
 */
- (void)showXHToastCenterWithText:(NSString *)text duration:(CGFloat)duration;

#pragma mark-上方显示
/**
 *  上方显示
 *
 *  @param text 内容
 */
- (void)showXHToastTopWithText:(NSString *)text;
/**
 *  上方显示+自定义停留时间
 *
 *  @param text     内容
 *  @param duration 停留时间
 */
- (void)showXHToastTopWithText:(NSString *)text duration:(CGFloat)duration;
/**
 *  上方显示+自定义距顶端距离
 *
 *  @param text      内容
 *  @param topOffset 到顶端距离
 */
- (void)showXHToastTopWithText:(NSString *)text topOffset:(CGFloat)topOffset;
/**
 *  上方显示+自定义距顶端距离+自定义停留时间
 *
 *  @param text      内容
 *  @param topOffset 到顶端距离
 *  @param duration  停留时间
 */
- (void)showXHToastTopWithText:(NSString *)text topOffset:(CGFloat)topOffset duration:(CGFloat)duration;

#pragma mark-下方显示
/**
 *  下方显示
 *
 *  @param text 内容
 */
- (void)showXHToastBottomWithText:(NSString *)text;
/**
 *  下方显示+自定义停留时间
 *
 *  @param text     内容
 *  @param duration 停留时间
 */
- (void)showXHToastBottomWithText:(NSString *)text duration:(CGFloat)duration;
/**
 *  下方显示+自定义距底端距离
 *
 *  @param text         内容
 *  @param bottomOffset 距底端距离
 */
- (void)showXHToastBottomWithText:(NSString *)text bottomOffset:(CGFloat)bottomOffset;
/**
 *  下方显示+自定义距底端距离+自定义停留时间
 *
 *  @param text         内容
 *  @param bottomOffset 距底端距离
 *  @param duration     停留时间
 */
- (void)showXHToastBottomWithText:(NSString *)text bottomOffset:(CGFloat)bottomOffset duration:(CGFloat)duration;

@end
