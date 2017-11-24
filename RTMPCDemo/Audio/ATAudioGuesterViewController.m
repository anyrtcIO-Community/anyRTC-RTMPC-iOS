//
//  ATAudioGuesterViewController.m
//  RTMPCDemo
//
//  Created by jh on 2017/9/25.
//  Copyright © 2017年 jh. All rights reserved.
//

#import "ATAudioGuesterViewController.h"
#import "ATChatView.h"
#import "ATChatInputView.h"
#import "ATHostVoiceView.h"
#import "ATGuestVoiceView.h"

@interface ATAudioGuesterViewController ()<RTMPCGuestRtmpDelegate,RTMPCGuestRtcDelegate>

// 聊天窗口
@property (strong, nonatomic) ATChatView *chatView;
// 键盘
@property (nonatomic, strong) ATChatInputView *inputView;

// 聊天窗口高度相对于屏幕的比例
@property (nonatomic, assign) float scaleHeight;

// 连麦请求数据
@property (nonatomic, strong) NSMutableArray *lineArray;

// 主播端信息
@property (nonatomic, strong) ATHostVoiceView *hostView;

@end

@implementation ATAudioGuesterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // 如果横屏，先把屏幕给横过来
    if (self.liveItem.isLiveLandscape == 1) {
        self.hostBackImageView.image = [UIImage imageNamed:@"voice_background_lan"];
        _scaleHeight = .5;
    }else{
        self.hostBackImageView.image = [UIImage imageNamed:@"voice_background"];
        _scaleHeight = .2;
    }
    if (SCREEN_HEIGHT>SCREEN_WIDTH) {
        self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }
    
    [self initUI];
    [self setUpInitialization];
    [self registerForKeyboardNotifications];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.liveItem.isLiveLandscape == 1) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelegate.allowRotation = YES;
        [self toOrientation:UIInterfaceOrientationLandscapeRight];
    }else{
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelegate.allowRotation = NO;
        [self toOrientation:UIInterfaceOrientationPortrait];
    }
}

#pragma mark - private method
- (void) registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEvent:)];
    [self.view addGestureRecognizer:tapGesture];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(getListMembers)];
    [self.listView addGestureRecognizer:tap];
}

