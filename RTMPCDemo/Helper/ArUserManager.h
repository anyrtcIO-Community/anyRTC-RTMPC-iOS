//
//  ArUserManager.h
//  RTMPCDemo
//
//  Created by 余生丶 on 2019/4/12.
//  Copyright © 2019 anyRTC. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface ArUserInfo : NSObject<NSCoding>

@property (nonatomic, copy) NSString *nickname; //昵称
@property (nonatomic, copy) NSString *userid;   //用户id
@property (nonatomic, copy) NSString *avatar;   //用户头像

- (instancetype)initWithName:(NSString *)nickname userId:(NSString *)userId avatar:(NSString *)avatar;

@end

@interface ArUserManager : NSObject

+ (ArUserInfo *)getUserInfo;

@end

NS_ASSUME_NONNULL_END
