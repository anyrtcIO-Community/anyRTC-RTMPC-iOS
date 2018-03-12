//
//  ATHallViewController.m
//  RTMPDemo
//
//  Created by jh on 2017/9/14.
//  Copyright © 2017年 jh. All rights reserved.
//

#import "ATHallViewController.h"
//主播端
#import "ATHosterViewController.h"
//游客端
#import "ATGuesterViewController.h"

#import "ATAudioGuesterViewController.h"

#import "ATLivingItem.h"
#import "ATHallCell.h"

#define ATHallCellID @"ATHallCellID"

@interface ATHallViewController ()<UITableViewDelegate,UITableViewDataSource>

//大厅列表
@property (nonatomic, strong)NSMutableArray *hallArr;

//直播间实时人数
@property (nonatomic, strong) NSMutableArray *onLineArr;

@property (nonatomic, strong) UILabel *footerLabel;

@end

@implementation ATHallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.nameLabel.text = [ATCommon randomString:2];
    self.headImageView.layer.cornerRadius = SCREEN_WIDTH * 0.14;
    self.hallTableView.tableFooterView = self.footerLabel;
    self.hallTableView.separatorColor = [UIColor clearColor];
    [self.hallTableView registerNib:[UINib nibWithNibName:@"ATHallCell" bundle:nil] forCellReuseIdentifier:ATHallCellID];
    //刷新
    [self refreshSub];
}

#pragma mark - 刷新
- (void)refreshSub{
    MJRefreshHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getHallData)];
    self.hallTableView.mj_header = refreshHeader;
    [self.hallTableView.mj_header beginRefreshing];
}

//获取大厅数据
- (void)getHallData{
    WEAKSELF;
    [[RTMPCHttpKit shead]getLivingList:^(NSDictionary *responseDict, NSError *error, int code) {
        if (code == 200) {
            [weakSelf.hallArr removeAllObjects];
            [weakSelf.onLineArr removeAllObjects];
            ATLivingItem *item = [ATLivingItem mj_objectWithKeyValues:responseDict];
            [weakSelf.hallArr addObjectsFromArray:item.LiveList];
            [weakSelf.onLineArr addObjectsFromArray:[responseDict objectForKey:@"LiveMembers"]];
            [weakSelf.hallTableView reloadData];
        }
        [weakSelf.hallTableView.mj_header endRefreshing];
    }];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ATHallCell *cell = (ATHallCell *)[tableView dequeueReusableCellWithIdentifier:ATHallCellID forIndexPath:indexPath];
    LiveList *item = self.hallArr[indexPath.row];
    //在线人数
    NSString *lineStr = [NSString stringWithFormat:@"%@",self.onLineArr[indexPath.row]];
    [cell updateCell:item withOnLine:lineStr];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.hallArr.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LiveList *item = self.hallArr[indexPath.row];
    self.gestInfo.userName = self.nameLabel.text;
    self.gestInfo.userId = [ATCommon randomString:6];
    self.gestInfo.headUrl = @"http://f.rtmpc.cn/p/g/jmaRia";
    [self getAppVdnUrl:item];
}

//获取推拉流地址
- (void)getAppVdnUrl:(LiveList *)liveItem{
    
    NSTimeInterval time =[[NSDate date] timeIntervalSince1970] * 1000;
    long long timestamp = [[NSNumber numberWithDouble:time] longLongValue];
    
    NSString *randomStr = [ATCommon randomAnyRTCString:6];
    NSString *signatureStr = [NSString stringWithFormat:@"%@%llu%@%@",appID,timestamp,appvtoken,randomStr];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:appID,@"appid",liveItem.anyrtcId,@"stream",randomStr,@"random",[ATCommon md5OfString:signatureStr],@"signature",[NSNumber numberWithLongLong:timestamp],@"timestamp",@"com.dync.rtmpc.anyrtc",@"appBundleIdPkgName",nil];
    WEAKSELF;
    [[NetWorkTools shareInstance] postWithURLString:App_VdnUrl parameters:dict success:^(NSDictionary *dictionary) {
        if ([[dictionary objectForKey:@"code"] intValue] == 200) {
            liveItem.rtmpUrl = [dictionary objectForKey:@"pull_url"];
            liveItem.hlsUrl = [dictionary objectForKey:@"hls_url"];
            
            if (liveItem.isAudioLive) {
                //音频
                ATAudioGuesterViewController *gestVc = [[ATAudioGuesterViewController alloc]init];
                gestVc.liveItem = liveItem;
                gestVc.gestInfo = self.gestInfo;
                [weakSelf presentViewController:gestVc animated:YES completion:nil];
            } else {
                //视频
                ATGuesterViewController *gestVc = [[ATGuesterViewController alloc]init];
                gestVc.refreshBlock = ^{
                    [weakSelf getHallData];
                };
                gestVc.liveItem = liveItem;
                gestVc.gestInfo = self.gestInfo;
                [weakSelf presentViewController:gestVc animated:YES completion:nil];
            }
            
        } else {
            [XHToast showCenterWithText:@"开发者信息异常"];
        }
    } failure:^(NSError *error) {
        [XHToast showCenterWithText:@"网络异常"];
    }];
}

- (IBAction)doSomethingEvents:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 懒加载
- (UILabel *)footerLabel{
    if (!_footerLabel) {
        _footerLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 200)];
        _footerLabel.textAlignment = NSTextAlignmentCenter;
        _footerLabel.textColor = [UIColor lightGrayColor];
        _footerLabel.text = @"————  已经没有其他直播间  ————";
    }
    return _footerLabel;
}

- (NSMutableArray *)hallArr{
    if (!_hallArr) {
        //大厅
        _hallArr = [[NSMutableArray alloc]init];
    }
    return _hallArr;
}

- (NSMutableArray *)onLineArr{
    if (!_onLineArr) {
        //在线人数
        _onLineArr = [[NSMutableArray alloc]init];
    }
    return _onLineArr;
}

- (GuestInfo *)gestInfo{
    if (!_gestInfo) {
        //游客信息
        _gestInfo = [[GuestInfo alloc]init];
    }
    return _gestInfo;
}

@end

