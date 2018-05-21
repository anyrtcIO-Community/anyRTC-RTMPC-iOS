//
//  ATHosterViewController.m
//  RTMPDemo
//
//  Created by jh on 2017/9/14.
//  Copyright © 2017年 jh. All rights reserved.
//

#import "ATHosterViewController.h"
#import "AppDelegate.h"
#import "ATChatView.h"
#import "ATChatInputView.h"
#import "ATExtendMenuViewController.h"
#import "ATLineListViewController.h"
#import "ATLineItem.h"
#import "ATLiveInfoView.h"
#import "ATWatchView.h"
#import "ATLivingEndViewController.h"
#import <PPBadgeView.h>

@interface ATHosterViewController ()<RTMPCHosterRtcDelegate,RTMPCHosterRtmpDelegate>
{
    NSInteger modelInteger; //　模板类型
}
//美颜
@property (weak, nonatomic) IBOutlet UIButton *beautyButton;

//音频传输
@property (weak, nonatomic) IBOutlet UIButton *voiceButton;
// 视频传输
@property (weak, nonatomic) IBOutlet UIButton *videoButton;

//切换摄像头
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
// 镜像
@property (weak, nonatomic) IBOutlet UIButton *mirrorButton;

@property (weak, nonatomic) IBOutlet UIButton *chatButton;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

//　连麦申请按钮
@property (weak, nonatomic) IBOutlet UIButton *lineButton;
// 模板１
@property (weak, nonatomic) IBOutlet UIButton *videoModelOneButton;
// 模板２
@property (weak, nonatomic) IBOutlet UIButton *videoModelTwoButton;
// 功能按钮
@property (weak, nonatomic) IBOutlet UIButton *functionButton;

// 聊天窗口
@property (strong, nonatomic) ATChatView *chatView;

@property (nonatomic, strong) ATChatInputView *inputView;

// 聊天窗口高度相对于屏幕的比例
@property (nonatomic, assign) float scaleHeight;

// 连麦请求数据
@property (nonatomic, strong) NSMutableArray *lineArray;
// 主播详情信息
@property (nonatomic, strong) ATLiveInfoView *liveInfoView;
// 观看人数
@property (nonatomic, strong) ATWatchView *watchView;
// rtc 链接状态
@property (nonatomic, strong) UILabel *rtcLabel;
// rtmp 链接状态
@property (nonatomic, strong) UILabel *rtmpLabel;
//开始直播的时间
@property (nonatomic, assign) int livTime;

@property (nonatomic, strong) RTMPCHosterOption *option;

@end

@implementation ATHosterViewController
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
// 规则
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    if (self.liveInfo.isLiveLandscape == 1) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelegate.allowRotation = YES;
        [self toOrientation:UIInterfaceOrientationLandscapeRight];
    }
    [self layoutVideoView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.videoArr = [[NSMutableArray alloc] init];
    self.lineArray = [[NSMutableArray alloc] init];
    
    self.view.backgroundColor = [UIColor blackColor];
    // 根据横竖屏来显示哪些东西
    if (self.liveInfo.isLiveLandscape == 1) {
        [self showFunctionWithLandscape:YES];
    }else{
        [self showFunctionWithLandscape:NO];
    }
    [self registerForKeyboardNotifications];
    
    [self setUpInitialization];
    [self initUI];
}

- (void) showFunctionWithLandscape:(BOOL)isLandscape {
    if (isLandscape) {
        _scaleHeight = .5;
        modelInteger = 0;
        self.functionButton.hidden = YES;
    }else{
        _scaleHeight = .3;
        modelInteger = 0;
        self.videoButton.hidden = YES;
        self.voiceButton.hidden = YES;
        self.mirrorButton.hidden = YES;
        self.beautyButton.hidden = YES;
        self.cameraButton.hidden = YES;
        //横屏显示
        self.videoModelTwoButton.hidden = YES;
    }
    self.videoModelOneButton.selected = YES;
}
#pragma mark - private method
- (void) registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEvent:)];
    [self.view addGestureRecognizer:tapGesture];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(getListMembers)];
    [self.watchView addGestureRecognizer:tap];
}

