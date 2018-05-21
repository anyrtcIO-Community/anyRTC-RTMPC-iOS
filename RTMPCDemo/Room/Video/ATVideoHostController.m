//
//  ATVideoHostController.m
//  RTMPCDemo
//
//  Created by jh on 2018/4/11.
//  Copyright © 2018年 jh. All rights reserved.
//

#import "ATVideoHostController.h"

@interface ATVideoHostController ()<RTMPCHosterRtcDelegate,RTMPCHosterRtmpDelegate,HangUpDelegate>

@property (weak, nonatomic) IBOutlet UILabel *rtcLabel;       //RTC状态

@property (weak, nonatomic) IBOutlet UILabel *rtmpLabel;      //RTMP状态

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *padding; //横竖屏间距

@property (weak, nonatomic) IBOutlet UILabel *topicLabel;     //房间名

@property (weak, nonatomic) IBOutlet UILabel *roomIdLabel;    //房间号

@property (weak, nonatomic) IBOutlet UILabel *onlineLabel;    //在线人员

@property (weak, nonatomic) IBOutlet UIButton *functionButton;//功能

@property (weak, nonatomic) IBOutlet UIView *listView;       //在线人员

@property (weak, nonatomic) IBOutlet UIView *barrageView;    //弹幕渲染

@property (weak, nonatomic) IBOutlet UIButton *beautyButton;  //美颜

@property (weak, nonatomic) IBOutlet UIView *containerView;  //容器

@property (weak, nonatomic) IBOutlet UIView *localView;

@property (weak, nonatomic) IBOutlet UIView *barrageButton;  //消息控制器

@property(nonatomic ,strong) RTMPCHosterKit *mHosterKit;

@property (nonatomic, strong) ATMenuViewController *menuVc;     //竖屏菜单

@property(nonatomic ,strong) NSMutableArray *micArr;    //连麦请求

@property (nonatomic, assign) int liveTime;     //开始直播的时间

@end

@implementation ATVideoHostController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.topicLabel.text = self.liveInfo.liveTopic;
    self.roomIdLabel.text = [NSString stringWithFormat:@"房间ID：%@",self.liveInfo.anyrtcId];
    self.micArr = [NSMutableArray arrayWithCapacity:4];
    self.beautyButton.selected = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(getMemberList)];
    [self.listView addGestureRecognizer:tap];
    
    //初始化RTMPC
    [self setUpInitialization];
    
    if (self.liveInfo.isLiveLandscape == 1) {
        //横屏
        [self orientationRotating: UIInterfaceOrientationLandscapeLeft];
        self.functionButton.hidden = YES;
        [self.barrageView addSubview:self.renderer.view];
    } else {
        self.padding.constant = - MAXFLOAT;
        self.functionButton.hidden = NO;
        [self.view insertSubview:self.infoView aboveSubview:self.barrageView];
    }
    //记录直播开始时间
    NSTimeInterval interval =[[NSDate date] timeIntervalSince1970];
    self.liveTime = interval;
}

- (void)setUpInitialization{
    
    RTMPCHosterOption *option = [RTMPCHosterOption defaultOption];
    option.cameraType = RTMPCCameraTypeBeauty;
    
    (self.liveInfo.isLiveLandscape == 1) ? (option.videoScreenOrientation = RTMPCScreenLandscapeRightType) : 0;
    
    if ([self.liveInfo.videoMode isEqualToString:@"顺畅"]) {
        option.videoMode = RTMPC_Video_Low;
    } else if ([self.liveInfo.videoMode isEqualToString:@"高清"]) {
        option.videoMode = RTMPC_Video_720P;
    }
    
    //实例化主播对象
    self.mHosterKit = [[RTMPCHosterKit alloc] initWithDelegate:self andOption:option];
    self.mHosterKit.rtc_delegate = self;

    //设置本地视频采集窗口
    [self.mHosterKit setLocalVideoCapturer:self.localView];
    [self.mHosterKit setRtmpRecordUrl:self.liveInfo.pull_url];
    [self.videoArr addObject:self.localView];
    
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
    if (![self.mHosterKit createRTCLine:self.liveInfo.anyrtcId andUserId:@"hosterUserId" andUserData:jsonDataStr andLiveInfo:jsonLiveStr]) {
        [XHToast showCenterWithText:@"创建RTC失败"];
    }
}

