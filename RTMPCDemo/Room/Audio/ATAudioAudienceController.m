//
//  ATAudioAudienceController.m
//  RTMPCDemo
//
//  Created by jh on 2018/4/13.
//  Copyright © 2018年 jh. All rights reserved.
//

#import "ATAudioAudienceController.h"

@interface ATAudioAudienceController ()<RTMPCGuestRtmpDelegate,RTMPCGuestRtcDelegate,HangUpDelegate>

@property (weak, nonatomic) IBOutlet UILabel *rtcLabel;       //RTC状态

@property (weak, nonatomic) IBOutlet UILabel *rtmpLabel;      //RTMP状态

@property (weak, nonatomic) IBOutlet UILabel *topicLabel;     //房间名

@property (weak, nonatomic) IBOutlet UILabel *roomIdLabel;    //房间号

@property (weak, nonatomic) IBOutlet UILabel *onlineLabel;    //在线人员

@property (weak, nonatomic) IBOutlet UIView *listView;       //在线人员

@property (weak, nonatomic) IBOutlet UIImageView *backImageView;

@property (weak, nonatomic) IBOutlet UIView *containerView;  //容器

@property (weak, nonatomic) IBOutlet UIView *barrageView;    //弹幕渲染

@property (weak, nonatomic) IBOutlet UIView *barrageButton;  //消息控制器

@property (weak, nonatomic) IBOutlet ATAudioButton *localButton; //自己头像

@property (weak, nonatomic) IBOutlet UIButton *applyButton;

@property (weak, nonatomic) IBOutlet UIButton *audioButton;    //音频开关（连麦时显示）

@property(nonatomic ,strong) RTMPCGuestAudioKit *guestAudioKit;

@end

@implementation ATAudioAudienceController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.topicLabel.text = self.hallModel.liveTopic;
    self.roomIdLabel.text = [NSString stringWithFormat:@"房间ID：%@",self.hallModel.anyrtcId];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(getMemberList)];
    [self.listView addGestureRecognizer:tap];
    
    [self.localButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@(120));
        make.center.equalTo(self.view);
    }];
    
    self.audioButton.hidden = YES;
    //初始化RTMPC
    [self setUpInitialization];
    
    if (self.hallModel.isLiveLandscape == 1) { //强制横屏
        [self orientationRotating: UIInterfaceOrientationLandscapeLeft];
        self.backImageView.image = [UIImage imageNamed:@"voice_background_lan"];
        [self.barrageView addSubview:self.renderer.view];
    } else {
        [self.view insertSubview:self.infoView aboveSubview:self.barrageView];
    }
}

//初始化
- (void)setUpInitialization{
    
    self.topicLabel.text = self.hallModel.liveTopic;
    self.roomIdLabel.text = [NSString stringWithFormat:@"房间ID：%@",self.hallModel.anyrtcId];
    //实例化游客对象
    self.guestAudioKit = [[RTMPCGuestAudioKit alloc]initWithDelegate:self withAudioDetect:YES];
    
    //开始RTMP播放
    [self.guestAudioKit startRtmpPlay:self.hallModel.rtmpUrl];
    self.guestAudioKit.rtc_delegate = self;
    
    NSDictionary *customDict = [NSDictionary dictionaryWithObjectsAndKeys:self.userName,@"nickName",@"",@"headUrl" ,nil];
    NSString *customStr = [ATCommon fromDicToJSONStr:customDict];
    //加入RTC
    [self.guestAudioKit joinRTCLine:self.hallModel.anyrtcId andUserID:[ATCommon randomString:6] andUserData:customStr];
}

- (IBAction)doSomethingEvents:(UIButton *)sender{
    sender.selected = !sender.selected;
    switch (sender.tag) {
        case 100:
            //申请连麦
            if (sender.selected) {
                sender.backgroundColor = [UIColor redColor];
                (!self.guestAudioKit.applyRTCLine) ? (sender.selected = NO) : 0;
            } else {
                [self.guestAudioKit hangupRTCLine];
                self.audioButton.hidden = YES;
                sender.backgroundColor = [UIColor blueColor];
                [self.applyButton setTitle:@"申请连麦" forState:UIControlStateNormal];
                
                [self.audioArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj isKindOfClass:[ATAudioView class]]) {
                        ATAudioView *audio = (ATAudioView *)obj;
                        [self.audioArr removeObjectAtIndex:idx];
                        [audio removeFromSuperview];
                    }
                }];
                
                [self layoutAudioView:self.localButton containerView:self.containerView landscape:self.hallModel.isLiveLandscape];
            }
            break;
        case 101:
            //消息
            [self.messageTextField becomeFirstResponder];
            break;
        case 102:
            //音频
            [self.guestAudioKit setLocalAudioEnable:!sender.selected];
            break;
        case 103:
            //退出
            [self.guestAudioKit clear];
            
            [self orientationRotating: UIInterfaceOrientationPortrait];
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case 104:
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
    [self.guestAudioKit hangupRTCLine];
    
    [self.audioArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[ATAudioView class]]) {
            ATAudioView *audio = (ATAudioView *)obj;
            [self.audioArr removeObjectAtIndex:idx];
            [audio removeFromSuperview];
        }
    }];
    [self layoutAudioView:self.localButton containerView:self.containerView landscape:self.hallModel.isLiveLandscape];
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
        [self.guestAudioKit sendUserMessage:self.hallModel.isLiveLandscape withUserName:self.userName andUserHeader:@"" andContent:textField.text];
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
- (void)onRTCAudioActive:(NSString *)strLivePeerId withUserId:(NSString *)strUserId withShowTime:(int)nTime{
    //RTC音频检测
    if ([strLivePeerId isEqualToString:@"RTMPC_Line_Hoster"]) {
        [self.localButton startAudioAnimation];
        return;
    }
    
    [self.audioArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[ATAudioView class]]) {
            ATAudioView *audio = (ATAudioView *)obj;
            if ([audio.peerId isEqualToString:strLivePeerId]) {
                [audio.headButton startAudioAnimation];
            }
        }
    }];
}

