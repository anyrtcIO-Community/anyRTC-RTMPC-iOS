//
//  ArUserManager.m
//  RTMPCDemo
//
//  Created by 余生丶 on 2019/4/12.
//  Copyright © 2019 anyRTC. All rights reserved.
//

#import "ArUserManager.h"

#define Ar_Userinfo @"Ar_Userinfo"

@implementation ArUserInfo

MJCodingImplementation

- (instancetype)initWithName:(NSString *)nickname userId:(NSString *)userId avatar:(NSString *)avatar {
    if (self = [super init]) {
        self.nickname = nickname;
        self.userid = userId;
        self.avatar = avatar;
    }
    return self;
}
@end

@implementation ArUserManager

+ (void)saveUserInfo:(ArUserInfo *)info {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:Ar_Userinfo];
    [NSKeyedArchiver archiveRootObject:info toFile:filePath];
}

+ (ArUserInfo *)getUserInfo {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:Ar_Userinfo];
    if (![NSFileManager.defaultManager fileExistsAtPath:filePath]) {
        ArUserInfo *userInfo = [[ArUserInfo alloc] initWithName:[NSString stringWithFormat:@"体验账号%@",[ArCommon randomAnyRTCString:4]] userId:[ArCommon randomString:6] avatar:@""];
        [self saveUserInfo:userInfo];
    }
    return  [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
}

@end
