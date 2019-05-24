//
//  ArVideoAudienceController.m
//  RTMPCDemo
//
//  Created by 余生丶 on 2019/4/10.
//  Copyright © 2019 anyRTC. All rights reserved.
//

#import "ArVideoAudienceController.h"

@interface ArVideoAudienceController ()<ARGuestRtmpDelegate,ARGuestRtcDelegate>

@property (weak, nonatomic) IBOutlet UIView *localView;
@property (weak, nonatomic) IBOutlet UIButton *applyButton;
@property (weak, nonatomic) IBOutlet UIButton *switchButton;

@property(nonatomic ,strong) ARRtmpGuestKit *guestKit;

@end

@implementation ArVideoAudienceController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.applyButton.hidden = YES;
    self.switchButton.hidden = YES;
    NSMutableString *roomText = [[NSMutableString alloc] initWithString:self.mainModel.anyrtcId];
    [roomText insertString:@" " atIndex:4];
    self.roomIdLabel.text = [NSString stringWithFormat:@"房间名称：%@",roomText];
    [self itializationGuestKit];
}

- (void)itializationGuestKit {
    //初始化游客对象
    ARGuestOption *option = [ARGuestOption defaultOption];
    self.guestKit = [[ARRtmpGuestKit alloc] initWithDelegate:self option:option];
    self.guestKit.rtc_delegate = self;
    [self.guestKit startRtmpPlay:self.mainModel.rtmpUrl render:self.localView];
    
    //加入RTC
    ArUserInfo *userInfo = ArUserManager.getUserInfo;
    NSDictionary *userData = [NSDictionary dictionaryWithObjectsAndKeys:userInfo.nickname,@"nickName",@"",@"headUrl" ,nil];
    [self.guestKit joinRTCLineByToken:nil liveId:self.mainModel.anyrtcId userID:userInfo.userid userData:[ArCommon fromDicToJSONStr:userData]];
    
    ArMethodText(@"initWithDelegate:");
    ArMethodText(@"startRtmpPlay:");
    ArMethodText(@"joinRTCLineByToken:");
}

- (IBAction)handleSomethingEvent:(UIButton *)sender {
    switch (sender.tag) {
        case 50:
            sender.selected = !sender.selected;
            if (sender.selected) {
                //申请连麦
                [self.guestKit applyRTCLine];
                [self.applyButton setTitle:@"取消连麦" forState:UIControlStateSelected];
                [self.applyButton setBackgroundColor:[ArCommon getColor:@"#FF6264"]];
                ArMethodText(@"applyRTCLine");
            } else {
                //挂断、取消连麦
                [self.guestKit hangupRTCLine];
                [self hangupLine];
                ArMethodText(@"hangupRTCLine");
            }
            break;
        case 51:
            //消息
            [self.messageTextField becomeFirstResponder];
            break;
        case 52:
            //退出
            [self.guestKit clear];
            ArMethodText(@"clear");
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        case 53:
            [self.guestKit switchCamera];
            ArMethodText(@"switchCamera");
            break;
        case 54:
            //日志
            [self openLogView];
            break;
        default:
            break;
    }
}

- (void)hangupLine {
    self.switchButton.hidden = YES;
    self.applyButton.selected = NO;
    [self.applyButton setTitle:@"申请连麦" forState:UIControlStateNormal];
    [self.videoStackView removeFromSuperview];
    self.videoStackView  = nil;
    [self.applyButton setBackgroundColor:[ArCommon getColor:@"#33B15D"]];
}

//MARK: - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.text != nil) {
        ArUserInfo *userInfo = ArUserManager.getUserInfo;
        [self.messageView addMessage:[self produceTextInfo:userInfo.nickname content:textField.text userId:userInfo.userid audio:NO]];
        //发送消息
        [self.guestKit sendUserMessage:ARNomalMessageType userName:ArUserManager.getUserInfo.nickname userHeader:@"" content:textField.text];
        textField.text = @"";
        [textField resignFirstResponder];
        ArMethodText(@"sendUserMessage:");
    }
    return YES;
}

//MARK: - ARGuestRtmpDelegate

- (void)onRtmpPlayerOk {
    //RTMP 连接成功
    self.rtmpLabel.text = @"RTMP服务链接成功";
    ArCallbackLog;
}

- (void)onRtmpPlayerStart {
    //RTMP 开始播放
    self.rtmpLabel.text = @"RTMP开始播放";
    ArCallbackLog;
}

- (void)onRtmpPlayerStatus:(int)cacheTime bitrate:(int)bitrate {
    //RTMP 当前播放状态
    self.rtmpLabel.text = [NSString stringWithFormat:@"RTMP缓存时长:%.2fs 当前下行网速:%.2fkb/s",cacheTime/1000.00,bitrate/1024.00/8];
    ArCallbackLog;
}

- (void)onRtmpPlayerLoading:(int)percent {
    //RTMP播放缓冲进度
    self.rtmpLabel.text = @"RTMP缓冲中...";
    ArCallbackLog;
}

- (void)onRtmpPlayerClosed:(ARRtmpCode)code {
    //RTMP播放器关闭
    self.rtmpLabel.text = @"RTMP服务关闭";
    ArCallbackLog;
}

//MARK：- ARGuestRtcDelegate

- (void)onRTCJoinLineResult:(ARRtmpCode)code reason:(NSString *)reason {
    //RTC服务连接结果
    if (code == ARRtmp_OK) {
        self.applyButton.hidden = NO;
        self.rtcLabel.text = @"RTC服务链接成功";
    } else {
        self.rtcLabel.text = @"RTC服务链接出错";
    }
    ArCallbackLog;
}

