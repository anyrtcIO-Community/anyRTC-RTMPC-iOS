//
//  ATVideoAudienceController.m
//  RTMPCDemo
//
//  Created by jh on 2018/4/11.
//  Copyright © 2018年 jh. All rights reserved.
//

#import "ATVideoAudienceController.h"

@interface ATVideoAudienceController ()<RTMPCGuestRtmpDelegate,RTMPCGuestRtcDelegate,HangUpDelegate>

@property (weak, nonatomic) IBOutlet UILabel *rtcLabel;       //RTC状态

@property (weak, nonatomic) IBOutlet UILabel *rtmpLabel;      //RTMP状态

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *padding; //连麦显示音视频

@property (weak, nonatomic) IBOutlet UILabel *topicLabel;     //房间名

@property (weak, nonatomic) IBOutlet UILabel *roomIdLabel;    //房间号

@property (weak, nonatomic) IBOutlet UILabel *onlineLabel;    //在线人员

@property (weak, nonatomic) IBOutlet UIButton *applyButton;   //连麦

@property (weak, nonatomic) IBOutlet UIView *listView;       //在线人员

@property (weak, nonatomic) IBOutlet UIView *barrageView;    //弹幕渲染

@property (weak, nonatomic) IBOutlet UIView *containerView;  //容器

@property (weak, nonatomic) IBOutlet UIView *localView;

@property (weak, nonatomic) IBOutlet UIView *barrageButton;  //消息控制器

@property(nonatomic ,strong) RTMPCGuestKit *guestKit;

@property (nonatomic, strong) ATMenuViewController *menuVc;
//主播端分辨率
@property (nonatomic, assign) CGSize hoster_Size;

@end

@implementation ATVideoAudienceController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.topicLabel.text = self.hallModel.liveTopic;
    self.roomIdLabel.text = [NSString stringWithFormat:@"房间ID：%@",self.hallModel.anyrtcId];
    
    self.padding.constant = -MAXFLOAT;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(getMemberList)];
    [self.listView addGestureRecognizer:tap];
    
    //初始化RTMPC
    [self itializationGuestKit];
    
    if (self.hallModel.isLiveLandscape == 1) { //强制横屏
        [self orientationRotating: UIInterfaceOrientationLandscapeLeft];
        [self.barrageView addSubview:self.renderer.view];
    } else {
        [self.view insertSubview:self.infoView aboveSubview:self.barrageView];
    }
}

- (void)itializationGuestKit{
    RTMPCGuestOption *option = [RTMPCGuestOption defaultOption];
    if (self.hallModel.isLiveLandscape == 1) {
        option.videoScreenOrientation = RTMPCScreenLandscapeRightType;
    }
    //初始化配置信息
    self.guestKit = [[RTMPCGuestKit alloc]initWithDelegate:self andOption:option];
    //开始RTMP播放
    [self.guestKit startRtmpPlay:self.hallModel.rtmpUrl andRender:self.localView];
    [self.videoArr addObject:self.localView];
    
    self.guestKit.rtc_delegate = self;
    
    NSDictionary *customDict = [NSDictionary dictionaryWithObjectsAndKeys:self.userName,@"nickName",@"",@"headUrl" ,nil];
    NSString *customStr = [ATCommon fromDicToJSONStr:customDict];
    
    [self.guestKit joinRTCLine:self.hallModel.anyrtcId andUserID:[ATCommon randomString:6] andUserData:customStr];
}
- (IBAction)doSomethingEvents:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    switch (sender.tag) {
        case 100:
            //申请连麦
            if (sender.selected) {
                sender.backgroundColor = [UIColor redColor];
                !self.guestKit.applyRTCLine ? (sender.selected = NO) : 0;
            } else {
                [self.guestKit hangupRTCLine];
                sender.backgroundColor = [UIColor blueColor];

                [self.applyButton setTitle:@"申请连麦" forState:UIControlStateNormal];
                [self.videoArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj isKindOfClass:[ATVideoView class]]) {
                        ATVideoView *video = (ATVideoView *)obj;
                        [self.videoArr removeObjectAtIndex:idx];
                        [video removeFromSuperview];
                        self.padding.constant = -MAXFLOAT;
                    }
                }];
                
                [self layoutVideoView:self.localView containerView:self.containerView landscape:self.hallModel.isLiveLandscape];
            }
            break;
        case 101:
            //消息
            [self.messageTextField becomeFirstResponder];
            break;
        case 102:
            //切换摄像头
            [self.guestKit switchCamera];
            break;
        case 103:
            //视频
            [self.guestKit setLocalVideoEnable:!sender.selected];
            break;
        case 104:
            //音频
            [self.guestKit setLocalAudioEnable:!sender.selected];
            break;
        case 105:
            //关闭
            [self.guestKit clear];
            
            [self orientationRotating: UIInterfaceOrientationPortrait];
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case 106:
            //弹幕
            self.barrageView.hidden = sender.selected;
            self.infoView.hidden = sender.selected;
            break;
        default:
            break;
    }
}

