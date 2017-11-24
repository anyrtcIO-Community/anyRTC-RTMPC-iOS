//
//  ATListViewController.m
//  RTMPCDemo
//
//  Created by jh on 2017/9/29.
//  Copyright © 2017年 jh. All rights reserved.
//

#import "ATListViewController.h"
#import "ATListModel.h"

@interface ATListViewController ()<UITableViewDelegate,UITableViewDataSource>{
    int _page;
}

@end

@implementation ATListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.listTableView.tableFooterView = [[UIView alloc]init];
    self.listTableView.delegate = self;
    self.listTableView.dataSource = self;
    MJRefreshHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshListMembers)];
    self.listTableView.mj_header = refreshHeader;
    [self.listTableView.mj_header beginRefreshing];
}

- (void)refreshListMembers{
    _page = 0;
    [self getListData];
}

//获取实时在线人员列表
- (void)getListData{
    WEAKSELF;
    [[RTMPCHttpKit shead] getLiveMemberList:self.serverId withRoomId:self.roomId withAnyRTCId:self.anyrtcId withPage:_page withResultBlock:^(NSDictionary *responseDict, NSError *error, int code) {
        if (_page == 0) {
            [self.listArr removeAllObjects];
        }
        ATListModel *model = [ATListModel mj_objectWithKeyValues:responseDict];
        [weakSelf.listArr addObjectsFromArray:model.UserData];
        [weakSelf.listTableView.mj_header endRefreshing];
        [weakSelf.listTableView.mj_footer endRefreshing];
        if (model.Total > self.listArr.count) {
            weakSelf.listTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                _page++;
                [weakSelf getListData];
            }];
        }
        
        [self.listTableView reloadData];
    }];
}

- (IBAction)doSomethingEvents:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"11"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"11"];
    }
    UserData *model = self.listArr[indexPath.row];
    cell.textLabel.text = model.nickName;
    cell.imageView.image = [UIImage imageNamed:@"headurl"];
    return cell;
}

#pragma mark - other
- (NSMutableArray *)listArr{
    if (!_listArr) {
        _listArr = [[NSMutableArray alloc]init];
    }
    return _listArr;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
     [UIApplication sharedApplication].statusBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
}

@end