- (IBAction)doSomethingEvents:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    switch (sender.tag) {
        case 100:
            //消息
            [self.messageTextField becomeFirstResponder];
            break;
        case 101:
        {
            //连麦列表
            ATRealTimeMicController *micVc = [[self storyboard] instantiateViewControllerWithIdentifier:@"RTMPC_RealTimeMic"];
            micVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            micVc.micArr = self.micArr;
            micVc.mHosterKit = self.mHosterKit;
            [self presentViewController:micVc animated:YES completion:nil];
        }
            break;
        case 104:
            //镜像
            [self.mHosterKit setFontCameraMirrorEnable:!sender.selected];
            break;
        case 105:
            //美颜
            if (sender.selected) {
                [self.mHosterKit setCameraFilter:AnyCameraDeviceFilter_Beautiful];
            }else{
                [self.mHosterKit setCameraFilter:AnyCameraDeviceFilter_Original];
            }
            break;
        case 106:
            //翻转摄像头
            [self.mHosterKit switchCamera];
            break;
        case 107:
            //视频
            [self.mHosterKit setLocalVideoEnable:!sender.selected];
            break;
        case 108:
            //音频
            [self.mHosterKit setLocalAudioEnable:!sender.selected];
            break;
        case 109:
        {
            //退出
            [self.mHosterKit clear];
            
            [self orientationRotating: UIInterfaceOrientationPortrait];
            //直播秒数
            NSInteger i = [[NSDate date] timeIntervalSince1970] - self.liveTime;
            
            ATLivingEndController *liveEndVc = [[self storyboard]instantiateViewControllerWithIdentifier:@"RTMPC_Video_End"];
            liveEndVc.userName = self.liveInfo.userName;
            liveEndVc.livTime = i;
            [self.navigationController pushViewController:liveEndVc animated:YES];
        }
            break;
        case 110:
            //功能（竖屏）
        {
            sender.selected = NO;
            [self presentViewController:self.menuVc animated:YES completion:nil];
        }
            break;
        case 111:
            //弹幕
            self.barrageView.hidden = sender.selected;
            self.infoView.hidden = sender.selected;
            break;
        default:
            NSLog(@"error");
    }
}

#pragma mark - HangUpDelegate
- (void)hangUpOperation:(NSString *)peerId{
    [self.mHosterKit hangupRTCLine:peerId];
    
    [self.videoArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[ATVideoView class]]) {
            ATVideoView *video = (ATVideoView *)obj;
            if ([video.strPeerId isEqualToString:peerId]) {
                [self.videoArr removeObjectAtIndex:idx];
                [video removeFromSuperview];
                [self layoutVideoView:self.localView containerView:self.containerView landscape:self.liveInfo.isLiveLandscape];
            }
        }
    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.text != nil) {
        if (self.liveInfo.isLiveLandscape) {
            [self.renderer receive:[self produceTextBarrage:BarrageWalkDirectionL2R message:textField.text]];
        } else {
            [self.infoView addMessage:[self produceTextInfo:self.liveInfo.userName content:textField.text userId:@"hosterUserId"]];
        }
        
        //发送消息
        [self.mHosterKit sendUserMessage:self.liveInfo.isLiveLandscape withUserName:self.liveInfo.userName andUserHeader:@"" andContent:textField.text];
        textField.text = @"";
        [textField resignFirstResponder];
    }
    return YES;
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

#pragma mark - RTMPCHosterRtcDelegate

- (void)onRTCCreateLineResult:(int)nCode{
    //创建RTC服务连接结果
    (nCode == 0) ? (self.rtcLabel.text = @"RTC服务链接成功") : (self.rtcLabel.text = @"RTC服务链接出错");
}

- (void)onRTCApplyToLine:(NSString*)strLivePeerId withUserId:(NSString*)strUserId withUserData:(NSString*)strUserData{
    //主播收到游客连麦请求
    [self.micArr addObject:[self produceRealModel:strLivePeerId userId:strUserId userData:strUserData]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LineNumChangeNotification" object:self.micArr];
}

- (void)onRTCCancelLine:(int)nCode withLivePeerId:(NSString*)strLivePeerId{
    //游客取消连麦申请，或者连麦已满
    if (nCode == 0) {
        [self.micArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[ATRealMicModel class]]) {
                ATRealMicModel *micModel = (ATRealMicModel *)obj;
                if ([micModel.peerId isEqualToString:strLivePeerId]) {
                    [self.micArr removeObjectAtIndex:idx];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"LineNumChangeNotification" object:self.micArr];
                    *stop = YES;
                }
            }
        }];
    }
}

