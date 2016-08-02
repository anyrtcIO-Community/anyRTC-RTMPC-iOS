//
//  MessageTableView.m
//  MessageLivingDemo
//
//  Created by jianqiangzhang on 16/5/12.
//  Copyright © 2016年 jianqiangzhang. All rights reserved.
//

#import "MessageTableView.h"
#import "Masonry.h"

@implementation MessageNodeView
- (id)init {
    self = [super init];
    if (self) {
        [self layoutView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEvent:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}
- (void)tapEvent:(UITapGestureRecognizer *)sender {
    if (self.TapBlock) {
        self.TapBlock();
    }
}

- (void) layoutView {
    self.messageView = [[UIView alloc] init];
    self.messageView.backgroundColor = [UIColor yellowColor];
    [self addSubview:self.messageView];
    
    // MESSAGE
    self.nodeLabel = [[UILabel alloc] init];
    self.nodeLabel.font = [UIFont systemFontOfSize:12];
    self.nodeLabel.text = @"100条新消息";
    [self addSubview:self.nodeLabel];
    
    // IMAGE NODE
    self.nodeImageView = [[UIImageView alloc] init];
    self.nodeImageView.hidden = YES;
    self.nodeImageView.backgroundColor = [UIColor blueColor];
    [self addSubview:self.nodeImageView];
    
    [self.nodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(5);
        make.top.equalTo(self.mas_top).offset(5);
        make.bottom.equalTo(self.mas_bottom).offset(-5);
        make.right.equalTo(self.nodeImageView.mas_left).offset(-5);
    }];
    
    [self.nodeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [self.messageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(0);
        make.top.equalTo(self.mas_top).offset(2);
        make.bottom.equalTo(self.mas_bottom).offset(-2);
        make.right.equalTo(self.nodeImageView.mas_right).offset(5);
    }];
}
- (void)show:(BOOL)animation
{
    if (animation) {
        self.nodeImageView.hidden = NO;
    }else{
        self.nodeImageView.hidden = YES;
    }
}
- (void)showNum:(int)num {
    @autoreleasepool {
        NSString *message = [NSString stringWithFormat:@"%d条新弹幕",num];
        self.nodeLabel.text = message;
    }
}
@end

@implementation MessageTableView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.notLookNum = 0;
        
        self.data = @[].mutableCopy;
        self.dataCache = @[].mutableCopy;
        //绑定代理
        self.delegate = self;
        self.dataSource = self;
        //取消下划线
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        //设置背景色
        self.backgroundColor = [UIColor clearColor];//[UIColor colorWithRed:236/255.0 green:237/255.0 blue:241/255.0 alpha:1];
        //注册Cell
        [self registerClass:[MessageCell class] forCellReuseIdentifier:@"MessageCell"];
        self.isNeedScroll = YES;
        if ([self respondsToSelector:@selector(setEstimatedRowHeight:)]) {
            self.estimatedRowHeight = 40;
        }
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timeToReloadData) userInfo:nil repeats:YES];
        [timer fire];
        //监听通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:@"kReceiveMessageNotification" object:nil];
    
    }
    return self;
}
- (void)scrollToEnd {
    if (self.isShowNode) {
        self.ShowNodeView(NO);
    }
    self.notLookNum = 0;
    //将最后一个单元格滚动到表视图的底部显示
    [self reloadData];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.data.count-1 inSection:0];
    [self scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    self.isRightTime = NO;
    self.isShowNode = NO;
    self.isNeedScroll = YES;
}

- (void)sendMessage:(MessageModel*)model
{
    @autoreleasepool {
        if (self.data.count > 200) {
            [self.dataCache addObjectsFromArray:[self.data subarrayWithRange:NSMakeRange(0, 100)]];
            [self.data removeObjectsInRange:NSMakeRange(0, 100)];
        }
        if (self.dataCache.count>500) {
            [self.dataCache removeObjectsInRange:NSMakeRange(0, 100)];
        }
        //将model对象加入到信息model数组里面
        [self.data addObject:model];
        
        if (self.isNeedScroll && self.isRightTime) {
            NSLog(@"scroll");
            if (self.isShowNode) {
                self.ShowNodeView(NO);
            }
            self.notLookNum = 0;
            //将最后一个单元格滚动到表视图的底部显示
            [self reloadData];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.data.count-1 inSection:0];
            [self scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            self.isRightTime = NO;
            self.isShowNode = NO;
        }else{
             NSLog(@"Noscroll");
            if (!self.isNeedScroll) {
                if (!self.isShowNode) {
                    self.ShowNodeView(YES);
                }
                self.isShowNode = YES;
                  self.notLookNum+=1;
                if (self.ShowNodeNumber) {
                    self.ShowNodeNumber(self.notLookNum);
                }
            }
          
            
        }
    }
}


