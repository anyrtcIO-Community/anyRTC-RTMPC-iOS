//
//  ArMessageView.m
//  RTMPCDemo
//
//  Created by 余生丶 on 2019/4/15.
//  Copyright © 2019 anyRTC. All rights reserved.
//

#import "ArMessageView.h"

@implementation ArMessageModel

@end

@implementation ArMessageView {
    UITableView *_tableView;
}

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        self.infoArr = [NSMutableArray array];
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 30;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
        [self addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 5, 0, 0));
        }];
    }
    return self;
}

- (void)addMessage:(ArMessageModel *)model{
    [self.infoArr addObject:model];
    [_tableView reloadData];
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:self.infoArr.count - 1 inSection:0];
    [_tableView scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}

//MARK: - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.infoArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"11"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"11"];
    }
    ArMessageModel *model = self.infoArr[indexPath.row];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:15];
    cell.textLabel.textColor = [UIColor whiteColor];
    model.isAudio ? (cell.textLabel.textColor = [ArCommon getColor:@"#666666"]) : (cell.textLabel.textColor = [UIColor whiteColor]);

    NSMutableAttributedString *attributeText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@：%@",model.userName,model.content]];
    NSString *colorText = @"#FF6264";
    if (![model.userid isEqualToString:ArUserManager.getUserInfo.userid]) {
        colorText = @"#46A9FE";
    }
    [attributeText addAttribute:NSForegroundColorAttributeName value:[ArCommon getColor:colorText] range:NSMakeRange(0, model.userName.length)];
    cell.textLabel.attributedText = attributeText;
    [cell.textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(cell.contentView).insets(UIEdgeInsetsMake(0, 5, 5, 5));
    }];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}


@end
