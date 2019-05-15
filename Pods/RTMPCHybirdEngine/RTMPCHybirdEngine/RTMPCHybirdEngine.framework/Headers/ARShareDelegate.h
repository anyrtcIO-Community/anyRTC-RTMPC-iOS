//
//  ARMeetShareDelegate.h
//  RTMeetEngine
//
//  Created by zjq on 2019/1/15.
//  Copyright © 2019 EricTao. All rights reserved.
//

#ifndef ARShareDelegate_h
#define ARShareDelegate_h
#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#elif TARGET_OS_MAC
#import <AppKit/AppKit.h>
#endif
@protocol ARShareDelegate <NSObject>

@optional

/**
 判断是否可以开启共享回调
 
 @param enable YES可以共享，NO不可以共享
 */
- (void)onRTCShareEnable:(BOOL)enable;

/**
 共享开启
 
 @param type 共享类型
 @param shareInfo 共享信息
 @param userId 开发者自己平台的Id
 @param userData 开发者自己平台的相关信息（昵称，头像等)
 */
- (void)onRTCShareOpen:(int)type shareInfo:(NSString *)shareInfo userId:(NSString *)userId userData:(NSString *)userData;

/**
 共享关闭
 
 说明：打开共享的人关闭了共享。
 */
- (void)onRTCShareClose;


@end

#endif /* ARShareDelegate_h */
