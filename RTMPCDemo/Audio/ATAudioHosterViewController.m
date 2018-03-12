//
//  ATAudioHosterViewController.m
//  RTMPCDemo
//
//  Created by jh on 2017/9/23.
//  Copyright © 2017年 jh. All rights reserved.
//

#import "ATAudioHosterViewController.h"
#import "ATChatView.h"
#import "ATChatInputView.h"
#import "ATLiveInfoView.h"
#import "ATWatchView.h"
#import "ATLineItem.h"

#import "ATHostVoiceView.h"
#import "ATGuestVoiceView.h"

#import "ATLineListViewController.h"

#import <PPBadgeView.h>
#import "ATLivingEndViewController.h"

@interface ATAudioHosterViewController ()<RTMPCHosterRtcDelegate,RTMPCHosterRtmpDelegate>
// 聊天按钮
@property (weak, nonatomic) IBOutlet UIButton *chatButton;
// 连麦请求
@property (weak, nonatomic) IBOutlet UIButton *lineButton;
// 关闭音频
@property (weak, nonatomic) IBOutlet UIButton *voiceButton;
// 关闭按钮
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIImageView *hostBackImageView;

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
// 主播端信息
@property (nonatomic, strong) ATHostVoiceView *hostView;
//开始直播的时间
@property (nonatomic ,assign)int livTime;

@end

@implementation ATAudioHosterViewController
- (void)dealloc {
    
}

// 规则
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
     if (self.liveInfo.isLiveLandscape == 1) {
         AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
         appDelegate.allowRotation = YES;
         [self toOrientation:UIInterfaceOrientationLandscapeRight];
     }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.voiceArr = [[NSMutableArray alloc] init];
    self.lineArray = [[NSMutableArray alloc] init];
    
    self.view.backgroundColor = [UIColor blackColor];
    // 如果横屏，先把屏幕给横过来
    if (self.liveInfo.isLiveLandscape == 1) {
        self.hostBackImageView.image = [UIImage imageNamed:@"voice_background_lan"];
        _scaleHeight = .5;
    }else{
        self.hostBackImageView.image = [UIImage imageNamed:@"voice_background"];
        _scaleHeight = .2;
    }
    if (SCREEN_HEIGHT>SCREEN_WIDTH) {
        self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }
    [self setUpInitialization];
    [self initUI];
    
    [self registerForKeyboardNotifications];
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

- (void)getListMembers{
    [self presentViewController:self.listVc animated:YES completion:nil];
}


