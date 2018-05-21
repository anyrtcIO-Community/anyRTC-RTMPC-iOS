//
//  ATBarragesView.m
//  RTMPCDemo
//
//  Created by jh on 2018/4/18.
//  Copyright © 2018年 jh. All rights reserved.
//

#import "ATBarragesView.h"

@implementation ATBarragesCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.label = [[UILabel alloc] initWithFrame:CGRectZero];
        self.label.textColor = [UIColor whiteColor];
        self.label.numberOfLines = 0;
        [self.contentView addSubview:self.label];
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(10, 12, 12, SCREEN_WIDTH/4));
        }];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setBarrageModel:(ATBarragesModel *)barrageModel{
    _barrageModel = barrageModel;
    NSMutableAttributedString *attributedString0 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@: ",barrageModel.userName]];
    
    NSMutableAttributedString *attributedString1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",barrageModel.content]];
    if (barrageModel.isHost) {
        [attributedString0 addAttribute:NSForegroundColorAttributeName value:[ATCommon getColor:@"#ff4b49"] range:NSMakeRange(0, attributedString0.length)];
    } else {
        [attributedString0 addAttribute:NSForegroundColorAttributeName value:[ATCommon getColor:@"#FF8000"]  range:NSMakeRange(0, attributedString0.length)];
    }
    
    [attributedString0 addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:17] range:NSMakeRange(0, attributedString0.length)];
    
    [attributedString1 addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, attributedString1.length)];
    [attributedString1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, attributedString1.length)];
    
    NSMutableAttributedString *mutableStr = [[NSMutableAttributedString alloc] initWithAttributedString:attributedString0];
    [mutableStr appendAttributedString:attributedString1];
    
    self.label.attributedText = mutableStr;
}

@end

@interface ATBarragesView()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *_tableView;
}

@end

@implementation ATBarragesView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.infoArr = [NSMutableArray array];
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 50;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[ATBarragesCell class] forCellReuseIdentifier:@"11"];
        [self addSubview:_tableView];
    }
    return self;
}

- (void)addMessage:(ATBarragesModel *)model{
    [self.infoArr addObject:model];
    [_tableView reloadData];
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:self.infoArr.count - 1 inSection:0];
    [_tableView scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.infoArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ATBarragesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"11"];
    ATBarragesModel *model = self.infoArr[indexPath.row];
    cell.barrageModel = model;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

@end
