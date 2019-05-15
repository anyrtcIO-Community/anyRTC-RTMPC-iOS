//
//  ArRealMicModel.m
//  RTMPCDemo
//
//  Created by 余生丶 on 2019/4/16.
//  Copyright © 2019 anyRTC. All rights reserved.
//

#import "ArRealMicModel.h"

@implementation ArRealMicModel

- (void)setUserData:(NSString *)userData{
    if (userData.length > 0) {
        NSDictionary *dict = [ArCommon fromJsonStr:userData];
        self.userName = [dict objectForKey:@"nickName"];
    }
}

@end