#pragma mark ----UITableViewDataSource----

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageCell" forIndexPath:indexPath];
    @try {
        cell.model = self.data[indexPath.row];
    }
    @catch (NSException *exception) {
        NSLog(@"dataCout:%lu,indexPathRow:%ld",(unsigned long)self.data.count,(long)indexPath.row);
        cell.model = [self.data lastObject];
    }
    cell.label.preferredMaxLayoutWidth = CGRectGetWidth(self.frame)-10;
    cell.label.delegate = self;
    cell.label.textContainer = [cell.label.textContainer createTextContainerWithTextWidth:CGRectGetWidth(self.frame)-10];
    return cell;
}

#pragma  mark -- UITableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewAutomaticDimension;
    
}
#pragma mark - TYAttributedLabelDelegate
- (void)attributedLabel:(TYAttributedLabel *)attributedLabel textStorageClicked:(id<TYTextStorageProtocol>)TextRun atPoint:(CGPoint)point
{
    if ([TextRun isKindOfClass:[TYLinkTextStorage class]]) {
        
        id linkStr = ((TYLinkTextStorage*)TextRun).linkData;
        if ([linkStr isKindOfClass:[NSString class]]) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"点击提示" message:linkStr delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
        }
    }
}

#pragma mark --UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat height = scrollView.frame.size.height;
    CGFloat contentYoffset = scrollView.contentOffset.y;
    CGFloat distanceFromBottom = scrollView.contentSize.height - contentYoffset;
    
    if (distanceFromBottom < height) {
        self.isNeedScroll = YES;
    }
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
    if (velocity.y < 0 || velocity.y == 0) {
        self.isNeedScroll = NO;
    }
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.isNeedScroll = NO;
}

- (void)receiveNotification:(NSNotification *)notification {
    
    NSString *string = notification.object;
    //判断消息类型
    if ([string rangeOfString:@"type@=mrkl"].location == NSNotFound) {
        MessageModel *model = [MessageModel new];
        if ([string rangeOfString:@"type@=chatmsg"].location != NSNotFound) {
            model.cellType = CellNewChatMessageType;
            
        }else if ([string rangeOfString:@"type@=dgb"].location != NSNotFound){
            model.cellType = CellNewGiftType;
            model.gift = self.giftInfo;
            
        }else if ([string rangeOfString:@"type@=uenter"].location != NSNotFound){
            model.cellType = CellNewUserEnterType;
            
        }else if ([string rangeOfString:@"type@=blackres"].location != NSNotFound){
            model.cellType = CellBanType;
            
        }else if ([string rangeOfString:@"type@=bc_buy_deserve"].location != NSNotFound){
            model.cellType = CellDeserveType;
        }else{
            NSLog(@"%@",string);
            model = nil;
            return;
        }
        [model setModelFromStirng:string];
        
        if (self.data.count > 200) {
            
            [self.dataCache addObjectsFromArray:[self.data subarrayWithRange:NSMakeRange(0, 100)]];
            [self.data removeObjectsInRange:NSMakeRange(0, 100)];
        }
        //将model对象加入到信息model数组里面
        [self.data addObject:model];
        
        if (self.isNeedScroll && self.isRightTime) {
            //将最后一个单元格滚动到表视图的底部显示
            [self reloadData];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.data.count-1 inSection:0];
            [self scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            self.isRightTime = NO;
            
        }
    }
}

- (void)timeToReloadData{
    self.isRightTime = YES;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    MessageModel *model = self.data[indexPath.row];
//    NSLog(@"%@",model.dataString);
//}



@end