#pragma mark - HangUpDelegate
- (void)hangUpOperation:(NSString *)peerId{
    [self.guestKit hangupRTCLine];
    
    [self.videoArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[ATVideoView class]]) {
            ATVideoView *video = (ATVideoView *)obj;
            [self.videoArr removeObjectAtIndex:idx];
            [video removeFromSuperview];
        }
    }];
    [self layoutVideoView:self.localView containerView:self.containerView landscape:self.hallModel.isLiveLandscape];

    self.applyButton.selected = NO;
    [self.applyButton setTitle:@"申请连麦" forState:UIControlStateNormal];
    self.applyButton.backgroundColor = [UIColor blueColor];
    self.padding.constant = -MAXFLOAT;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.text != nil) {
        if (self.hallModel.isLiveLandscape) {
            [self.renderer receive:[self produceTextBarrage:BarrageWalkDirectionL2R message:textField.text]];
        } else {
            [self.infoView addMessage:[self produceTextInfo:self.userName content:textField.text userId:@""]];
        }
        
        //发送消息
        [self.guestKit sendUserMessage:self.hallModel.isLiveLandscape withUserName:self.userName andUserHeader:@"" andContent:textField.text];
        textField.text = @"";
        [textField resignFirstResponder];
    }
    return YES;
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
- (void)onRTCJoinLineResult:(int)nCode{
    //RTC服务连接结果
    (nCode == 0) ? (self.rtcLabel.text = @"RTC服务链接成功") : (self.rtcLabel.text = @"RTC服务链接出错");
}

- (void)onRTCApplyLineResult:(int)nCode{
    //游客申请连麦结果回调
    if (nCode == 0) {
        self.padding.constant = 10;
        [self.applyButton setTitle:@"挂断" forState:UIControlStateNormal];
        self.applyButton.backgroundColor = [UIColor redColor];
        
        ATVideoView *video = [ATVideoView loadVideoWithName:self.userName peerId:Video_MySelf pubId:Video_MySelf size:CGSizeMake(4, 3) display:true];
        video.delegate = self;
        [self.videoArr addObject:video];
        [self.guestKit setLocalVideoCapturer:video.localView];
        
        [self layoutVideoView:self.localView containerView:self.containerView landscape:self.hallModel.isLiveLandscape];
    } else {
        [self.applyButton setTitle:@"申请连麦" forState:UIControlStateNormal];
        [self.applyButton setBackgroundColor:ATBlueColor];
    }
}

- (void)onRTCHangupLine{
    // 主播挂断游客连麦
    [self.videoArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[ATVideoView class]]) {
            ATVideoView *video = (ATVideoView *)obj;
            [self.videoArr removeObjectAtIndex:idx];
            [video removeFromSuperview];
        }
    }];
    
    self.applyButton.selected = NO;
    self.padding.constant = - MAXFLOAT;
    [self.applyButton setTitle:@"申请连麦" forState:UIControlStateNormal];
    [self.applyButton setBackgroundColor:ATBlueColor];
    [self layoutVideoView:self.localView containerView:self.containerView landscape:self.hallModel.isLiveLandscape];
}

