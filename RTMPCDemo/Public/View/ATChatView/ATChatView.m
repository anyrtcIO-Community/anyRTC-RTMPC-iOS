//
//  ATChatView.m
//  RTMPCDemo
//
//  Created by derek on 2017/9/22.
//  Copyright © 2017年 jh. All rights reserved.
//

#import "ATChatView.h"
#import "ATChatCell.h"
static NSString *atChatCell = @"ATChatCell";
@interface ATChatView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation ATChatView
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initUI];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}
- (void)initUI {
    self.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.tableView];
   
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary* views = NSDictionaryOfVariableBindings(_tableView);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_tableView]-0-|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_tableView]-0-|" options:0 metrics:nil views:views]];
    
    self.dataArray = [[NSMutableArray alloc] initWithCapacity:5];

}
- (void)sendMessage:(ATChatItem*)chatItem {
    
    // 本地缓存100条数据 当大于100的时候，删除部分
    if (self.dataArray.count > 100) {
        [self.dataArray removeObjectsInRange:NSMakeRange(0, 30)];
    }
    
    [self.dataArray addObject:chatItem];
    [self.tableView reloadData];
    
    //将最后一个单元格滚动到表视图的底部显示
    [self.tableView reloadData];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:self.dataArray.count-1];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    
}
#pragma mark - UITableViewDelegate UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ATChatCell *cell = (ATChatCell*)[tableView dequeueReusableCellWithIdentifier:atChatCell];
    cell.messageItem = [self.dataArray objectAtIndex:indexPath.section];
    
    return cell;
}


#pragma mark - Table View Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
}

#pragma mark - get
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.sectionFooterHeight = .1;
        _tableView.sectionHeaderHeight = 5;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 50;
        _tableView.backgroundColor = [UIColor clearColor];
        [self.tableView registerNib:[UINib nibWithNibName:@"ATChatCell" bundle:nil] forCellReuseIdentifier:atChatCell];
        _tableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
        
    }
    return _tableView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