- (void)setUpInitialization{
    //实例化主播对象
    self.mHosterKit = [[RTMPCHosterKit alloc] initWithDelegate:self andOption:self.option];
    self.mHosterKit.rtc_delegate = self;
    [self.mHosterKit setMixVideoModel:RTMPC_LINE_V_1big_3small];
    [self.view sendSubviewToBack:self.hostView];
   
    // 设置水印
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"water" ofType:@"jpg"];
//    if (path) {
//        [self.mHosterKit setVideoRightTopLogo:path andOriginX:30 andOriginY:30];
//    }
    //开启美颜
    [self.mHosterKit setCameraFilter:AnyCameraDeviceFilter_Beautiful];
    
    //设置本地视频采集窗口
    [self.mHosterKit setLocalVideoCapturer:self.hostView];
    
    //设置录像地址（前提在服务上已经开通录像服务），录像地址为拉流地址
    [self.mHosterKit setRtmpRecordUrl:self.liveInfo.pull_url];
    //设置推流地址
    [self.mHosterKit startPushRtmpStream:self.liveInfo.push_url];
    self.mHosterKit.rtc_delegate = self;
    
    // 用户信息
    NSDictionary *userDataDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [NSNumber numberWithInt:1],@"isHost",
                                  [ATCommon randomString:6],@"userId",
                                  self.liveInfo.userName,@"nickName",
                                  self.liveInfo.headUrl,@"headUrl",
                                  nil];
    
    NSString *jsonDataStr = [ATCommon fromDicToJSONStr:userDataDict];
    
    /**
     *  加载相关数据(大厅列表解析数据对应即可)
     */
    NSDictionary *liveDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              self.liveInfo.pull_url,@"rtmpUrl",
                              self.liveInfo.hls_url,@"hlsUrl",
                              self.liveInfo.anyrtcId,@"anyrtcId",
                              self.liveInfo.liveTopic,@"liveTopic",
                              [NSNumber numberWithInt:self.liveInfo.isLiveLandscape],@"isLiveLandscape",
                              [NSNumber numberWithInt:self.liveInfo.isAudioLive],@"isAudioLive",self.liveInfo.userName,@"hosterName",
                              nil];
   NSString *jsonLiveStr = [ATCommon fromDicToJSONStr:liveDict];
    
    //创建RTC连麦
    if ([self.mHosterKit createRTCLine:self.liveInfo.anyrtcId andUserId:@"hosterUserId" andUserData:jsonDataStr andLiveInfo:jsonLiveStr]) {
        NSLog(@"创建链接成功");
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"创建链接失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
    NSTimeInterval interval =[[NSDate date] timeIntervalSince1970];
    //记录直播开始时间
    self.livTime = interval;
}

- (void)initUI {
    self.beautyButton.selected = YES;
    [self.view addSubview:self.inputView];
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(@49);
        make.bottom.equalTo(self.view).offset(49);
    }];
    CGFloat startY;
    if (self.liveInfo.isLiveLandscape) {
        startY = 15;
    }else{
        startY = 25;
    }
    [self.view addSubview:self.chatView];
    [self.chatView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.bottom.equalTo(self.view).offset(-50);
        make.width.equalTo(self.view).multipliedBy(.6);
        make.height.equalTo(self.view).multipliedBy(_scaleHeight);
    }];
    
    [self.view addSubview:self.liveInfoView];
    [self.liveInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.top.equalTo(self.view).offset(startY);
        make.height.equalTo(@44);
        make.width.equalTo(@160);
    }];
    [self.view addSubview:self.watchView];
    [self.watchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.top.equalTo(self.view).offset(startY);
        make.width.equalTo(@120);
        make.height.equalTo(@44);
    }];
    
    [self.view addSubview:self.rtcLabel];
    [self.rtcLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.top.equalTo(self.liveInfoView.mas_bottom).offset(15);
    }];
    
    [self.view addSubview:self.rtmpLabel];
    [self.rtmpLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.top.equalTo(self.rtcLabel.mas_bottom).offset(5);
    }];
}

