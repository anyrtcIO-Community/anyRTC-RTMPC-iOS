//
//  ArMainViewController.m
//  RTMPCDemo
//
//  Created by 余生丶 on 2019/4/10.
//  Copyright © 2019 anyRTC. All rights reserved.
//

#import "ArMainViewController.h"
#import "ArNetWorkTools.h"
#import "ArVideoHostController.h"
#import "ArVideoAudienceController.h"
#import "ArAudioHostController.h"
#import "ArAudioAudienceController.h"

@implementation ArMainCollectionCell

- (void)updateCell:(ArMainModel *)hallModel withOnLine:(NSString *)online {
    self.topicLabel.text = [NSString stringWithFormat:@"%@",hallModel.anyrtcId];
    self.typeButton.selected = hallModel.isAudioLive;
    [self.onlineButton setTitle:online forState:UIControlStateNormal];
}

@end

@interface ArMainViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *listCollectionView;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIButton *refreshButton;
@property (weak, nonatomic) IBOutlet UIButton *updateButton;
/** 大厅列表 */
@property (nonatomic, strong) NSMutableArray *listArr;
/** 在线人数 */
@property (nonatomic, strong) NSMutableArray *onlineArr;
@property (nonatomic, strong) ArLiveInfo *liveInfo;

@end

@implementation ArMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.listArr = [NSMutableArray arrayWithCapacity:5];
    self.onlineArr = [NSMutableArray arrayWithCapacity:5];
    self.backView.hidden = NO;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.sectionInset = UIEdgeInsetsMake(5, 10, 5, 10);
    flowLayout.itemSize = CGSizeMake(150, 90);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = 15;
    self.listCollectionView.collectionViewLayout = flowLayout;
    
    [self.refreshButton addTarget:self action:@selector(getListData) forControlEvents:UIControlEventTouchUpInside];
    [self.updateButton addTarget:self action:@selector(getListData) forControlEvents:UIControlEventTouchUpInside];
}

- (void)getListData {
    //获取直播大厅列表
    WEAKSELF;
    [ARRtmpHttpKit.shead getLivingList:^(NSDictionary * _Nonnull responseDict, NSError * _Nonnull error, int code) {
        if (code == 200) {
            [weakSelf.listArr removeAllObjects];
            [weakSelf.onlineArr removeAllObjects];
            
            NSArray *arr = [ArMainModel mj_objectArrayWithKeyValuesArray:[responseDict objectForKey:@"LiveList"]];
            [weakSelf.listArr addObjectsFromArray:arr];
            [weakSelf.onlineArr addObjectsFromArray:[responseDict objectForKey:@"LiveMembers"]];
            weakSelf.backView.hidden = weakSelf.listArr.count;
            weakSelf.updateButton.hidden = !weakSelf.listArr.count;
            [weakSelf.listCollectionView reloadData];
            
        }
    }];
}

- (IBAction)getAppVdnUrl:(UIButton *)sender {
    //获取推拉流地址
    NSTimeInterval time =[[NSDate date] timeIntervalSince1970] * 1000;
    long long timestamp = [[NSNumber numberWithDouble:time] longLongValue];
    
    NSString *randomStr = [ArCommon randomAnyRTCString:6];
    NSString *signatureStr = [NSString stringWithFormat:@"%@%llu%@%@",appID,timestamp,appvtoken,randomStr];
    WEAKSELF;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:appID,@"appid",self.liveInfo.anyrtcId,@"stream",randomStr,@"random",[ArCommon md5OfString:signatureStr],@"signature",[NSNumber numberWithLongLong:timestamp],@"timestamp",@"com.dync.rtmpc.anyrtc",@"appBundleIdPkgName",nil];
    [ArNetWorkTools.shareInstance postWithURLString:App_VdnUrl parameters:dict success:^(NSDictionary * _Nonnull dictionary) {
        if ([[dictionary objectForKey:@"code"] intValue] == 200) {
            [weakSelf startLiving:dictionary liveType:sender.tag];
        } else {
            [ArCommon showAlertsStatus:@"获取推拉流地址失败"];
        }
    } failure:^(NSError * _Nonnull error) {
        [ArCommon showAlertsStatus:@"请检查网络状态"];
    }];
}

- (void)startLiving:(NSDictionary *)dic liveType:(BOOL)type {
    self.liveInfo.push_url = [dic objectForKey:@"push_url"];
    self.liveInfo.pull_url = [dic objectForKey:@"pull_url"];
    self.liveInfo.hls_url = [dic objectForKey:@"hls_url"];
    if (!type) {
        //视频直播
        ArVideoHostController *hostVc = [[self storyboard] instantiateViewControllerWithIdentifier:@"RTMPC_Video_Host"];
        hostVc.liveInfo = self.liveInfo;
        [self presentViewController:hostVc animated:YES completion:nil];
    } else {
        //音频直播
        ArAudioHostController *hostVc = [[self storyboard] instantiateViewControllerWithIdentifier:@"RTMPC_Audio_Host"];
        hostVc.liveInfo = self.liveInfo;
        [self presentViewController:hostVc animated:YES completion:nil];
    }
}

//MARK: - UICollectionViewDataSource、UICollectionViewDelegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ArMainCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ArMainCellID" forIndexPath:indexPath];
    ArMainModel *mainModel = self.listArr[indexPath.row];
    NSString *lineStr = [NSString stringWithFormat:@"%@",self.onlineArr[indexPath.row]];
    [cell updateCell:mainModel withOnLine:lineStr];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.listArr.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ArMainModel *mainModel = self.listArr[indexPath.row];
    if (!mainModel.isAudioLive) {
        //视频
        ArVideoAudienceController *guestVc = [[self storyboard] instantiateViewControllerWithIdentifier:@"RTMPC_Video_Audience"];
        guestVc.mainModel = mainModel;
        [self presentViewController:guestVc animated:YES completion:nil];
    } else {
        //音频
        ArAudioAudienceController *audioVc = [[self storyboard] instantiateViewControllerWithIdentifier:@"RTMPC_Audio_Audience"];
        audioVc.mainModel = mainModel;
        [self presentViewController:audioVc animated:YES completion:nil];
    }
}

//MARK: - other

- (ArLiveInfo *)liveInfo {
    if (!_liveInfo) {
        _liveInfo = [[ArLiveInfo alloc] init];
        _liveInfo.anyrtcId = [ArCommon randomAnyRTCString:8];
    }
    return _liveInfo;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getListData];
}

@end