- (void)onRTCLineClosed:(int)nCode {
    //RTC 服务关闭
}

- (void)onRTCOpenVideoRender:(NSString*)strLivePeerId withRTCPubId:(NSString *)strRTCPubId withUserId:(NSString *)strUserId withUserData:(NSString*)strUserData{
    //游客视频连麦接通
    NSDictionary *dict = [ATCommon fromJsonStr:strUserData];
    ATVideoView * videoView = [ATVideoView loadVideoWithName:[dict objectForKey:@"nickName"] peerId:strLivePeerId pubId:strRTCPubId size:CGSizeZero display:YES];
    videoView.delegate = self;
    [self.videoArr addObject:videoView];
    [self layoutVideoView:self.localView containerView:self.containerView landscape:self.liveInfo.isLiveLandscape];
    [self.mHosterKit setRTCVideoRender:strRTCPubId andRender:videoView.localView];
}

- (void)onRTCCloseVideoRender:(NSString*)strLivePeerId withRTCPubId:(NSString *)strRTCPubId withUserId:(NSString *)strUserId{
    //游客视频连麦挂断
    [self.videoArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[ATVideoView class]]) {
            ATVideoView *video = (ATVideoView *)obj;
            if ([video.strPubId isEqualToString:strRTCPubId]) {
                [self.videoArr removeObjectAtIndex:idx];
                [video removeFromSuperview];
                [self layoutVideoView:self.localView containerView:self.containerView landscape:self.liveInfo.isLiveLandscape];
                *stop = YES;
            }
        }
    }];
}

- (void)onRTCOpenAudioLine:(NSString*)strLivePeerId withUserId:(NSString *)strUserId withUserData:(NSString*)strUserData{
    //游客音频连麦接通
}

- (void)onRTCCloseAudioLine:(NSString*)strLivePeerId withUserId:(NSString *)strUserId{
    //游客音频连麦挂断
}

- (void)onRTCAVStatus:(NSString*) strRTCPeerId withAudio:(BOOL)bAudio withVideo:(BOOL)bVideo{
    //其他连麦者视频窗口的对音视频的操作
}

- (void)onRTCViewChanged:(UIView*)videoView didChangeVideoSize:(CGSize)size{
    //视频窗口大小改变
    [self.videoArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[ATVideoView class]]) {
            ATVideoView *video = (ATVideoView *)obj;
            /*superview*/
            if (videoView.superview == video) {
                video.videoSize = size;
                [self layoutVideoView:self.localView containerView:self.containerView landscape:self.liveInfo.isLiveLandscape];
                *stop = YES;
            }
        }
    }];
}

- (void)onRTCAudioActive:(NSString *)strLivePeerId withUserId:(NSString *)strUserId withShowTime:(int)nTime{
    //RTC音频检测
}

- (void)onRTCUserMessage:(int)nType withUserId:(NSString*)strUserId withUserName:(NSString*)strUserName withUserHeader:(NSString*)strUserHeaderUrl withContent:(NSString*)strContent{
    // 收到消息回调
    self.liveInfo.isLiveLandscape ? ([self.renderer receive:[self produceTextBarrage:BarrageWalkDirectionL2R message:strContent]]) : ([self.infoView addMessage:[self produceTextInfo:strUserName content:strContent userId:strUserId]]);
}

- (void)onRTCMemberListNotify:(NSString*)strServerId withRoomId:(NSString*)strRoomId withAllMember:(int) nTotalMember{
    //直播间实时在线人数变化通知
    self.onlineLabel.text = [NSString stringWithFormat:@"%d",nTotalMember];
    self.listVc.serverId = strServerId;
    self.listVc.roomId = strRoomId;
    self.listVc.anyrtcId = self.liveInfo.anyrtcId;
}

#pragma mark - Menu
- (ATMenuViewController *)menuVc{
    if (!_menuVc) {
        //菜单功能(竖屏)
        _menuVc = [[self storyboard] instantiateViewControllerWithIdentifier:@"RTMPC_Video_Menu"];
        _menuVc.mHosterKit = self.mHosterKit;
        _menuVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    return _menuVc;
}

@end