// 键盘弹起
- (void)keyboardWasShown:(NSNotification*)notification {
    NSDictionary *info = [notification userInfo];
    CGSize kbSize=[[info objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue].size;
    NSTimeInterval animationDuration;
    [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [UIView animateWithDuration:animationDuration animations:^{
        [self.inputView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.height.equalTo(@49);
            make.bottom.equalTo(self.view.mas_bottom).offset(-kbSize.height);
        }];
        [self.chatView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(10);
            make.bottom.equalTo(self.view).offset(-(50+kbSize.height));
            make.width.equalTo(self.view).multipliedBy(.6);
            make.height.equalTo(self.view).multipliedBy(_scaleHeight);
        }];
         [self.view layoutIfNeeded];  //
    }];
  
}
// 键盘隐藏
- (void)keyboardWasHidden:(NSNotification*)notification {
    NSDictionary *info = [notification userInfo];
    NSTimeInterval animationDuration;
    [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [UIView animateWithDuration:animationDuration animations:^{
        [self.inputView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.height.equalTo(@49);
            make.bottom.equalTo(self.view.mas_bottom).offset(49);
        }];
        [self.chatView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(10);
            make.bottom.equalTo(self.view).offset(-50);
            make.width.equalTo(self.view).multipliedBy(.6);
            make.height.equalTo(self.view).multipliedBy(_scaleHeight);
        }];
        [self.view layoutIfNeeded];
    }];
}
- (void)tapEvent:(UITapGestureRecognizer*)recognizer {
    CGPoint point = [recognizer locationInView:self.view];
    CGRect rect = [self.view convertRect:self.inputView.frame toView:self.view];
    // 键盘下去
    if (!CGRectContainsPoint(rect, point)) {
        if (self.inputView.isEditing) {
            [self.inputView editEndTextField];
        }
    }
}

- (void)getListMembers{
    [self presentViewController:self.listVc animated:YES completion:nil];
}


