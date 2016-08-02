//
//  MessageTableView.h
//  MessageLivingDemo
//
//  Created by jianqiangzhang on 16/5/12.
//  Copyright © 2016年 jianqiangzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageCell.h"
#import "MessageModel.h"

@interface MessageNodeView:UIView
@property (nonatomic, strong) UIView *messageView;
@property (nonatomic, strong) UILabel*nodeLabel;
@property (nonatomic, strong) UIImageView *nodeImageView;
@property (nonatomic, copy) void(^TapBlock)(void);
- (void)show:(BOOL)isShow;
- (void)showNum:(int)num;

@end


@interface MessageTableView : UITableView<UITableViewDataSource,UITableViewDelegate,TYAttributedLabelDelegate>

@property (nonatomic,strong)NSMutableArray *data;

@property (nonatomic,strong)NSMutableArray *dataCache;

@property (nonatomic,strong)NSArray *giftInfo;

@property (nonatomic,assign)BOOL isNeedScroll;

@property (nonatomic,assign)BOOL isRightTime;

@property (nonatomic,assign)BOOL isShowNode;

@property (nonatomic) int notLookNum;


@property (nonatomic, copy)void(^ShowNodeView)(BOOL show);

@property (nonatomic, copy)void(^ShowNodeNumber)(int num);

- (void)sendMessage:(MessageModel*)model;

- (void)scrollToEnd;


@end