//初始化
- (void)setUpInitialization{

    self.topicLabel.text = self.liveItem.liveTopic;
    self.roomIdLabel.text = [NSString stringWithFormat:@"房间ID：%@",self.liveItem.anyrtcId];
    
    [self.view insertSubview:self.guestView belowSubview:self.guestBottomView];
    //实例化游客对象
    self.guestAudioKit = [[RTMPCGuestAudioKit alloc]initWithDelegate:self withAudioDetect:YES];
    
    //开始RTMP播放
    [self.guestAudioKit startRtmpPlay:self.liveItem.rtmpUrl];
    self.guestAudioKit.rtc_delegate = self;
    
    NSDictionary *customDict = [NSDictionary dictionaryWithObjectsAndKeys:self.gestInfo.userName,@"nickName",self.gestInfo.headUrl,@"headUrl" ,nil];
    NSString *customStr = [ATCommon fromDicToJSONStr:customDict];
    
    [self.guestAudioKit joinRTCLine:self.liveItem.anyrtcId andUserID:self.gestInfo.userId andUserData:customStr];
    
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
        make.height.equalTo(self.view).multipliedBy(.5);
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

//连麦
- (IBAction)initiateHangUp:(id)sender {
    UIButton *senderButton = (UIButton *)sender;
    switch (senderButton.tag) {
        case 100:
            //连麦
            senderButton.selected = !senderButton.selected;
            if (senderButton.selected) {
                if ([self.guestAudioKit applyRTCLine]) {
                    [self.applyButton setTitle:@"取消连麦" forState:UIControlStateNormal];
                    [self.applyButton setBackgroundColor:ATRedColor];
                }
                
            } else {
                if ([ATCommon isStringContains:self.applyButton.titleLabel.text string:@"挂断"]) {
                    for (NSInteger i = 0; i < self.voiceArr.count; i++) {
                        ATGuestVoiceView *voiceView = self.voiceArr[i];
                        if ([voiceView.strPeerId isEqualToString:Video_MySelf]) {
                            [self.voiceArr removeObjectAtIndex:i];
                            [voiceView removeFromSuperview];
                            [self layoutVoiceView];
                        }
                    }
                }
                [self.guestAudioKit hangupRTCLine];
                [self.applyButton setTitle:@"申请连麦" forState:UIControlStateNormal];
                [self.applyButton setBackgroundColor:ATBlueColor];
            }
            break;
        case 101:
            //聊天
            [self.inputView beginEditTextField];
            
            break;
        case 102:
            //关闭
        {
            if (self.guestAudioKit) {
                [self.guestAudioKit clear];
            }

            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            appDelegate.allowRotation = NO;
            
            [self.applyButton removeFromSuperview];
            self.applyButton = nil;
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
            break;
            
        default:
            break;
    }
}

- (void)getListMembers{
    [self presentViewController:self.listVc animated:YES completion:nil];
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

#pragma mark - RTMPCGuestRtmpDelegate
- (void)onRtmpPlayerOk{
    //RTMP连接成功
    self.rtmpLabel.text = @"RTMP服务链接成功";
}

- (void)onRtmpPlayerStart{
    //RTMP 开始播放
    self.rtmpLabel.text = @"RTMP开始播放";
}

- (void)onRtmpPlayerStatus:(int)nCacheTime withBitrate:(int)nBitrate{
    //RTMP当前播放状态
    self.rtmpLabel.text = [NSString stringWithFormat:@"RTMP缓存时长:%.2fs 当前下行网速:%.2fkb/s",nCacheTime/1000.00,nBitrate/1024.00/8];
}

- (void)onRtmpPlayerLoading:(int)nPercent{
    //RTMP缓冲进度
    self.rtmpLabel.text = @"RTMP缓冲中...";
}

- (void)onRtmpPlayerClosed:(int)nCode{
    //RTMP播放器关闭
    self.rtmpLabel.text = @"RTMP服务关闭";
}

#pragma mark - RTMPCGuestRtcDelegate
- (void)onRTCAudioActive:(NSString *)strLivePeerId withUserId:(NSString *)strUserId withShowTime:(int)nTime{
    //RTC音频检测
    if ([strLivePeerId isEqualToString:@"RTMPC_Hoster"]) {
        if (self.hostView) {
            [self.hostView showAnimation:nTime];
        }
    }else{
        for (ATGuestVoiceView *voiceView in self.voiceArr) {
            if ([strUserId isEqualToString:self.gestInfo.userId] && [voiceView.strPeerId isEqualToString:Video_MySelf]) {
                [voiceView showAnimation:nTime];
                break;
            }
            if ([voiceView.strPeerId isEqualToString:strLivePeerId]) {
                [voiceView showAnimation:nTime];
                break;
            }
        }
    }
    
}

- (void)onRTCJoinLineResult:(int)nCode{
    //RTC服务连接结果
    if (nCode==0) {
        self.rtcLabel.text = @"RTC服务链接成功";
        [self layoutVoiceView];
    }else{
        self.rtcLabel.text = @"RTC服务链接出错";
    }
}

- (void)onRTCApplyLineResult:(int)nCode{
    //游客申请连麦结果回调
    if (nCode == 0) {
        NSDictionary *customDict = [NSDictionary dictionaryWithObjectsAndKeys:self.gestInfo.userName,@"nickName",self.gestInfo.headUrl,@"headUrl" ,nil];
        NSString *customStr = [ATCommon fromDicToJSONStr:customDict];
        UIView *videoView = [self getVideoViewWithPeerId:Video_MySelf withData:customStr];
        [self.view addSubview:videoView];
        [self layoutVoiceView];
        //开始连麦
        [self.applyButton setTitle:@"挂断" forState:UIControlStateNormal];
        [self.applyButton setBackgroundColor:ATRedColor];
    } else {
        [self.applyButton setTitle:@"申请连麦" forState:UIControlStateNormal];
        [self.applyButton setBackgroundColor:ATBlueColor];
    }
}

- (void)onRTCHangupLine{
    // 主播挂断游客连麦
    @synchronized (self) {
        for (NSInteger i = 0; i < self.voiceArr.count; i++) {
            ATGuestVoiceView *voiceView = self.voiceArr[i];
            if ([voiceView.strPeerId isEqualToString:Video_MySelf]) {
                [self.voiceArr removeObjectAtIndex:i];
                [voiceView removeFromSuperview];
                [self layoutVoiceView];
                //结束连麦计时
                //[self.applyButton timeMeterEnd];
                [self.applyButton setBackgroundColor:ATBlueColor];
                break;
            }
        }
        
    }
}

- (void)onRTCLineLeave:(int)nCode{
    //断开RTC服务连接
    if (nCode == 0) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelegate.allowRotation = NO;
        [self dismissViewControllerAnimated:YES completion:nil];
    } else if (nCode == 100){
        //断开
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"网络出现异常" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
}

- (void)onRTCOpenVideoRender:(NSString*)strLivePeerId withUserId:(NSString *)strUserId withUserData:(NSString*)strUserData{
   // 其他游客视频连麦接通
}

- (void)onRTCCloseVideoRender:(NSString*)strLivePeerId withUserId:(NSString *)strUserId{
    //其他游客视频连麦挂断
}

-(void) onRTCViewChanged:(UIView*)videoView didChangeVideoSize:(CGSize)size{
    //视频窗口大小改变
}


- (void)onRTCOpenAudioLine:(NSString*)strLivePeerId withUserId:(NSString *)strUserId withUserData:(NSString*)strUserData{
    //其他游客音频连麦接通
    if (![strLivePeerId isEqualToString:@"RTMPC_Line_Hoster"]) {
        UIView *videoView = [self getVideoViewWithPeerId:strLivePeerId withData:strUserData];
        [self.view addSubview:videoView];
        [self layoutVoiceView];
    }
}

- (void)onRTCCloseAudioLine:(NSString*)strLivePeerId withUserId:(NSString *)strUserId {
    //其他游客音频连麦挂断
    @synchronized (self) {
        if ([strUserId isEqualToString:@"hosterUserId"]) {
            [self.applyButton setTitle:@"申请连麦" forState:UIControlStateNormal];
            [self.applyButton setBackgroundColor:ATBlueColor];
            self.applyButton.selected = NO;
        }
        
        for (NSInteger i = 0; i < self.voiceArr.count; i++) {
            ATGuestVoiceView *voiceView = self.voiceArr[i];
            if ([voiceView.strPeerId isEqualToString:strLivePeerId]) {
                [self.voiceArr removeObjectAtIndex:i];
                [voiceView removeFromSuperview];
                [self layoutVoiceView];
                break;
            }
        }
        
    }
}

- (void)onRTCUserMessage:(int)ntype withUserId:(NSString*)strUserId withUserName:(NSString*)strUserName withUserHeader:(NSString*)strUserHeaderUrl withContent:(NSString*)strContent{
    //收到消息
    ATChatItem *chatItem = [[ATChatItem alloc] init];
    if ([strUserId isEqualToString:@"hosterUserId"]) {
        chatItem.isHost = YES;
    }
    chatItem.strUserId = strUserId;
    chatItem.strNickName = strUserName;
    chatItem.strContact = strContent;
    [self.chatView sendMessage:chatItem];
}

-(void)onRTCMemberListNotify:(NSString*)strServerId withRoomId:(NSString*)strRoomId withAllMember:(int) nTotalMember{
    self.onlineLabel.text = [NSString stringWithFormat:@"%d",nTotalMember];
    //直播间实时在线人数变化
    self.listVc.serverId = strServerId;
    self.listVc.roomId = strRoomId;
    self.listVc.anyrtcId = self.liveItem.anyrtcId;
}

#pragma mark - other
- (NSMutableArray *)voiceArr{
    if (!_voiceArr) {
        _voiceArr = [[NSMutableArray alloc]init];
    }
    return _voiceArr;
}

- (NSMutableArray *)lineArray{
    if (!_lineArray) {
        _lineArray = [[NSMutableArray alloc]init];
    }
    return _lineArray;
}

- (UIView *)guestView{
    if (!_guestView) {
        _guestView = [[UIView alloc]initWithFrame:self.view.frame];
    }
    return _guestView;
}

- (ATHostVoiceView*)hostView {
    if (!_hostView) {
        _hostView = [[[NSBundle mainBundle] loadNibNamed:@"ATHostVoiceView" owner:self options:nil] lastObject];
        _hostView.frame = CGRectZero;
        _hostView.strName = self.liveItem.hosterName;
        [self.view addSubview:_hostView];
    }
    return _hostView;
}

- (ATChatInputView*)inputView {
    if (!_inputView) {
        _inputView = [ATChatInputView new];
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

- (ATListViewController *)listVc{
    if (!_listVc) {
        _listVc = [[ATListViewController alloc]init];
    }
    return _listVc;
}

- (void)sendMessage:(NSString*)message {
    [self.inputView editEndTextField];
    ATChatItem *chatItem = [[ATChatItem alloc] init];
    chatItem.strUserId = self.gestInfo.userId;
    chatItem.strNickName = self.gestInfo.userName;
    chatItem.strContact = message;
    chatItem.isHost = NO;
    [self.chatView sendMessage:chatItem];
    [self.guestAudioKit sendUserMessage:0 withUserName:chatItem.strNickName andUserHeader:chatItem.strHeadUrl andContent:chatItem.strContact];
}

//创建连麦窗口
- (UIView*)getVideoViewWithPeerId:(NSString*)peerId withData:(NSString*)strData {
    
    ATGuestVoiceView *videoView = [[[NSBundle mainBundle]loadNibNamed:@"ATGuestVoiceView" owner:self options:nil]lastObject];
    if (![peerId isEqualToString:Video_MySelf]) {
        videoView.isMySelf = NO;
    }
    WEAKSELF;
    videoView.frame = CGRectZero;
    videoView.removeBlock = ^(ATGuestVoiceView *view) {
        [weakSelf.voiceArr removeObject:view];
        [view removeFromSuperview];
        [weakSelf layoutVoiceView];
        if ([view.strPeerId isEqualToString:Video_MySelf]) {
            //自己的窗口
            [weakSelf.guestAudioKit hangupRTCLine];
            [weakSelf.applyButton setTitle:@"申请连麦" forState:UIControlStateNormal];
            [weakSelf.applyButton setBackgroundColor:ATBlueColor];
            weakSelf.applyButton.selected = NO;
        }
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

// 刷新显示坐标
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

- (BOOL)shouldAutorotate{
    [super shouldAutorotate];
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

@end