- (IBAction)doSomethingEvents:(UIButton *)senderButton {
 
    switch (senderButton.tag) {
        case 100:
            //关闭直播
        {
            if (self.mHosterKit) {
                [self.mHosterKit clear];
            }
            
            //直播秒数
            NSInteger i = [[NSDate date] timeIntervalSince1970] - self.livTime;
            
            ATLivingEndViewController *liveEndVc = [[ATLivingEndViewController alloc]init];
            liveEndVc.userName = self.liveInfo.userName;
            liveEndVc.livTime = i;
            [self.navigationController pushViewController:liveEndVc animated:YES];
        }
            break;
        case 101:
            //美颜
            senderButton.selected = !senderButton.selected;
            if (senderButton.selected) {
                [self.mHosterKit setCameraFilter:AnyCameraDeviceFilter_Beautiful];
            }else{
                 [self.mHosterKit setCameraFilter:AnyCameraDeviceFilter_Original];
            }
            break;
        case 102:
            //音频
            senderButton.selected = !senderButton.selected;
            if (senderButton.selected) {
                [self.mHosterKit setLocalAudioEnable:NO];
            } else {
                [self.mHosterKit setLocalAudioEnable:YES];
            }
            break;
        case 103:
            //切换摄像头
            [self.mHosterKit switchCamera];
            break;
        case 104:
        {
            // 聊天
            [self.inputView beginEditTextField];
           
        }
            break;
        case 105:
        {
            // 视频传输
            senderButton.selected = !senderButton.selected;
            [self.mHosterKit setLocalVideoEnable:!senderButton.selected];
        }
            break;
        case 106:
        {
            // 镜像
            senderButton.selected = !senderButton.selected;
            [self.mHosterKit setFontCameraMirrorEnable:!senderButton.selected];
        }
            break;
        case 200:
        {
            // 连麦请求
            ATLineListViewController *lineController = [[ATLineListViewController alloc] initWithNibName:@"ATLineListViewController" bundle:nil];
            lineController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            __weak typeof(self)weakSelf = self;
            lineController.requestBlock = ^(NSString *strPeerId, BOOL isAgain) {
                if (weakSelf.mHosterKit) {
                    if (isAgain) {
                        // 同意
                        [weakSelf.mHosterKit acceptRTCLine:strPeerId];
                    }else{
                        //　拒绝
                        [weakSelf.mHosterKit rejectRTCLine:strPeerId];
                    }
                    for (ATLineItem *item in weakSelf.lineArray) {
                        if ([item.strPeerId isEqualToString:strPeerId]) {
                            [weakSelf.lineArray removeObject:item];
                            break;
                        }
                    }
                    [weakSelf.lineButton pp_hiddenBadge];
                }
            };
            
            lineController.dismissBlock = ^{
                [weakSelf.lineButton pp_hiddenBadge];
            };
            
            [self presentViewController:lineController animated:YES completion:nil];
            [lineController setLineData:self.lineArray];
        }
            break;
        case 201:
        {
            // 模板１
            self.videoModelOneButton.selected = YES;
            self.videoModelTwoButton.selected = NO;
            modelInteger = 0;
            [self layoutVideoView];
            if (self.mHosterKit) {
                [self.mHosterKit setMixVideoModel:RTMPC_LINE_V_Fullscrn];
              //  [self.mHosterKit setVideoTemplate:RTMPC_V_T_HOR_RIGHT temVer:RTMPC_V_T_VER_BOTTOM temDir:RTMPC_V_T_DIR_VER padhor:10 padver:10];
            }
        }
            break;
        case 202:
        {
            // 模板2
            self.videoModelOneButton.selected = NO;
            self.videoModelTwoButton.selected = YES;
            modelInteger = 1;
            [self layoutVideoView];
           //    [self.mHosterKit setVideoTemplate:RTMPC_V_T_HOR_CENTER temVer:RTMPC_V_T_VER_CENTER temDir:RTMPC_V_T_DIR_HOR padhor:0 padver:0];
        }
            break;
        case 203:
        {
           //  功能
            ATExtendMenuViewController *extendMenu = [[ATExtendMenuViewController alloc] initWithNibName:@"ATExtendMenuViewController" bundle:nil];
            extendMenu.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            __weak typeof(self)weakSelf = self;
            extendMenu.menuTapBlock = ^(ExtendMenuType type,BOOL isSelected) {
                switch (type) {
                    case ExtendMenuTypeSwitchCamera:
                    {
                        if (weakSelf.mHosterKit) {
                            [weakSelf.mHosterKit switchCamera];
                        }
                    }
                        break;
                    case ExtendMenuTypeBeautyCamera:
                    {
                        if (weakSelf.mHosterKit) {
                            if (isSelected) {
                                 [weakSelf.mHosterKit setCameraFilter:AnyCameraDeviceFilter_Beautiful];
                            }else{
                                [weakSelf.mHosterKit setCameraFilter:AnyCameraDeviceFilter_Original];
                            }
                        }
                    }
                        break;
                    case ExtendMenuTypeCloseVideo:
                    {
                        if (weakSelf.mHosterKit) {
                            [weakSelf.mHosterKit setLocalVideoEnable:!isSelected];
                        }
                    }
                        break;
                    case ExtendMenuTypeCloseAudio:
                    {
                        if (weakSelf.mHosterKit) {
                            [weakSelf.mHosterKit setLocalAudioEnable:!isSelected];
                        }
                    }
                        break;
                        
                    default:
                        break;
                }
            };
            [self presentViewController:extendMenu animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
    
}
// 刷新视频显示坐标
- (void)layoutVideoView {
    
    if (self.videoArr.count==0) {
        self.hostView.frame = self.view.frame;
        return;
    }
    
    if (modelInteger == 0) {
        // 模板一
        
        self.hostView.frame = self.view.frame;
        
        float videoY = 0;
        float videoHeight = 0;
        
        videoHeight = self.view.bounds.size.height/4;
        videoY = videoHeight/2;
        for (ATVideoView *videoView in self.videoArr) {
            // 根据视频分辨率得到宽度
            if (videoView.videoSize.width!=0) {
                CGFloat videoWidth = videoView.videoSize.width/videoView.videoSize.height*videoHeight;
                videoView.frame = CGRectMake(self.view.bounds.size.width-videoWidth, self.view.bounds.size.height-videoHeight-videoY, videoWidth, videoHeight);
                videoY = videoY + videoHeight;
            }
        }
    }else{
        // 模板二（只有横屏的时候有，竖屏没有模板）
        float videoWidth = 0;
        float videoHeight = 0;
        
        [self.mHosterKit setMixVideoModel:RTMPC_LINE_V_1_equal_others];
        
        if (self.videoArr.count ==1) {
            // 左右分屏
            videoWidth = self.view.bounds.size.width/2;
            // 本地窗口3:4的比例
            CGFloat hostViewHeight = 3.0/4.0*videoWidth;
            CGFloat startY = (self.view.bounds.size.height-hostViewHeight)/2;
            self.hostView.frame = CGRectMake(0, startY, videoWidth, hostViewHeight);
           
            // 远程窗口
            ATVideoView *videoView = [self.videoArr firstObject];
            if (videoView.videoSize.width!=0) {
                 videoHeight = videoView.videoSize.height/videoView.videoSize.width*videoWidth;
                videoView.frame = CGRectMake(self.view.bounds.size.width/2, (self.view.bounds.size.height-videoHeight)/2, videoWidth, videoHeight);
            }
        }else if (self.videoArr.count == 2){
            // 品格
            videoHeight = self.view.bounds.size.height/2;
            // 本地窗口
             CGFloat hostViewWidth = 4.0/3.0*videoHeight;
             self.hostView.frame = CGRectMake( (self.view.bounds.size.width-hostViewWidth)/2, 0, hostViewWidth, videoHeight);
            
            int startInt = 0;
            // 远程窗口
            for (ATVideoView *videoView in self.videoArr) {
                if (videoView.videoSize.width!=0) {
                    videoWidth = videoView.videoSize.width/videoView.videoSize.height*videoHeight;
                    if (startInt == 0) {
                           videoView.frame = CGRectMake(self.view.bounds.size.width/2-videoWidth, self.view.bounds.size.height/2, videoWidth, videoHeight);
                    }else{
                           videoView.frame = CGRectMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2, videoWidth, videoHeight);
                    }
                    startInt = startInt + 1;
                    
                }
            }
            
        }else if (self.videoArr.count == 3){
            // 田字形
            videoHeight = self.view.bounds.size.height/2;
            // 本地窗口
            CGFloat hostViewWidth = 4.0/3.0*videoHeight;
            self.hostView.frame = CGRectMake( self.view.bounds.size.width/2-hostViewWidth, self.view.bounds.size.height/2-videoHeight, hostViewWidth, videoHeight);
            
            int startInt = 0;
            // 远程窗口
            for (ATVideoView *videoView in self.videoArr) {
                if (videoView.videoSize.width!=0) {
                    videoWidth = videoView.videoSize.width/videoView.videoSize.height*videoHeight;
                    if (startInt == 0) {
                        videoView.frame = CGRectMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2-videoHeight, videoWidth, videoHeight);
                    }else if (startInt ==1) {
                        videoView.frame = CGRectMake(self.view.bounds.size.width/2-videoWidth, self.view.bounds.size.height/2, videoWidth, videoHeight);
                    }else if (startInt ==2){
                         videoView.frame = CGRectMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2, videoWidth, videoHeight);
                    }
                    startInt ++;
                }
            }
        }
    }
    
    //　把工具栏放到最上层
    [self.view bringSubviewToFront:self.chatView];
    
    [self.view bringSubviewToFront:self.liveInfoView];
    [self.view bringSubviewToFront:self.watchView];
    
    [self.view bringSubviewToFront:self.rtcLabel];
    [self.view bringSubviewToFront:self.rtmpLabel];
    
    [self.view bringSubviewToFront:self.chatButton];
    [self.view bringSubviewToFront:self.lineButton];
    [self.view bringSubviewToFront:self.videoModelOneButton];
    [self.view bringSubviewToFront:self.videoModelTwoButton];
    [self.view bringSubviewToFront:self.mirrorButton];
    [self.view bringSubviewToFront:self.beautyButton];
    [self.view bringSubviewToFront:self.cameraButton];
    [self.view bringSubviewToFront:self.videoButton];
    [self.view bringSubviewToFront:self.voiceButton];
    [self.view bringSubviewToFront:self.closeButton];
    [self.view bringSubviewToFront:self.functionButton];
}

