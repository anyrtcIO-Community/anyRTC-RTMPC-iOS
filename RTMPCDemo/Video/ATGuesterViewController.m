//
//  ATGuesterViewController.m
//  RTMPDemo
//
//  Created by jh on 2017/9/14.
//  Copyright © 2017年 jh. All rights reserved.
//

#import "ATGuesterViewController.h"
#import "ATChatView.h"
#import "ATChatInputView.h"

@interface ATGuesterViewController ()<RTMPCGuestRtmpDelegate,RTMPCGuestRtcDelegate>{
    NSInteger modelInteger; //　模板类型
}

// 聊天窗口
@property (strong, nonatomic) ATChatView *chatView;
// 键盘
@property (nonatomic, strong) ATChatInputView *inputView;
// 聊天窗口高度相对于屏幕的比例
@property (nonatomic, assign) float scaleHeight;
//配置
@property (nonatomic, strong) RTMPCGuestOption *option;

@end

@implementation ATGuesterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (self.liveItem.isLiveLandscape == 1) {
        _scaleHeight = .5;
        modelInteger = 1;
    }else{
        _scaleHeight = .2;
        modelInteger = 0;
    }
    
    [self initUI];
    //实例化游客对象
    [self itializationGuestKit];
}

- (void)itializationGuestKit{
    //初始化配置信息
    self.guestKit = [[RTMPCGuestKit alloc]initWithDelegate:self andOption:self.option];
    //开始RTMP播放
    [self.guestKit startRtmpPlay:self.liveItem.rtmpUrl andRender:self.guestView];
    self.guestKit.rtc_delegate = self;
    
    NSDictionary *customDict = [NSDictionary dictionaryWithObjectsAndKeys:self.gestInfo.userName,@"nickName",self.gestInfo.headUrl,@"headUrl" ,nil];
    NSString *customStr = [ATCommon fromDicToJSONStr:customDict];
    
    [self.guestKit joinRTCLine:self.liveItem.anyrtcId andUserID:self.gestInfo.userId andUserData:customStr];
}

- (void)initUI {
    self.topicLabel.text = self.liveItem.liveTopic;
    self.roomIdLabel.text = [NSString stringWithFormat:@"房间ID：%@",self.liveItem.anyrtcId];
    [self.view insertSubview:self.guestView belowSubview:self.guestBottomView];
    //连麦显示
    self.switchButton.hidden = YES;
    self.videoButton.hidden = YES;
    self.voiceButton.hidden = YES;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEvent:)];
    [self.view addGestureRecognizer:tapGesture];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(getListMembers)];
    [self.listView addGestureRecognizer:tap];
    
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardWillHideNotification object:nil];
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
    NSLog(@"onRTCAudioActive:%@ withUserId:%@ withShowTime:%d",strLivePeerId,strUserId,nTime);
}

- (void)onRTCJoinLineResult:(int)nCode{
    //RTC服务连接结果
    if (nCode==0) {
        self.rtcLabel.text = @"RTC服务链接成功";
    }else{
        self.rtcLabel.text = @"RTC服务链接出错";
    }
}

- (void)onRTCApplyLineResult:(int)nCode{
    //游客申请连麦结果回调
    if (nCode == 0) {
        UIView *videoView = [self getVideoViewWithPubId:Video_MySelf withPeerId:Video_MySelf withNickName:self.gestInfo.userName];
        
        [self.guestBottomView insertSubview:videoView atIndex:0];
        [self.videoArr addObject:videoView];
        [self.guestKit setLocalVideoCapturer:videoView];
        [self.applyButton setBackgroundColor:ATRedColor];
        [self.applyButton setTitle:@"挂断" forState:UIControlStateNormal];
        self.switchButton.hidden = NO;
        self.videoButton.hidden = NO;
        self.voiceButton.hidden = NO;
    } else {
        [self.applyButton setTitle:@"申请连麦" forState:UIControlStateNormal];
        [self.applyButton setBackgroundColor:ATBlueColor];
    }
}

- (void)onRTCHangupLine{
    // 主播挂断游客连麦
    @synchronized(self){
        for (NSInteger i = 0; i < self.videoArr.count; i++) {
            ATVideoView *video = self.videoArr[i];
            if ([video.strPeerId isEqualToString:Video_MySelf]) {
                [self.videoArr removeObjectAtIndex:i];
                [video removeFromSuperview];
                [self layoutVideoView];
                [self.applyButton setTitle:@"申请连麦" forState:UIControlStateNormal];
                [self.applyButton setBackgroundColor:ATBlueColor];
                self.switchButton.hidden = YES;
                self.videoButton.hidden = YES;
                self.voiceButton.hidden = YES;
            }
        }
    }
}

