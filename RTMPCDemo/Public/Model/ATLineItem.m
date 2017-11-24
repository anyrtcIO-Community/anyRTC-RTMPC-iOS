//
//  ATLineItem.m
//  RTMPCDemo
//
//  Created by derek on 2017/9/23.
//  Copyright © 2017年 jh. All rights reserved.
//

#import "ATLineItem.h"
#import "ATCommon.h"

@implementation ATLineItem
- (void)setStrUserData:(NSString *)strUserData {
    
    if (strUserData.length > 0) {
        NSDictionary *dict = [ATCommon fromJsonStr:strUserData];
        
        self.strUserName = [dict objectForKey:@"nickName"];
    }
}
@end