#pragma mark - RTMPCHosterRtmpDelegate
- (void)onRtmpStreamOk{
    //RTMP 服务连接成功
    self.rtmpLabel.text = @"RTMP服务链接成功";
}

- (void)onRtmpStreamReconnecting:(int)nTimes{
    //RTMP 服务重连
    self.rtmpLabel.text = [NSString stringWithFormat:@"RTMP服务第%d次重连中...",nTimes];
}

- (void)onRtmpStreamStatus:(int)nDelayTime withNetBand:(int)nNetBand{
    //RTMP 推流状态
    self.rtmpLabel.text = [NSString stringWithFormat:@"RTMP延迟:%.2fs 当前上传网速:%.2fkb/s",nDelayTime/1000.00,nNetBand/1024.00/8];
}

- (void)onRtmpStreamFailed:(int)nCode{
    //RTMP 服务连接失败
    self.rtmpLabel.text = @"RTMP服务连接失败";
}

- (void)onRtmpStreamClosed{
    //RTMP 服务关闭
    self.rtmpLabel.text = @"RTMP服务关闭";
}

- (void)cameraSourceDidGetPixelBuffer:(CMSampleBufferRef)sampleBuffer{
    //获取视频原始采集数据（必须在RTMPCHybirdEngineKit　中调用useThreeCameraFilterSdk方法，该回调才有用）
    CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    [self.mHosterKit capturePixelBuffer:pixelBuffer];
}

