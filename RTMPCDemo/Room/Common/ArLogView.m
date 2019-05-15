//
//  ArLogView.m
//  RTCMeeting
//
//  Created by 余生丶 on 2019/3/21.
//  Copyright © 2019 Ar. All rights reserved.
//

#import "ArLogView.h"

@interface ArLogView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *logTableView;
@property (nonatomic, strong) NSMutableArray *logArr;

@end

@implementation ArLogView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.8];
        self.logArr = [NSMutableArray array];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, 100, 30)];
        label.font = [UIFont boldSystemFontOfSize:25];
        label.textColor = [UIColor whiteColor];
        label.text = @"日志";
        [self addSubview:label];
        
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        closeButton.frame = CGRectMake(frame.size.width - 50, 30, 30, 30);
        [closeButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(removeLogView) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeButton];
        
        self.logTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 80, CGRectGetWidth(self.frame) - 20, CGRectGetHeight(self.frame) - 80) style:UITableViewStylePlain];
        self.logTableView.dataSource = self;
        self.logTableView.delegate = self;
        self.logTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.logTableView.backgroundColor = [UIColor clearColor];
        self.logTableView.rowHeight = 44;
        self.logTableView.tableFooterView = [UIView new];
        [self addSubview:self.logTableView];
    }
    return self;
}

- (void)refreshLogText:(NSMutableArray *)logArr {
    self.logArr = logArr;
    [self.logTableView reloadData];
}

// MARK: - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.logArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ArLogCellID"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ArLogCellID"];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.logArr[indexPath.row];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    return cell;
}

- (void)removeLogView {
    [self removeFromSuperview];
}

@end