- (void)setUpInitialization{
    //实例化主播对象
    self.mHosterAudioKit = [[RTMPCHosterAudioKit alloc] initWithDelegate:self withAudioDetect:YES];
    self.mHosterAudioKit.rtc_delegate = self;
    
    //    self.rtmpUrl = [NSString stringWithFormat:@"%@/%@",PushRtmpServer, self.liveInfo.anyrtcId];
    //    self.rtmpPullUrl = [NSString stringWithFormat:@"%@/%@",PullRtmpServer, self.liveInfo.anyrtcId];
    //    self.hlsUrl = [NSString stringWithFormat:@"%@/%@.m3u8",HlsServer,self.liveInfo.anyrtcId];
    //设置推流地址
    [self.mHosterAudioKit startPushRtmpStream:self.liveInfo.push_url];
    self.mHosterAudioKit.rtc_delegate = self;
    
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
    
    //打开RTC连麦
    if ([self.mHosterAudioKit createRTCLine:self.liveInfo.anyrtcId andUserId:@"hosterUserId" andUserData:jsonDataStr andLiveInfo:jsonLiveStr]) {
        NSLog(@"创建链接成功");
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"打开RTC失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
    NSTimeInterval interval =[[NSDate date] timeIntervalSince1970];
    //记录直播开始时间
    self.livTime = interval;
}

- (void)initUI {
    [self.view addSubview:self.inputView];
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(@49);
        make.bottom.equalTo(self.view).offset(49);
    }];
    
    [self.view addSubview:self.chatView];
    [self.chatView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.bottom.equalTo(self.view).offset(-50);
        make.width.equalTo(self.view).multipliedBy(.6);
        make.height.equalTo(self.view).multipliedBy(_scaleHeight);
    }];
    CGFloat startY;
    if (self.liveInfo.isLiveLandscape) {
        startY = 15;
    }else{
        startY = 25;
    }
    [self.view addSubview:self.liveInfoView];
    [self.liveInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.top.equalTo(self.view).offset(startY);
        make.height.equalTo(@50);
        make.width.equalTo(@160);
    }];
    [self.view addSubview:self.watchView];
    [self.watchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.top.equalTo(self.view).offset(startY);
        make.width.equalTo(@120);
        make.height.equalTo(@50);
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

- (void)layoutVoiceView {
    if (SCREEN_WIDTH>SCREEN_HEIGHT) {
        // 横屏
        //主播的宽高
        float hostWidth = CGRectGetWidth(self.view.frame)/4;
        float hostHeight = hostWidth;
        float hostCentY =  CGRectGetMidY(self.view.frame);
        float hostCentX = CGRectGetMidX(self.view.frame);
        // 游客
        float guestWidth = CGRectGetWidth(self.view.frame)/4;
        float guestHeigh = 1.5*guestWidth;
    
        float startY = CGRectGetMidY(self.view.frame)-hostHeight/2;
      
        switch (self.voiceArr.count) {
            case 0:
            {
                self.hostView.frame = CGRectMake(0, 0, hostWidth, hostHeight);
                self.hostView.center = CGPointMake(hostCentX, hostCentY);
            }
                break;
            case 1:
            {
                // 有一个连麦
                // 主播
                self.hostView.frame = CGRectMake(CGRectGetMidX(self.view.frame)-hostWidth, startY, hostWidth, hostHeight);
               // 游客段
                ATGuestVoiceView *voiceView = [self.voiceArr firstObject];
                voiceView.frame = CGRectMake(CGRectGetMidX(self.view.frame), startY, guestWidth, guestHeigh);
            }
                break;
            case 2:
            {
                // 有二个连麦
                // 主播
                float startX = CGRectGetMidX(self.view.frame)-1.5*hostWidth;
                self.hostView.frame = CGRectMake(startX, startY, hostWidth, hostHeight);
                startX +=hostWidth;
                // 游客段
                for (ATGuestVoiceView *guestView in self.voiceArr) {
                    guestView.frame = CGRectMake(startX, startY, guestWidth, guestHeigh);
                    startX +=guestWidth;
                }
            }
                break;
            case 3:
            {
                // 有三个连麦
                float startX = 0;
                self.hostView.frame = CGRectMake(startX, startY, hostWidth, hostHeight);
                startX +=hostWidth;
                // 游客段
                for (ATGuestVoiceView *guestView in self.voiceArr) {
                    guestView.frame = CGRectMake(startX, startY, guestWidth, guestHeigh);
                    startX +=guestWidth;
                }
            }
                break;
                
            default:
                break;
        }
    }else{
        // 竖屏
        //主播的宽高
        float hostWidth = self.view.bounds.size.width/2;
        float hostHeight = hostWidth;
        float hostCentY =  CGRectGetMidY(self.view.frame) - hostWidth*2/3;
        float hostCentX = CGRectGetMidX(self.view.frame);
 
        // 游客
        float guestWidth = self.view.bounds.size.width/3;
        float guestHeigh = 1.5*guestWidth;
        
        float startY = CGRectGetMaxY(self.hostView.frame)+10;
        float startX = 0;
        // 其他游客
        switch (self.voiceArr.count) {
            case 0:
            {
                self.hostView.frame = CGRectMake(0, 0, hostWidth, hostHeight);
                self.hostView.center = CGPointMake(hostCentX, hostCentY);
                break;
            }
            case 1:
            {
                self.hostView.frame = CGRectMake(0, 0, hostWidth, hostHeight);
                self.hostView.center = CGPointMake(hostCentX, hostCentY);
                
                // 有一个连麦的
                ATGuestVoiceView *voiceView = [self.voiceArr firstObject];
                voiceView.frame = CGRectMake(CGRectGetMidX(self.view.frame)-guestWidth/2, startY, guestWidth, guestHeigh);
                
            }
                break;
            case 2:
            {
                self.hostView.frame = CGRectMake(0, 0, hostWidth, hostHeight);
                self.hostView.center = CGPointMake(hostCentX, hostCentY);
                
                startX = CGRectGetMidX(self.view.frame)-guestWidth;
                // 有两个连麦的
                for (int i=0; i<self.voiceArr.count; i++) {
                    ATGuestVoiceView *voiceView = [self.voiceArr objectAtIndex:i];
                    voiceView.frame = CGRectMake(startX, startY, guestWidth, guestHeigh);
                    startX+=guestHeigh;
                }
            }
                break;
            case 3:
            {
                self.hostView.frame = CGRectMake(0, 0, hostWidth, hostHeight);
                self.hostView.center = CGPointMake(hostCentX, hostCentY);
                // 有三个连麦的
                for (int i=0; i<self.voiceArr.count; i++) {
                    ATGuestVoiceView *voiceView = [self.voiceArr objectAtIndex:i];
                    voiceView.frame = CGRectMake(startX, startY, guestWidth, guestHeigh);
                    startX+=guestHeigh;
                }
            }
                break;
            default:
                break;
        }
        
    }
    [self.view bringSubviewToFront:self.rtcLabel];
    [self.view bringSubviewToFront:self.rtmpLabel];
    [self.view bringSubviewToFront:self.chatView];
    [self.view bringSubviewToFront:self.inputView];
}


- (IBAction)doSomethingEvents:(id)sender {

    UIButton *senderButton = (UIButton*)sender;
    switch (senderButton.tag) {
        case 100:
        {
            if (self.mHosterAudioKit) {
                [self.mHosterAudioKit clear];
            }
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            appDelegate.allowRotation = NO;
            //直播秒数
            NSInteger i = [[NSDate date] timeIntervalSince1970] - self.livTime;
            
            ATLivingEndViewController *liveEndVc = [[ATLivingEndViewController alloc]init];
            liveEndVc.userName = self.liveInfo.userName;
            liveEndVc.livTime = i;
            [self.navigationController pushViewController:liveEndVc animated:YES];
        }
            break;
        case 101:
        {
            // 关闭音频
            senderButton.selected = !senderButton.selected;
            if (senderButton.selected) {
                [self.mHosterAudioKit setLocalAudioEnable:YES];
            } else {
                [self.mHosterAudioKit setLocalAudioEnable:NO];
            }
        }
            break;
        case 102:
        {
            // 连麦请求
            ATLineListViewController *lineController = [[ATLineListViewController alloc] initWithNibName:@"ATLineListViewController" bundle:nil];
            lineController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            __weak typeof(self)weakSelf = self;
            lineController.requestBlock = ^(NSString *strPeerId, BOOL isAgain) {
                if (weakSelf.mHosterAudioKit) {
                    if (isAgain) {
                        // 同意
                        [weakSelf.mHosterAudioKit acceptRTCLine:strPeerId];
                    }else{
                        //　拒绝
                        [weakSelf.mHosterAudioKit rejectRTCLine:strPeerId];
                    }
                    for (ATLineItem *item in weakSelf.lineArray) {
                        if ([item.strPeerId isEqualToString:strPeerId]) {
                            [weakSelf.lineArray removeObject:item];
                            break;
                        }
                    }
                }
                 [weakSelf.lineButton pp_hiddenBadge];
            };
            lineController.dismissBlock = ^{
                [weakSelf.lineButton pp_hiddenBadge];
            };
            [self presentViewController:lineController animated:YES completion:nil];
            [lineController setLineData:self.lineArray];
        }
            break;
        case 103:
        {
            // 聊天
            [self.inputView beginEditTextField];
            
        }
            break;
            
        default:
            break;
    }
 
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
}


#pragma mark -RTMPCHosterRtcDelegate
- (void)onRTCAudioActive:(NSString *)strLivePeerId withUserId:(NSString *)strUserId withShowTime:(int)nTime{
    //音频检测
    if ([strLivePeerId isEqualToString:@"RTMPC_Hoster"]) {
        if (self.hostView) {
            [self.hostView showAnimation:nTime];
        }
    }else{
        for (ATGuestVoiceView *voiceView in self.voiceArr) {
            if ([voiceView.strPeerId isEqualToString:strLivePeerId]) {
                [voiceView showAnimation:nTime];
                break;
            }
        }
    }
}

- (void)onRTCCreateLineResult:(int)nCode{
    // 创建RTC服务连接结果
    if (nCode==0) {
        self.rtcLabel.text = @"RTC服务链接成功";
        [self layoutVoiceView];
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
  
}

- (void)onRTCCloseVideoRender:(NSString*)strLivePeerId withRTCPubId:(NSString *)strRTCPubId withUserId:(NSString *)strUserId{
  
}

- (void)onRTCOpenAudioLine:(NSString*)strLivePeerId withUserId:(NSString *)strUserId withUserData:(NSString*)strUserData{
    // 游客音频连麦接通
    UIView *videoView = [self getVideoViewWithPeerId:strLivePeerId withData:strUserData];
    [self.view addSubview:videoView];
    [self layoutVoiceView];
}

- (void)onRTCCloseAudioLine:(NSString*)strLivePeerId withUserId:(NSString *)strUserId {
    // 游客音频连麦挂断
    @synchronized(self.voiceArr){
        for (int i=0;i<self.voiceArr.count;i++ ) {
            ATVideoView *atVideoView = [self.voiceArr objectAtIndex:i];
            if ([atVideoView.strPeerId isEqualToString:strLivePeerId]) {
                [self.voiceArr removeObjectAtIndex:i];
                [atVideoView removeFromSuperview];
                [self layoutVoiceView];
                break;
            }
        }
    }
}

-(void) onRTCViewChanged:(UIView*)videoView didChangeVideoSize:(CGSize)size {
    @synchronized(self.voiceArr){
        //视频大小改变
        for (ATVideoView *atVideoView in self.voiceArr) {
            if (videoView == atVideoView) {
                atVideoView.videoSize = size;
                [self layoutVoiceView];
                break;
            }
        }
        [self layoutVoiceView];
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

#pragma mark - other
- (ATHostVoiceView*)hostView {
    if (!_hostView) {
        _hostView = [[[NSBundle mainBundle] loadNibNamed:@"ATHostVoiceView" owner:self options:nil] lastObject];
        _hostView.frame = CGRectZero;
        _hostView.strName = self.liveInfo.userName;
        _hostView.strHeadUrl = self.liveInfo.headUrl;
        [self.view addSubview:_hostView];
    }
    return _hostView;
}
//创建连麦窗口
- (UIView*)getVideoViewWithPeerId:(NSString*)peerId withData:(NSString*)strData {
    
    ATGuestVoiceView *videoView = [[[NSBundle mainBundle]loadNibNamed:@"ATGuestVoiceView" owner:self options:nil]lastObject];
    __weak typeof(self)weakSelf = self;
    videoView.frame = CGRectZero;
    videoView.removeBlock = ^(ATGuestVoiceView *view) {
        //主播主动挂断
        [weakSelf.mHosterAudioKit hangupRTCLine:view.strPeerId];
        [weakSelf removeVideoViewFromSuperView:view];
    };
    videoView.strPeerId = peerId;
    if (strData.length>0) {
        NSDictionary *dict = [ATCommon fromJsonStr:strData];
        videoView.strName = [dict objectForKey:@"nickName"];
        videoView.strHeadUrl = [dict objectForKey:@"headUrl"];
    }
    [self.voiceArr addObject:videoView];
    return videoView;
}
- (void)removeVideoViewFromSuperView:(ATGuestVoiceView *)view {
    [self.voiceArr removeObject:view];
    [view removeFromSuperview];
    [self layoutVoiceView];
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

- (void)sendMessage:(NSString*)message {
    if (message.length==0) {
        return;
    }
    ATChatItem *chatItem = [[ATChatItem alloc] init];
    chatItem.strUserId = self.liveInfo.anyrtcId;
    chatItem.strNickName =self.liveInfo.userName;
    chatItem.strContact = message;
    chatItem.isHost = YES;
    [self.chatView sendMessage:chatItem];
    [self.mHosterAudioKit sendUserMessage:0 withUserName:chatItem.strNickName andUserHeader:chatItem.strHeadUrl andContent:chatItem.strContact];
}

-(void)toOrientation:(UIInterfaceOrientation)orientation{
    
    [UIView beginAnimations:nil context:nil];
    
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
    
    // 旋转屏幕
    NSNumber *value = [NSNumber numberWithInt:orientation];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(layoutVoiceView)];
    //开始旋转
    [UIView commitAnimations];
    [self.view layoutIfNeeded];
}

@end