#pragma mark -RTMPCHosterRtcDelegate
- (void)onRTCAudioActive:(NSString *)strLivePeerId withUserId:(NSString *)strUserId withShowTime:(int)nTime{
    //音频检测
  // NSLog(@"onRTCAudioActive:%@ withUserId:%@ withShowTime:%d",strLivePeerId,strUserId,nTime);
}

- (void)onRTCCreateLineResult:(int)nCode{
    // 创建RTC服务连接结果
    if (nCode==0) {
        self.rtcLabel.text = @"RTC服务链接成功";
    }else{
        self.rtcLabel.text = @"RTC服务链接出错";
    }
}

- (void)onRTCApplyToLine:(NSString*)strLivePeerId withUserId:(NSString*)strUserId withUserData:(NSString*)strUserData{
    
    ATLineItem *lineItem = [[ATLineItem alloc] init];
    lineItem.strPeerId = strLivePeerId;
    lineItem.strUserId = strUserId;
    lineItem.strUserData = strUserData;
    
    [self.lineArray addObject:lineItem];
    // 发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LineNumChangeNotification" object:self.lineArray];
    [self.lineButton pp_addDotWithColor:nil];
    [self.lineButton pp_setBadgeHeightPoints:5];
    [self.lineButton pp_moveBadgeWithX:-8 Y:8];
    [self.lineButton pp_showBadge];
}

- (void)onRTCCancelLine:(int)nCode withLivePeerId:(NSString *)strLivePeerId{
    //游客取消连麦申请或者连麦数已满
    if (nCode == 0) {
        for (ATLineItem *item in self.lineArray) {
            if ([item.strPeerId isEqualToString:strLivePeerId]) {
                [self.lineArray removeObject:item];
                break;
            }
        }
    }

}

- (void)onRTCLineClosed:(int)nCode{
    //RTC 服务关闭
    self.rtcLabel.text = @"RTC服务关闭";
}

