//
//  ATStartViewController.m
//  RTMPCDemo
//
//  Created by jh on 2017/9/22.
//  Copyright © 2017年 jh. All rights reserved.
//

#import "ATStartViewController.h"

@interface ATStartViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic,strong)NSArray *pickArr;

@end

@implementation ATStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.headImageView.layer.cornerRadius = SCREEN_WIDTH * 0.14;
    self.headImageView.layer.masksToBounds = YES;
    self.nameLabel.text = [NSString stringWithFormat:@"iOS_%@",[ATCommon randomString:3]];
    self.goBackButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidesKeyBords)];
    [self.view addGestureRecognizer:tap];
    
    //随机直播名
    NSString *randomTopic = [ATCommon randomCreatChinese:4];
    self.topicTextField.text = randomTopic;
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.pickArr.count;
}

#pragma mark - UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component __TVOS_PROHIBITED{
    return 50.0;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component __TVOS_PROHIBITED{
    return self.pickArr[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component __TVOS_PROHIBITED{
    NSString *indexStr = self.pickArr[row];
    switch (self.index) {
        case 100:
            //直播类型
            [self.typeButton setTitle:indexStr forState:UIControlStateNormal];
            
            if ([indexStr isEqualToString:@"音频直播"]) {
                [self.modeButton setTitle:@"48K" forState:UIControlStateNormal];
            }
            
            if ([indexStr isEqualToString:@"视频直播"] && [self.modeButton.titleLabel.text isEqualToString:@"48K"]) {
                [self.modeButton setTitle:@"顺畅" forState:UIControlStateNormal];
            }
            
            break;
        case 101:
            //直播质量
            [self.modeButton setTitle:indexStr forState:UIControlStateNormal];
            break;
        case 102:
            //直播方向
            [self.directionButton setTitle:indexStr forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

#pragma mark - event
- (IBAction)doSomethingEvents:(UIButton *)sender {
    [ATCommon hideKeyBoard];
    
    if (self.index == sender.tag) {
        self.bottomY.constant = - 200.0;
        self.index = 0;
        return;
    }
    
    self.bottomY.constant = 0.0;
    self.index = sender.tag;
    switch (sender.tag) {
        case 100:
            self.pickArr = @[@"视频直播",@"音频直播"];
            [self.pickerView reloadAllComponents];
            break;
            
        case 101:
            if ([self.typeButton.titleLabel.text isEqualToString:@"音频直播"]) {
                self.pickArr = @[@"48K"];
                [self.pickerView reloadAllComponents];
                return;
            }
            
            self.pickArr = @[@"顺畅",@"标清",@"高清"];
            [self.pickerView reloadAllComponents];
            break;
            
        case 102:
            self.pickArr = @[@"横屏直播",@"竖屏直播"];
            [self.pickerView reloadAllComponents];
            break;
            
        case 103:
            self.bottomY.constant = -200;
            [self getAppVdnUrl];
            break;
            
        case 104:
            [self.navigationController popViewControllerAnimated:YES];
            break;
            
        default:
            break;
    }
    
    //正确的位置
    for (NSInteger i = 0; i < self.pickArr.count; i++) {
        if ([sender.titleLabel.text isEqualToString:self.pickArr[i]]) {
            [self.pickerView selectRow:i inComponent:0 animated:YES];
        }
    }
}

//获取推拉流地址
- (void)getAppVdnUrl{
    
    NSTimeInterval time =[[NSDate date] timeIntervalSince1970] * 1000;
    long long timestamp = [[NSNumber numberWithDouble:time] longLongValue];
    
    NSString *randomStr = [ATCommon randomAnyRTCString:6];
    NSString *signatureStr = [NSString stringWithFormat:@"%@%llu%@%@",appID,timestamp,appvtoken,randomStr];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:appID,@"appid",self.liveInfo.anyrtcId,@"stream",randomStr,@"random",[ATCommon md5OfString:signatureStr],@"signature",[NSNumber numberWithLongLong:timestamp],@"timestamp",@"com.dync.rtmpc.anyrtc",@"appBundleIdPkgName",nil];
    WEAKSELF;
    [[NetWorkTools shareInstance] postWithURLString:App_VdnUrl parameters:dict success:^(NSDictionary *dictionary) {
        if ([[dictionary objectForKey:@"code"] intValue] == 200) {
            weakSelf.liveInfo.push_url = [dictionary objectForKey:@"push_url"];
            weakSelf.liveInfo.pull_url = [dictionary objectForKey:@"pull_url"];
            weakSelf.liveInfo.hls_url = [dictionary objectForKey:@"hls_url"];
            [weakSelf startLiving];
        } else {
            [XHToast showCenterWithText:@"服务异常"];
        }
    } failure:^(NSError *error) {
        [XHToast showCenterWithText:@"网络异常"];
    }];
}

- (void) startLiving{
    
    if ([self.directionButton.titleLabel.text isEqualToString:@"横屏直播"]) {
        self.liveInfo.isLiveLandscape = 1;
    } else {
        self.liveInfo.isLiveLandscape = 0;
    }
    
    self.liveInfo.userName = self.nameLabel.text;
    self.liveInfo.liveTopic = self.topicTextField.text;
    self.liveInfo.videoMode = self.modeButton.titleLabel.text;
    self.index = 0;
    
    if ([self.typeButton.titleLabel.text isEqualToString:@"视频直播"]) {
        self.liveInfo.isAudioLive = 0;
        ATVideoHostController *hostVc = [[self storyboard] instantiateViewControllerWithIdentifier:@"RTMPC_Video_Host"];
        hostVc.liveInfo = self.liveInfo;
        [self.navigationController pushViewController:hostVc animated:YES];
    } else {
        self.liveInfo.isAudioLive = 1;
        ATAudioHostController *hostVc = [[self storyboard] instantiateViewControllerWithIdentifier:@"RTMPC_Audio_Host"];
        hostVc.liveInfo = self.liveInfo;
        [self.navigationController pushViewController:hostVc animated:YES];
    }
}

- (void)hidesKeyBords{
    self.bottomY.constant = -200;
    [ATCommon hideKeyBoard];
}

#pragma mark - other
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.bottomY.constant = -200;
    [self.typeButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:5];
    [self.modeButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:5];
    [self.directionButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:5];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (LiveInfo *)liveInfo{
    if (!_liveInfo) {
        _liveInfo = [[LiveInfo alloc]init];
        _liveInfo.anyrtcId = [ATCommon randomAnyRTCString:6];
    }
    return _liveInfo;
}

@end