- (void)onRTCLineLeave:(int)nCode{
    //断开RTC服务连接
    if (nCode == 0) {
        [XHToast showCenterWithText:@"直播已结束"];
        [self.guestKit clear];
        [self orientationRotating: UIInterfaceOrientationPortrait];
        [self.navigationController popViewControllerAnimated:YES];
    } else if (nCode == 100){
        [XHToast showCenterWithText:@"网络异常"];
    }
}

- (void)onRTCOpenVideoRender:(NSString*)strLivePeerId withRTCPubId:(NSString *)strRTCPubId withUserId:(NSString *)strUserId withUserData:(NSString*)strUserData{
    //其他游客视频连麦接通
    NSDictionary *dict = [ATCommon fromJsonStr:strUserData];
    ATVideoView *video = [ATVideoView loadVideoWithName:[dict objectForKey:@"nickName"] peerId:strLivePeerId pubId:strRTCPubId size:CGSizeZero display:NO];
    video.delegate = self;
    [self.videoArr addObject:video];
    
    [self.guestKit setRTCVideoRender:strRTCPubId andRender:video.localView];
}

- (void)onRTCCloseVideoRender:(NSString*)strLivePeerId withRTCPubId:(NSString *)strRTCPubId withUserId:(NSString *)strUserId {
    //其他游客视频连麦挂断
    [self.videoArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[ATVideoView class]]) {
            ATVideoView *video = (ATVideoView *)obj;
            if ([video.strPubId isEqualToString:strRTCPubId]) {
                [self.videoArr removeObjectAtIndex:idx];
                [video removeFromSuperview];
                [self layoutVideoView:self.localView containerView:self.containerView landscape:self.hallModel.isLiveLandscape];
                *stop = YES;
            }
        }
    }];
}

- (void)onRTCOpenAudioLine:(NSString*)strLivePeerId withUserId:(NSString *)strUserId withUserData:(NSString*)strUserData{
    //其他游客音频连麦接通
}

- (void)onRTCCloseAudioLine:(NSString*)strLivePeerId withUserId:(NSString *)strUserId {
    //其他游客音频连麦挂断
}

- (void)onRTCAudioActive:(NSString *)strLivePeerId withUserId:(NSString *)strUserId withShowTime:(int)nTime{
    //RTC音频检测
}

-(void)onRTCAVStatus:(NSString*) strRTCPeerId withAudio:(BOOL)bAudio withVideo:(BOOL)bVideo {
    //其他连麦者或主播视频窗口的对音视频的操作
}

- (void)onRTCViewChanged:(UIView*)videoView didChangeVideoSize:(CGSize)size{
    //视频窗口大小改变
    if (self.localView == videoView) {//暂时不处理，可能会出现压缩
        self.hoster_Size = size;
    }
    
    [self.videoArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[ATVideoView class]]) {
            ATVideoView * video = (ATVideoView *)obj;
            if (video == videoView.superview) {
                video.videoSize = size;
                *stop = YES;
            }
        }
    }];
    
    [self layoutVideoView:self.localView containerView:self.containerView landscape:self.hallModel.isLiveLandscape];
}

- (void)onRTCUserMessage:(int)ntype withUserId:(NSString*)strUserId withUserName:(NSString*)strUserName withUserHeader:(NSString*)strUserHeaderUrl withContent:(NSString*)strContent{
    //收到消息
    self.hallModel.isLiveLandscape ? ([self.renderer receive:[self produceTextBarrage:BarrageWalkDirectionL2R message:strContent]]) : ([self.infoView addMessage:[self produceTextInfo:strUserName content:strContent userId:strUserId]]);
}

-(void)onRTCMemberListNotify:(NSString*)strServerId withRoomId:(NSString*)strRoomId withAllMember:(int) nTotalMember{
    self.onlineLabel.text = [NSString stringWithFormat:@"%d",nTotalMember];
    //直播间实时在线人数变化
    self.listVc.serverId = strServerId;
    self.listVc.roomId = strRoomId;
    self.listVc.anyrtcId = self.hallModel.anyrtcId;
}

@end