- (void)onRTCOpenVideoRender:(NSString*)strLivePeerId withRTCPubId:(NSString *)strRTCPubId withUserId:(NSString *)strUserId withUserData:(NSString*)strUserData{
    
    //游客连麦视频接通
    NSDictionary *dict = [ATCommon fromJsonStr:strUserData];

    UIView *videoView = [self getVideoViewWithPubId:strRTCPubId WithPeerId:strLivePeerId withNickName:[dict objectForKey:@"nickName"]];
    [self.view addSubview:videoView];
    [self.mHosterKit setRTCVideoRender:strRTCPubId andRender:videoView];
    [self layoutVideoView];
}

- (void)onRTCCloseVideoRender:(NSString*)strLivePeerId withRTCPubId:(NSString *)strRTCPubId withUserId:(NSString *)strUserId{
    //游客连麦视频挂断
    @synchronized(self.videoArr){
        for (int i=0;i<self.videoArr.count;i++) {
             ATVideoView *atVideoView = [self.videoArr objectAtIndex:i];
            if ([atVideoView.strPubId isEqualToString:strRTCPubId]) {
                [self.videoArr removeObject:atVideoView];
                [atVideoView removeFromSuperview];
                [self layoutVideoView];
                break;
            }
        }
    }
}

- (void)onRTCOpenAudioLine:(NSString*)strLivePeerId withUserId:(NSString *)strUserId withUserData:(NSString*)strUserData{
    // 游客音频连麦接通

}

- (void)onRTCCloseAudioLine:(NSString*)strLivePeerId withUserId:(NSString *)strUserId {
    // 游客音频连麦挂断
}

-(void) onRTCViewChanged:(UIView*)videoView didChangeVideoSize:(CGSize)size {
    @synchronized(self.videoArr){
        //视频大小改变
        for (int i=0;i<self.videoArr.count;i++) {
            ATVideoView *atVideoView = [self.videoArr objectAtIndex:i];
            if (videoView == atVideoView) {
                atVideoView.videoSize = size;
                [self layoutVideoView];
                break;
            }
        }
        [self layoutVideoView];
    }
}

- (void)onRTCUserMessage:(int)ntype withUserId:(NSString*)strUserId withUserName:(NSString*)strUserName withUserHeader:(NSString*)strUserHeaderUrl withContent:(NSString*)strContent{
    //收到消息
    ATChatItem *chatItem = [[ATChatItem alloc] init];
    chatItem.strUserId = strUserId;
    chatItem.strNickName = strUserName;
    chatItem.strContact = strContent;
    [self.chatView sendMessage:chatItem];
}

- (void)onRTCMemberListNotify:(NSString *)strServerId withRoomId:(NSString *)strRoomId withAllMember:(int)nTotalMember{
    if (self.watchView) {
        self.watchView.atNumLabel.text = [NSString stringWithFormat:@"%d",nTotalMember];
    }
    //人员更新
    self.listVc.serverId = strServerId;
    self.listVc.roomId = strRoomId;
    self.listVc.anyrtcId = self.liveInfo.anyrtcId;
}
-(void)onRTCAVStatus:(NSString*) strRTCPeerId withAudio:(BOOL)bAudio withVideo:(BOOL)bVideo {
    NSLog(@"onRTCAVStatus:%@ withAudio:%d withVideo:%d",strRTCPeerId,bAudio,bVideo);
}

#pragma mark - other
- (UIView *)hostView {
    if (!_hostView) {
        _hostView = [[UIView alloc] initWithFrame:self.view.frame];
        [self.view addSubview:_hostView];
        _hostView.backgroundColor = [UIColor blackColor];
    }
    return _hostView;
}

