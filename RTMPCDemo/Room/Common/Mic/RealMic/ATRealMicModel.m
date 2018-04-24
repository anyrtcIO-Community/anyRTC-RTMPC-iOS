//
//  ATRealMicModel.m
//  RTMPCDemo
//
//  Created by jh on 2018/4/12.
//  Copyright © 2018年 jh. All rights reserved.
//

#import "ATRealMicModel.h"

@implementation ATRealMicModel

- (void)setUserData:(NSString *)userData{
    if (userData.length > 0) {
        NSDictionary *dict = [ATCommon fromJsonStr:userData];
        self.userName = [dict objectForKey:@"nickName"];
    }
}

@end
