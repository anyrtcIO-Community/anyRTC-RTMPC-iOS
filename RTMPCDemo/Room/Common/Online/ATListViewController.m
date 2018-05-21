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

@property (nonatomic, strong) UITableView *listTableView;

@property (nonatomic, strong) NSMutableArray *listArr;

@end

@implementation ATListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self customNavigationBar:@"在线人员"];
    self.listArr = [NSMutableArray arrayWithCapacity:5];
    
    self.listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    [self.view addSubview:self.listTableView];
    self.listTableView.tableFooterView = [UIView new];
    self.listTableView.rowHeight = 80;
    self.listTableView.delegate = self;
    self.listTableView.dataSource = self;
    MJRefreshHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshListMembers)];
    self.listTableView.mj_header = refreshHeader;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.listTableView.mj_header beginRefreshing];
}

- (void)refreshListMembers{
    _page = 0;
    [self getListData];
}

//在线人员列表
- (void)getListData{
    WEAKSELF;
    [[RTMPCHttpKit shead] getLiveMemberList:self.serverId withRoomId:self.roomId withAnyRTCId:self.anyrtcId withPage:_page withResultBlock:^(NSDictionary *responseDict, NSError *error, int code) {
        (_page == 0) ? ([self.listArr removeAllObjects]) : nil;
        
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

#pragma mark -UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RTMPC_List_CellID"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RTMPC_List_CellID"];
    }
    UserData *model = self.listArr[indexPath.row];
    cell.textLabel.text = model.nickName;
    cell.imageView.image = [UIImage imageNamed:@"headurl"];
    return cell;
}

- (BOOL)prefersStatusBarHidden{
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

@end
