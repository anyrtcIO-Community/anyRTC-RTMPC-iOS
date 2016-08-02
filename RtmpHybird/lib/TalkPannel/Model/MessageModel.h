//
//  MessageModel.h
//  MessageLivingDemo
//
//  Created by jianqiangzhang on 16/5/12.
//  Copyright © 2016年 jianqiangzhang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,CellType){
    CellBanType,                  // 禁号
    CellNewChatMessageType,       // 新消息
    CellNewGiftType,              // 礼品
    CellNewUserEnterType,         // 消息进入
    CellDeserveType,              // 
};

@class TYTextContainer;

@interface MessageModel : NSObject

@property (nonatomic,strong)TYTextContainer *textContainer;
@property (nonatomic,copy)NSString *unColoredMsg;
@property (nonatomic,assign)CellType cellType;
@property (nonatomic,strong)NSArray *gift;
@property (nonatomic,copy)NSString *dataString;

- (void)setModelFromStirng:(NSString *)string;

- (void)setModel:(NSString*)userID withName:(NSString*)name withIcon:(NSString*)icon withType:(CellType)type withMessage:(NSString*)message;
@end