//创建连麦窗口
- (UIView *)getVideoViewWithPubId:(NSString *)pubId WithPeerId:(NSString*)peerId withNickName:(NSString *)nameStr{
    ATVideoView *videoView = [[[NSBundle mainBundle]loadNibNamed:@"ATVideoView" owner:self options:nil]lastObject];
    videoView.userNameLabel.text = nameStr;
    [videoView addHideTap];
    __weak typeof(self)weakSelf = self;
    videoView.frame = CGRectZero;
    videoView.removeBlock = ^(ATVideoView *view) {
        [weakSelf.mHosterKit hangupRTCLine:view.strPeerId];
        [weakSelf removeVideoViewFromSuperView:view];
    };
    videoView.strPeerId = peerId;
    videoView.strPubId = pubId;
    [self.videoArr addObject:videoView];
    return videoView;
}
- (void)removeVideoViewFromSuperView:(ATVideoView *)view {
    [self.videoArr removeObject:view];
    [view removeFromSuperview];
    [self.mHosterKit hangupRTCLine:view.strPeerId];
    [self layoutVideoView];
}
- (ATChatInputView*)inputView {
    if (!_inputView) {
        _inputView = [ATChatInputView new];
        _inputView.backgroundColor = [UIColor whiteColor];
        __weak typeof(self)weakSelf = self;
        _inputView.sendBlock = ^(NSString *message) {
            [weakSelf sendMessage:message];
        };
    }
    return _inputView;
}
- (ATChatView*)chatView {
    if (!_chatView) {
        _chatView = [ATChatView new];
    }
    return _chatView;
}
- (ATLiveInfoView *)liveInfoView {
    if (!_liveInfoView){
        _liveInfoView = [ATLiveInfoView new];
        _liveInfoView.atTitleLabel.text = self.liveInfo.liveTopic;
        _liveInfoView.atIdLabel.text = [NSString stringWithFormat:@"房间ID：%@",self.liveInfo.anyrtcId];
    }
    return _liveInfoView;
}

- (ATWatchView*)watchView {
    if (!_watchView) {
        _watchView = [ATWatchView new];
    }
    return _watchView;
}

- (ATListViewController *)listVc{
    if (!_listVc) {
        _listVc = [[ATListViewController alloc]init];
    }
    return _listVc;
}

- (UILabel*)rtcLabel {
    if (!_rtcLabel) {
        _rtcLabel = [UILabel new];
        _rtcLabel.font = [UIFont systemFontOfSize:14];
        _rtcLabel.textColor = [ATCommon getColor:@"#31d788"];
    }
    return _rtcLabel;
}

- (UILabel*)rtmpLabel {
    if (!_rtmpLabel) {
        _rtmpLabel = [UILabel new];
        _rtmpLabel.font = [UIFont systemFontOfSize:14];
        _rtmpLabel.textColor = [ATCommon getColor:@"#ef504f"];
    }
    return _rtmpLabel;
}

//配置信息
- (RTMPCHosterOption *)option{
    if (!_option) {
        _option = [RTMPCHosterOption defaultOption];
        if (self.liveInfo.isLiveLandscape == 1) {
            //视频方向
            _option.videoScreenOrientation = RTMPCScreenLandscapeRightType;
        } else {
           _option.videoScreenOrientation = RTMPCScreenPortraitType;
        }
        //设置视频推流质量  RTMPC_Video_SD
        if ([self.liveInfo.videoMode isEqualToString:@"顺畅"]) {
            _option.videoMode = RTMPC_Video_Low;
        } else if ([self.liveInfo.videoMode isEqualToString:@"标清"]) {
            _option.videoMode = RTMPC_Video_SD;
        } else {
            //高清
            _option.videoMode = RTMPC_Video_720P;
        }
        //相机类型
        _option.cameraType = RTMPCCameraTypeBeauty;
    }
    return _option;
}

- (void)sendMessage:(NSString*)message {
    if (message.length == 0) {
        return;
    }
    ATChatItem *chatItem = [[ATChatItem alloc] init];
    chatItem.strUserId = self.liveInfo.anyrtcId;
    chatItem.strNickName =self.liveInfo.userName;
    chatItem.strContact = message;
    chatItem.isHost = YES;
    [self.chatView sendMessage:chatItem];
    [self.mHosterKit sendUserMessage:0 withUserName:chatItem.strNickName andUserHeader:chatItem.strHeadUrl andContent:chatItem.strContact];
}

-(void)toOrientation:(UIInterfaceOrientation)orientation{
    
    [UIView beginAnimations:nil context:nil];
    
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
    
    // 旋转屏幕
    NSNumber *value = [NSNumber numberWithInt:orientation];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(layoutVideoView)];
    //开始旋转
    [UIView commitAnimations];
    [self.view layoutIfNeeded];
}

@end