- (void)onRTCLineLeave:(int)nCode{
    //断开RTC服务连接
    if (nCode == 0) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelegate.allowRotation = NO;
        
        if (self.refreshBlock) {
            self.refreshBlock();
        }
        [self.guestKit clear];
        [self dismissViewControllerAnimated:YES completion:nil];
    } else if (nCode == 100){
        //断开
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"网络出现异常" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
}

- (void)onRTCOpenVideoRender:(NSString*)strLivePeerId withRTCPubId:(NSString *)strRTCPubId withUserId:(NSString *)strUserId withUserData:(NSString*)strUserData{
    //其他游客视频连麦接通
    NSDictionary *dict = [ATCommon fromJsonStr:strUserData];
    UIView *videoView = [self getVideoViewWithPubId:strRTCPubId withPeerId:strLivePeerId withNickName:[dict objectForKey:@"nickName"]];
    
    [self.guestBottomView insertSubview:videoView atIndex:0];
    [self.videoArr addObject:videoView];
    [self.guestKit setRTCVideoRender:strRTCPubId andRender:videoView];
}

- (void)onRTCCloseVideoRender:(NSString*)strLivePeerId withRTCPubId:(NSString *)strRTCPubId withUserId:(NSString *)strUserId {
    //其他游客视频连麦挂断
    @synchronized(self.videoArr) {
        for (NSInteger i = 0; i < self.videoArr.count; i++) {
            ATVideoView *video = self.videoArr[i];
            if ([video.strPeerId isEqualToString:strLivePeerId]) {
                [video removeFromSuperview];
                [self.videoArr removeObjectAtIndex:i];
                //更改其它连麦窗口位置
                [self layoutVideoView];
            }
        }
    }
}

- (void)onRTCOpenAudioLine:(NSString*)strLivePeerId withUserId:(NSString *)strUserId withUserData:(NSString*)strUserData{
    //其他游客音频连麦接通
}

- (void)onRTCCloseAudioLine:(NSString*)strLivePeerId withUserId:(NSString *)strUserId {
    //其他游客音频连麦挂断
}