- (void)onRTCJoinLineResult:(int)nCode{
    //RTC服务连接结果
    nCode == 0 ? (self.rtcLabel.text = @"RTC服务链接成功") : (self.rtcLabel.text = @"RTC服务链接出错");
}

- (void)onRTCApplyLineResult:(int)nCode{
    //游客申请连麦结果回调
    if (nCode == 0) {
        self.audioButton.hidden = NO;
        [self.applyButton setTitle:@"挂断" forState:UIControlStateNormal];
        [self.applyButton setBackgroundColor:ATRedColor];
        
        ATAudioView *audio = [ATAudioView loadAudioWithName:self.userName peerId:Video_MySelf display:YES];
        audio.delegate = self;
        [self.audioArr addObject:audio];
        [self layoutAudioView:self.localButton containerView:self.containerView landscape:self.hallModel.isLiveLandscape];
    } else {
        [self.applyButton setTitle:@"申请连麦" forState:UIControlStateNormal];
        [self.applyButton setBackgroundColor:ATBlueColor];
    }
}

- (void)onRTCHangupLine{
    // 主播挂断游客连麦
    [self.audioArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[ATAudioView class]]) {
            ATAudioView *audio = (ATAudioView *)obj;
            [self.audioArr removeObjectAtIndex:idx];
            [audio removeFromSuperview];
        }
    }];
    
    self.audioButton.hidden = YES;
    self.applyButton.selected = NO;
    [self.applyButton setTitle:@"申请连麦" forState:UIControlStateNormal];
    self.applyButton.backgroundColor = [UIColor blueColor];
    [self layoutAudioView:self.localButton containerView:self.containerView landscape:self.hallModel.isLiveLandscape];
}

- (void)onRTCLineLeave:(int)nCode{
    //断开RTC服务连接
    if (nCode == 0) {
        [XHToast showCenterWithText:@"直播已结束"];
        [self.guestAudioKit clear];

        [self orientationRotating: UIInterfaceOrientationPortrait];
        [self.navigationController popViewControllerAnimated:YES];
    } else if (nCode == 100){
        [XHToast showCenterWithText:@"网络出现异常"];
    }
}

- (void)onRTCOpenVideoRender:(NSString*)strLivePeerId withRTCPubId:(NSString *)strRTCPubId withUserId:(NSString *)strUserId withUserData:(NSString*)strUserData{
    // 其他游客视频连麦接通
}

- (void)onRTCCloseVideoRender:(NSString*)strLivePeerId withRTCPubId:(NSString *)strRTCPubId withUserId:(NSString *)strUserId{
    //其他游客视频连麦挂断
}

- (void)onRTCViewChanged:(UIView*)videoView didChangeVideoSize:(CGSize)size{
    //视频窗口大小改变
}

- (void)onRTCOpenAudioLine:(NSString*)strLivePeerId withUserId:(NSString *)strUserId withUserData:(NSString*)strUserData{
    //其他游客音频连麦接通
    if (![strLivePeerId isEqualToString:@"RTMPC_Line_Hoster"]) {
        NSDictionary *dict = [ATCommon fromJsonStr:strUserData];
        ATAudioView *audio = [ATAudioView loadAudioWithName:[dict objectForKey:@"nickName"] peerId:strLivePeerId display:NO];
        [self.audioArr addObject:audio];
        [self layoutAudioView:self.localButton containerView:self.containerView landscape:self.hallModel.isLiveLandscape];
    }
}

- (void)onRTCCloseAudioLine:(NSString*)strLivePeerId withUserId:(NSString *)strUserId {
    //其他游客音频连麦挂断
    [self.audioArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[ATAudioView class]]) {
            ATAudioView *audio = (ATAudioView *)obj;
            if ([audio.peerId isEqualToString:strLivePeerId]) {
                [self.audioArr removeObjectAtIndex:idx];
                [audio removeFromSuperview];
                [self layoutAudioView:self.localButton containerView:self.containerView landscape:self.hallModel.isLiveLandscape];
                *stop = YES;
            }
        }
    }];
}

- (void)onRTCAVStatus:(NSString*) strRTCPeerId withAudio:(BOOL)bAudio withVideo:(BOOL)bVideo{
    //其他连麦者或主播视频窗口的对音视频的操作
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