- (void)onRTCApplyLineResult:(ARRtmpCode)code {
    //游客申请连麦结果回调
    self.applyButton.selected = !code;
    if (code == ARRtmp_OK) {
        self.switchButton.hidden = NO;
        [self.applyButton setTitle:@"挂断连麦" forState:UIControlStateSelected];
        ArVideoView *videoView = [[ArVideoView alloc] initWithPeerId:Video_MySelf pubId:Video_MySelf display:NO];
        [self.videoStackView addArrangedSubview:videoView];
        [videoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.videoStackView.mas_width);
            make.height.equalTo(videoView.mas_width).multipliedBy(1.333);
        }];
        [self.guestKit setLocalVideoCapturer:videoView];
        ArMethodText(@"setLocalVideoCapturer:");
    } else {
        [ArCommon showAlertsStatus:@"主播拒绝了你的连麦请求"];
        [self.applyButton setTitle:@"申请连麦" forState:UIControlStateNormal];
        [self.applyButton setBackgroundColor:[ArCommon getColor:@"#33B15D"]];
    }
    ArCallbackLog;
}

- (void)onRTCHangupLine {
    //主播挂断游客连麦
    [self hangupLine];
    ArCallbackLog;
}

- (void)onRTCLineLeave:(ARRtmpCode)code {
    //断开RTC服务连接
    if (code == ARRtmp_OK) {
        [self removeLogView];
        [ArCommon showAlertsStatus:@"直播已结束"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.guestKit clear];
            ArMethodText(@"clear");
            [self dismissViewControllerAnimated:YES completion:nil];
        });
    } else if (code == ARRtmp_NET_ERR){
        [ArCommon showAlertsStatus:@"请检查当前网络状态"];
    }
    ArCallbackLog;
}

- (void)onRTCOpenRemoteVideoRender:(NSString *)peerId pubId:(NSString *)pubId userId:(NSString *)userId userData:(NSString *)userData {
    //其他游客视频连麦接通
    ArVideoView *videoView = [[ArVideoView alloc] initWithPeerId:peerId pubId:pubId display:NO];
    [self.videoStackView addArrangedSubview:videoView];
    [videoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.videoStackView.mas_width);
        make.height.equalTo(videoView.mas_width).multipliedBy(1.333);
    }];
    [self.guestKit setRemoteVideoRender:videoView pubId:pubId];
    ArCallbackLog;
    ArMethodText(@"setRemoteVideoRender:");
}

- (void)onRTCCloseRemoteVideoRender:(NSString *)peerId pubId:(NSString *)pubId userId:(NSString *)userId {
    //其他游客视频连麦挂断
    [self.videoStackView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ArVideoView *video = (ArVideoView *)obj;
        if ([video.pubId isEqualToString:pubId]) {
            [video removeFromSuperview];
            *stop = YES;
        }
    }];
    ArCallbackLog;
}

- (void)onRTCRemoteAVStatus:(NSString *)peerId audio:(BOOL)audio video:(BOOL)video {
    //其他人对音视频的操作
    ArCallbackLog;
}

- (void)onRTCFirstPlayerVideoFrame:(CGSize)size {
    //本地Player播放第一帧
    if (self.mainModel.isLiveLandscape) {
        [self.guestKit updatePlayerRenderModel:ARVideoRenderScaleAspectFit];
        ArMethodText(@"updatePlayerRenderModel:");
    }
    ArCallbackLog;
}

- (void)onRTCFirstLocalVideoFrame:(CGSize)size {
    //本地视频第一帧
    ArCallbackLog;
}

- (void)onRTCFirstRemoteVideoFrame:(CGSize)size pubId:(NSString *)pubId {
    //远程视频第一帧
    ArCallbackLog;
}

- (void)onRTCPlayerViewChanged:(CGSize)size {
    //本地Player窗口大小的回调
    ArCallbackLog;
}

- (void)onRTCLocalVideoViewChanged:(CGSize)size {
    //本地窗口大小的回调
    ArCallbackLog;
}

- (void)onRTCRemoteVideoViewChanged:(CGSize)size pubId:(NSString *)pubId {
    //远程窗口大小的回调
    ArCallbackLog;
}

- (void)onRTCLocalAudioActive:(int)level showTime:(int)time {
    //本地音频检测回调
    ArCallbackLog;
}

- (void)onRTCHosterAudioActive:(NSString *)userId audioLevel:(int)level showTime:(int)time {
    //主持人音频检测
    ArCallbackLog;
}

- (void)onRTCRemoteAudioActive:(NSString *)peerId userId:(NSString *)userId audioLevel:(int)level showTime:(int)time {
    //其他与会者音频检测回调
    ArCallbackLog;
}

- (void)onRTCUserMessage:(ARMessageType)type userId:(NSString *)userId userName:(NSString *)userName userHeader:(NSString *)headerUrl content:(NSString *)content {
    //收到消息回调
    [self.messageView addMessage:[self produceTextInfo:userName content:content userId:userId audio:NO]];
    ArCallbackLog;
}

- (void)onRTCMemberListNotify:(NSString *)serverId roomId:(NSString *)roomId allMember:(int)totalMember {
    //直播间实时在线人数变化通知
    self.onlineLabel.text = [NSString stringWithFormat:@"在线人数：%d",totalMember];
    ArCallbackLog;
}

- (CVPixelBufferRef)cameraSourceDidGetPixelBuffer:(CMSampleBufferRef)sampleBuffer {
    //获取视频的原始采集数据
    ArCallbackLog;
    CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    return pixelBuffer;
}

@end
