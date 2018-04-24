//
//  ATHallViewController.m
//  RTMPCDemo
//
//  Created by jh on 2018/4/11.
//  Copyright © 2018年 jh. All rights reserved.
//

#import "ATHallViewController.h"
#import "ATHallModel.h"

@implementation ATHallCell

- (void)updateCell:(ATHallModel *)hallModel withOnLine:(NSString *)online{
    
    NSString *type = @"";
    hallModel.isAudioLive ? (type = @"voice_image") : (type = @"video_image");
    
    self.topicLabel.text = hallModel.liveTopic;
    
    self.userNameLabel.attributedText = [ATCommon getAttributedString:[NSString stringWithFormat:@" %@",hallModel.hosterName] imageSize:CGRectMake(0, 0, 15, 15) image:[UIImage imageNamed:@"name"] index:0];
    
    self.roomIdLabel.attributedText = [ATCommon getAttributedString:[NSString stringWithFormat:@" %@",hallModel.anyrtcId] imageSize:CGRectMake(0, 0, 15, 15) image:[UIImage imageNamed:@"ID"] index:0];
    
    self.onlineLabel.attributedText = [ATCommon getAttributedString:[NSString stringWithFormat:@" %@",online] imageSize:CGRectMake(0, 0, 15, 15) image:[UIImage imageNamed:@"people"] index:0];
}

@end

@interface ATHallViewController ()

@property (weak, nonatomic) IBOutlet UIView *topView;
//游客昵称
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (nonatomic, strong) UILabel *footerLabel;
//游客信息
@property (nonatomic, strong) GuestInfo *gestInfo;

@end

@implementation ATHallViewController{
    NSMutableArray *_hallArr;    //大厅列表
    
    NSMutableArray *_onLineArr;  //直播间实时人数
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _hallArr = [NSMutableArray arrayWithCapacity:5];
    _onLineArr = [NSMutableArray arrayWithCapacity:5];
    self.nameLabel.text = [NSString stringWithFormat:@"iOS_%@",[ATCommon randomString:3]];
    
    UIButton *backButton = [self.view viewWithTag:50];
    [backButton addTarget:self action:@selector(addTargetEvent) forControlEvents:UIControlEventTouchUpInside];

    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    
    [self refreshSub];
}

#pragma mark - 刷新
- (void)refreshSub{
    MJRefreshHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getHallData)];
    self.tableView.mj_header = refreshHeader;
}

//大厅列表
- (void)getHallData{
    WEAKSELF;
    [[RTMPCHttpKit shead]getLivingList:^(NSDictionary *responseDict, NSError *error, int code) {
        if (code == 200) {
            [_hallArr removeAllObjects];
            [_onLineArr removeAllObjects];
            
            NSArray *arr = [ATHallModel mj_objectArrayWithKeyValuesArray:[responseDict objectForKey:@"LiveList"]];
            [_hallArr addObjectsFromArray:arr];
            [_onLineArr addObjectsFromArray:[responseDict objectForKey:@"LiveMembers"]];
            [weakSelf.tableView reloadData];
        }
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}

- (void)addTargetEvent{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    _hallArr.count == 0 ? (self.tableView.tableFooterView = self.footerLabel) : (self.tableView.tableFooterView = nil);
    return (_hallArr.count == 0) ? 0 : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ATHallCell *cell = (ATHallCell *)[tableView dequeueReusableCellWithIdentifier:@"RTMPC_HallCellID" forIndexPath:indexPath];
    ATHallModel *hallModel = _hallArr[indexPath.row];
    //在线人数
    NSString *lineStr = [NSString stringWithFormat:@"%@",_onLineArr[indexPath.row]];
    [cell updateCell:hallModel withOnLine:lineStr];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _hallArr.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ATHallModel *hallModel = _hallArr[indexPath.row];
    _gestInfo.userId = [ATCommon randomString:6];

    [self getAppVdnUrl:hallModel];
}

#pragma mark - 获取推拉流地址

- (void)getAppVdnUrl:(ATHallModel *)hallModel{
    
    NSTimeInterval time =[[NSDate date] timeIntervalSince1970] * 1000;
    long long timestamp = [[NSNumber numberWithDouble:time] longLongValue];
    
    NSString *randomStr = [ATCommon randomAnyRTCString:6];
    NSString *signatureStr = [NSString stringWithFormat:@"%@%llu%@%@",appID,timestamp,appvtoken,randomStr];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:appID,@"appid",hallModel.anyrtcId,@"stream",randomStr,@"random",[ATCommon md5OfString:signatureStr],@"signature",[NSNumber numberWithLongLong:timestamp],@"timestamp",@"com.dync.rtmpc.anyrtc",@"appBundleIdPkgName",nil];
    WEAKSELF;
    [[NetWorkTools shareInstance] postWithURLString:App_VdnUrl parameters:dict success:^(NSDictionary *dictionary) {
        if ([[dictionary objectForKey:@"code"] intValue] == 200) {
            hallModel.rtmpUrl = [dictionary objectForKey:@"pull_url"];
            hallModel.hlsUrl = [dictionary objectForKey:@"hls_url"];
            
            if (hallModel.isAudioLive) {
                ATAudioAudienceController *audioVc = [[self storyboard] instantiateViewControllerWithIdentifier:@"RTMPC_Audio_Audience"];
                audioVc.hallModel = hallModel;
                audioVc.userName = self.nameLabel.text;
                [weakSelf.navigationController pushViewController:audioVc animated:YES];
            } else {
                ATVideoAudienceController *videoVc = [[self storyboard] instantiateViewControllerWithIdentifier:@"RTMPC_Video_Audience"];
                videoVc.hallModel = hallModel;
                videoVc.userName = self.nameLabel.text;
                [weakSelf.navigationController pushViewController:videoVc animated:YES];
            }
        } else {
            [XHToast showCenterWithText:@"开发者信息异常"];
        }
    } failure:^(NSError *error) {
        [XHToast showCenterWithText:@"网络异常"];
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.topView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 9/16);
    [self.tableView setTableHeaderView:self.topView];
    [self getHallData];
}

#pragma mark - 懒加载
- (UILabel *)footerLabel{
    if (!_footerLabel) {
        _footerLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 240)];
        _footerLabel.textAlignment = NSTextAlignmentCenter;
        _footerLabel.textColor = [UIColor lightGrayColor];
        _footerLabel.text = @"————  已经没有其他直播间  ————";
    }
    return _footerLabel;
}

- (GuestInfo *)gestInfo{
    if (!_gestInfo) {
        _gestInfo = [[GuestInfo alloc]init];
        _gestInfo.userName = self.nameLabel.text;
        _gestInfo.userId = [ATCommon randomString:6];
    }
    return _gestInfo;
}

@end
