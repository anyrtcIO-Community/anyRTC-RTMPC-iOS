//
//  AnyRTCWriteBlockDelegate.h
//  RTMeetEngine
//
//  Created by derek on 2017/10/19.
//  Copyright © 2017年 EricTao. All rights reserved.
//

#ifndef AnyRTCWriteBlockDelegate_h
#define AnyRTCWriteBlockDelegate_h
#import <UIKit/UIKit.h>

@protocol AnyRTCUserShareBlockDelegate <NSObject>

/**
 判断是否可以开启共享
 */
- (void)onRTCCanUseShareEnableResult:(BOOL)scuess;

/**
 共享开启
 
 @param nType 分享类型
 @param strUserShareInfo 共享信息
 @param strUserId 与开发者自己平台的Id
 @param strUserData 开发者自己平台的相关信息（昵称，头像等)；
 说明：别人打开的共享
 */
- (void)onRTCUserShareOpen:(int)nType withShareInfo:(NSString*)strUserShareInfo withUserId:(NSString *)strUserId withUserData:(NSString*)strUserData;

/**
 共享关闭
 说明：打开共享的人关闭了共享
 */
- (void)OnRTCUserShareClose;
@end
#endif /* AnyRTCWriteBlockDelegate_h */