-(void) onRTCViewChanged:(UIView*)videoView didChangeVideoSize:(CGSize)size{
    //视频窗口大小改变
    @synchronized (self.videoArr) {
        for (ATVideoView *atVideoView in self.videoArr) {
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

-(void)onRTCAVStatus:(NSString*) strRTCPeerId withAudio:(BOOL)bAudio withVideo:(BOOL)bVideo {
    NSLog(@"onRTCAVStatus:%@ withAudio:%d withVideo:%d",strRTCPeerId,bAudio,bVideo);
}

#pragma mark - 监听键盘
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

#pragma mark - event
- (IBAction)initiateHangUp:(UIButton *)sender {
    switch (sender.tag) {
        case 100:
            //连麦
            sender.selected = !sender.selected;
            if (sender.selected) {
                if ([self.guestKit applyRTCLine]) {
                    [self.applyButton setTitle:@"取消连麦" forState:UIControlStateNormal];
                    [self.applyButton setBackgroundColor:ATRedColor];
                }
                
            } else {
                if ([ATCommon isStringContains:self.applyButton.titleLabel.text string:@"挂断"]) {
                    self.switchButton.hidden = YES;
                    self.videoButton.hidden = YES;
                    self.voiceButton.hidden = YES;
                    
                    //游客主动挂断
                    for (NSInteger i = 0; i < self.videoArr.count; i++) {
                        ATVideoView *video = self.videoArr[i];
                        if ([video.strPeerId isEqualToString:Video_MySelf]) {
                            [self.videoArr removeObjectAtIndex:i];
                            [video removeFromSuperview];
                            [self layoutVideoView];
                            break;
                        }
                    }
                }
                [self.guestKit hangupRTCLine];
                [self.applyButton setTitle:@"申请连麦" forState:UIControlStateNormal];
                [self.applyButton setBackgroundColor:ATBlueColor];
                
            }
            break;
        case 101:
            //聊天
            [self.inputView beginEditTextField];
            
            break;
        case 102:
            //翻转摄像头
            sender.selected = !sender.selected;
            [self.guestKit switchCamera];
        
            break;
        case 103:
            //视频
            sender.selected = !sender.selected;
            if (sender.selected) {
                [self.guestKit setLocalVideoEnable:NO];
            } else {
                [self.guestKit setLocalVideoEnable:YES];
            }
            
            break;
        case 104:
            //音频
            sender.selected = !sender.selected;
            if (sender.selected) {
                [self.guestKit setLocalAudioEnable:NO];
            } else {
                [self.guestKit setLocalAudioEnable:YES];
            }
            break;
        case 105:
            //关闭
        {
            if (self.guestKit) {
                [self.guestKit clear];
            }
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            appDelegate.allowRotation = NO;
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

- (void)sendMessage:(NSString*)message {
    //发送消息
    [self.inputView editEndTextField];
    ATChatItem *chatItem = [[ATChatItem alloc] init];
    chatItem.strUserId = self.gestInfo.userId;
    chatItem.strNickName = self.gestInfo.userName;
    chatItem.strContact = message;
    chatItem.isHost = NO;
    [self.chatView sendMessage:chatItem];
    [self.guestKit sendUserMessage:0 withUserName:chatItem.strNickName andUserHeader:chatItem.strHeadUrl andContent:chatItem.strContact];
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

#pragma mark - 刷新显示连麦视图
- (UIView *)getVideoViewWithPubId:(NSString *)pubId withPeerId:(NSString*)peerId withNickName:(NSString *)nameStr{
    ATVideoView *videoView = [[[NSBundle mainBundle]loadNibNamed:@"ATVideoView" owner:self options:nil]lastObject];
    videoView.userNameLabel.text = nameStr;
    videoView.frame = CGRectZero;
    if (![pubId isEqualToString:Video_MySelf]) {
        //自己没有挂断其它游客连麦的权限
        videoView.closeButton.hidden = YES;
    } else {
        [videoView addHideTap];
    }
    
    WEAKSELF;
    videoView.removeBlock = ^(ATVideoView *view) {
        [weakSelf.videoArr removeObject:view];
        [view removeFromSuperview];
        if ([view.strPubId isEqualToString:Video_MySelf]) {
            //自己的窗口
            [weakSelf.guestKit hangupRTCLine];
            [weakSelf.applyButton setTitle:@"申请连麦" forState:UIControlStateNormal];
            [weakSelf.applyButton setBackgroundColor:ATBlueColor];
            weakSelf.applyButton.selected = NO;
        }
        
        //更改其它连麦窗口大小
        [weakSelf layoutVideoView];
    };
    videoView.strPeerId = peerId;
    videoView.strPubId = pubId;
    return videoView;
}

// 刷新视频显示坐标
- (void)layoutVideoView {
    
    if (self.videoArr.count==0) {
        self.guestView.frame = self.view.frame;
        return;
    }
    if (modelInteger == 0) {
        // 模板一
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
        
        if (self.videoArr.count ==1) {
            // 左右分屏
            videoWidth = self.view.bounds.size.width/2;
            // 本地窗口3:4的比例
            CGFloat hostViewHeight = 3.0/4.0*videoWidth;
            CGFloat startY = (self.view.bounds.size.height-hostViewHeight)/2;
            self.guestView.frame = CGRectMake(0, startY, videoWidth, hostViewHeight);
            
            // 远程窗口
            ATVideoView *videoView = [self.videoArr firstObject];
            if (videoView.videoSize.width!=0) {
                videoHeight = videoView.videoSize.height/videoView.videoSize.width*videoWidth;
                videoView.frame = CGRectMake(self.view.bounds.size.width/2, (self.view.bounds.size.height-videoHeight)/2, videoWidth, videoHeight);
            }
            //
        }else if (self.videoArr.count == 2){
            // 品格
            videoHeight = self.view.bounds.size.height/2;
            // 本地窗口
            CGFloat hostViewWidth = 4.0/3.0*videoHeight;
            self.guestView.frame = CGRectMake( (self.view.bounds.size.width-hostViewWidth)/2, 0, hostViewWidth, videoHeight);
            
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
            self.guestView.frame = CGRectMake( self.view.bounds.size.width/2-hostViewWidth, self.view.bounds.size.height/2-videoHeight, hostViewWidth, videoHeight);
            
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
}

#pragma mark - 旋转
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.liveItem.isLiveLandscape == 1) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelegate.allowRotation = YES;
        [self toOrientation:UIInterfaceOrientationLandscapeRight];
    }else{
        [self layoutVideoView];
    }
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

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {

        self.guestView.frame = self.view.frame;
    }];
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

#pragma mark - 懒加载
- (NSMutableArray *)videoArr{
    if (!_videoArr) {
        _videoArr = [[NSMutableArray alloc]init];
    }
    return _videoArr;
}

- (UIView *)guestView{
    if (!_guestView) {
        _guestView = [[UIView alloc]initWithFrame:self.view.frame];
    }
    return _guestView;
}

- (RTMPCGuestOption *)option{
    if (!_option) {
        _option = [RTMPCGuestOption defaultOption];
        if (self.liveItem.isLiveLandscape == 1) {
            _option.videoScreenOrientation = RTMPCScreenLandscapeRightType;
        }
    }
    return _option;
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

@end
