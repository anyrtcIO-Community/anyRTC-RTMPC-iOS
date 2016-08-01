//
//  HostViewController.m
//  RTMPCDemo
//
//  Created by jianqiangzhang on 16/7/21.
//  Copyright © 2016年 EricTao. All rights reserved.
//


#import "HostViewController.h"
#import <RTMPCHybirdEngine/RTMPCHosterKit.h>
#import <RTMPCHybirdEngine/RTMPCHybirdEngineKit.h>
#import "ASHUD.h"

@interface HostViewController ()<RTMPCHosterRtmpDelegate, RTMPCHosterRtcDelegate,UIAlertViewDelegate>
@property (nonatomic, strong) UIView *cameraView;  // 推流
@property (nonatomic, strong) UIButton *closeButton;

@property (nonatomic, strong) UILabel *stateRTMPLabel;
@property (nonatomic, strong) UILabel *stateRTCLabel;

@property (nonatomic, strong) UIButton *cameraButton;
@property (nonatomic, strong) UIButton *beautyButton;
@property (nonatomic, strong) UIButton *shearButton;

@property (nonatomic, strong) UIButton *chatButton; // 聊天的按钮


@property (nonatomic, strong) RTMPCHosterKit *hosterKit;

@property (nonatomic, strong) NSMutableArray *remoteArray;

@property (nonatomic, strong) NSString *hlsUrl;

@property (nonatomic, strong) NSString *requestId;
@end

@implementation HostViewController
- (void)dealloc {
    if (self.hosterKit) {
        self.hosterKit = nil;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    self.view.backgroundColor = [UIColor whiteColor];
    self.remoteArray = [[NSMutableArray alloc] initWithCapacity:3];
    
    [self.view addSubview:self.cameraView];
    [self.view addSubview:self.closeButton];
    [self.view addSubview:self.stateRTMPLabel];
    [self.view addSubview:self.stateRTCLabel];
    [self.view addSubview:self.cameraButton];
    [self.view addSubview:self.beautyButton];
    [self.view addSubview:self.shearButton];
    // 开始推流
    self.hosterKit = [[RTMPCHosterKit alloc] initWithDelegate:self];
    self.hosterKit.rtc_delegate = self;
    [self.hosterKit SetVideoMode:RTMPC_Video_SD];
    [self.hosterKit SetVideoCapturer:self.cameraView andUseFront:YES];
    NSString *randomString = [self randomString:12];
    NSString *rtmpUrl = [NSString stringWithFormat:@"rtmp://192.168.7.207:1935/live/%@",randomString];
    self.hlsUrl = [NSString stringWithFormat:@"http://192.168.7.207:1935/live/%@.m3u8",randomString];
    
    [self.hosterKit StartPushRtmpStream:rtmpUrl];
    /**
     *  加载相关数据(大厅列表解析数据对应即可)
     */
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"hostID",@"hosterId",rtmpUrl,@"rtmp_url",self.hlsUrl,@"hls_url",self.livingName?self.livingName:[self getTopName],@"topic",randomString,@"anyrtcId", nil];
    
    NSString *jsonString = [self JSONTOString:dict];
    if(![self.hosterKit OpenRTCLine:randomString andCustomID:@"test_ios" andUserData:jsonString]) {
        NSLog(@"!!! Cann't open rtc line function, maybe you aren't set RTMPCHosterRtcDelegate");
    }
 
}
- (void)viewDidUnload
{
    [self.hosterKit clear];
}
#pragma mark - private method
- (NSString*)JSONTOString:(id)obj {
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}
- (NSString*)getTopName {
    NSArray *array = @[@"测试Anyrtc",@"Anyrtc真心效果好",@"欢迎用Anyrtc",@"视频云提供商DYNC"];
    return [array objectAtIndex:(int)arc4random()%(array.count-1)];
}
- (NSString*)randomString:(int)len {
    char* charSet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
    char* temp = malloc(len + 1);
    for (int i = 0; i < len; i++) {
        int randomPoz = (int) floor(arc4random() % strlen(charSet));
        temp[i] = charSet[randomPoz];
    }
    temp[len] = '\0';
    NSMutableString* randomString = [[NSMutableString alloc] initWithUTF8String:temp];
    free(temp);
    return randomString;
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        if (self.hosterKit && self.requestId) {
            [self.hosterKit AcceptRTCLine:self.requestId];
        }
    }else{
        if (self.hosterKit && self.requestId) {
            [self.hosterKit RejectRTCLine:self.requestId andBanToApply:YES];
        }
    }
    self.requestId = nil;
}

#pragma mark -  RTMPCHosterRtmpDelegate
// rtmp 连接成功
- (void)OnRtmpStreamOK {
    NSLog(@"OnRtmpStreamOK");
    self.stateRTMPLabel.text = @"连接RTMP服务成功";
}
// rtmp 重连次数
- (void)OnRtmpStreamReconnecting:(int) times {
    NSLog(@"OnRtmpStreamReconnecting:%d",times);
    self.stateRTMPLabel.text = [NSString stringWithFormat:@"第%d次重连中...",times];
}
// rtmp 重连次数
- (void)OnRtmpStreamStatus:(int) delayMs withNetBand:(int) netBand {
    NSLog(@"OnRtmpStreamStatus:%d withNetBand:%d",delayMs,netBand);
    self.stateRTMPLabel.text = [NSString stringWithFormat:@"RTMP延迟:%d 网络:%d",delayMs,netBand];
}
// rtmp 链接失败
- (void)OnRtmpStreamFailed:(int) code {
    NSLog(@"OnRtmpStreamFailed:%d",code);
    self.stateRTMPLabel.text = @"连接RTMP服务失败";
}
// rtmp 关闭
- (void)OnRtmpStreamClosed {
    NSLog(@"OnRtmpStreamClosed");
}
#pragma mark -  RTMPCHosterRtcDelegate
// 加入RTC成功
- (void)OnRTCOpenLineResult:(int) code/*0:OK */ withReason:(NSString*)strReason {
    NSLog(@"OnRTCOpenLineResult:%d withReason:%@",code,strReason);
    if (code == 0) {
        self.stateRTCLabel.text = @"RTC连接成功";
    }
}
// 接收别人连线的请求
- (void)OnRTCApplyToLine:(NSString*)strLivePeerID withCustomID:(NSString*)strCustomID withUserData:(NSString*)strUserData {
    NSLog(@"OnRTCApplyToLine:%@ withCustomID:%@ withUserData:%@",strLivePeerID,strCustomID,strUserData);
    if (self.requestId!=nil) {
            [self.hosterKit HangupRTCLine:self.requestId];
    }
    self.requestId = strLivePeerID;
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"%@请求连线",strCustomID] delegate:self cancelButtonTitle:@"拒绝" otherButtonTitles:@"同意", nil];
    [alertView show];
}
// 游客挂断连线
- (void)OnRTCCancelLine:(NSString*)strLivePeerID {
    NSLog(@"OnRTCCancelLine:%@",strLivePeerID);
    // 游客自己挂断
}
// 主播主动挂断游客的回调
- (void)OnRTCHangupLine:(NSString*)strLivePeerID {
    NSLog(@"OnRTCHangupLine:%@",strLivePeerID);
    // 成功之后需要删除
    for (int i=0; i<self.remoteArray.count; i++) {
        NSDictionary *dict = [self.remoteArray objectAtIndex:i];
        if ([[dict.allKeys firstObject] isEqualToString:strLivePeerID]) {
            UIView *videoView = [dict objectForKey:strLivePeerID];
            [videoView removeFromSuperview];
            [self.remoteArray removeObjectAtIndex:i];
            [self layout:i];
            break;
        }
    }
}
//RTC 通道关闭
- (void)OnRTCLineClosed:(int) code/*0:OK */ withReason:(NSString*)strReason {
    NSLog(@"OnRTCLineClosed:%d withReason:%@",code,strReason);
}
// 视频显示
- (void)OnRTCOpenVideoRender:(NSString*)strLivePeerID {
    NSLog(@"OnRTCOpenVideoRender:%@",strLivePeerID);
    UIView *videoView = [self getVideoViewWithStrID:strLivePeerID];
    [self.view addSubview:videoView];
    [self.hosterKit SetRTCVideoRender:strLivePeerID andRender:videoView];
}
// 视频离开
- (void)OnRTCCloseVideoRender:(NSString*)strLivePeerID {
    NSLog(@"OnRTCCloseVideoRender:%@",strLivePeerID);
    for (int i=0; i<self.remoteArray.count; i++) {
        NSDictionary *dict = [self.remoteArray objectAtIndex:i];
        if ([[dict.allKeys firstObject] isEqualToString:strLivePeerID]) {
            UIView *videoView = [dict objectForKey:strLivePeerID];
            [videoView removeFromSuperview];
            [self.remoteArray removeObjectAtIndex:i];
            [self layout:i];
            break;
        }
    }
}
// 普通消息
- (void)OnRTCUserMessage:(NSString*)nsCustomId withCustomName:(NSString*)nsCustomName withContent:(NSString*)nsContent {
    
}
// 弹幕
- (void)OnRTCUserBarrage:(NSString*)nsCustomId withCustomName:(NSString*)nsCustomName withContent:(NSString*)nsContent {
    
}
// 在线人数
- (void)OnRTCMemberListWillUpdate:(int)nTotalMember {
    
}
// 人员信息
- (void)OnRTCMember:(NSString*)nsCustomId withUserData:(NSString*)nsUserData {
    
}

- (void)OnRTCMemberListUpdateDone {
    
}

- (void)layout:(int)index {
    switch (index) {
        case 0:
            for (int i=0; i<self.remoteArray.count; i++) {
                NSDictionary *dict = [self.remoteArray objectAtIndex:i];
                 UIView *videoView = [dict.allValues firstObject];
                 videoView.frame = CGRectMake(videoView.frame.origin.x, CGRectGetHeight(self.view.frame)-(i+1)*videoView.frame.size.height, videoView.frame.size.width, videoView.frame.size.height);
            }
            break;
        case 1:
            if (self.remoteArray.count==2) {
                NSDictionary *dict = [self.remoteArray objectAtIndex:1];
                UIView *videoView = [dict.allValues firstObject];
                videoView.frame = CGRectMake(videoView.frame.origin.x, CGRectGetHeight(self.view.frame)-(2)*videoView.frame.size.height, videoView.frame.size.width, videoView.frame.size.height);
            }
            break;
            
        default:
            break;
    }
}

#pragma mark - button events

- (void)closeButtonEvent:(UIButton*)sender {
    if (self.hosterKit) {
        [self.hosterKit StopRtmpStream];
        [self.hosterKit clear];
        self.hosterKit = nil;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}
- (void)cameraButtonEvent:(UIButton*)sender {
    if (self.hosterKit) {
        [self.hosterKit SwitchCamera];
    }
}
- (void)beautyButtonEvent:(UIButton*)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.hosterKit SetBeautyEnable:NO];
    }else{
        [self.hosterKit SetBeautyEnable:YES];
    }
}
- (void)shearButtonEvent:(UIButton*)sender {
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = self.hlsUrl;
    [ASHUD showHUDWithCompleteStyleInView:self.view content:@"直播连接复制成功！" icon:nil];
}
- (void)cButtonEvent:(UIButton*)button {
    int tag = (int)button.tag-300;
    if (tag<self.remoteArray.count) {
        NSDictionary *dict = [self.remoteArray objectAtIndex:tag];
        if (self.hosterKit) {
            [self.hosterKit HangupRTCLine:[[dict allKeys] firstObject]];
            
        }
    }
}

#pragma mark - get
- (UIView*)getVideoViewWithStrID:(NSString*)publishID {
    NSInteger num = self.remoteArray.count;
    CGFloat videoHeight = CGRectGetHeight(self.view.frame)/4;
    CGFloat videoWidth = videoHeight*3/4;
    
    UIView *pullView;
    switch (num) {
        case 0:
            pullView = [[UIView alloc] init];
            pullView.frame = CGRectMake(CGRectGetWidth(self.view.frame)-videoWidth, 3*videoHeight, videoWidth, videoHeight);
            pullView.layer.borderColor = [UIColor grayColor].CGColor;
            pullView.layer.borderWidth = .5;
            break;
        case 1:
            pullView = [[UIView alloc] init];
           pullView.frame = CGRectMake(CGRectGetWidth(self.view.frame)-videoWidth, 2*videoHeight, videoWidth, videoHeight);
            pullView.layer.borderColor = [UIColor grayColor].CGColor;
            pullView.layer.borderWidth = .5;
            break;
        case 2:
            pullView = [[UIView alloc] init];
              pullView.frame = CGRectMake(CGRectGetWidth(self.view.frame)-videoWidth, videoHeight, videoWidth, videoHeight);
            pullView.layer.borderColor = [UIColor grayColor].CGColor;
            pullView.layer.borderWidth = .5;
            break;
            
        default:
            break;
    }
    UIButton *cButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cButton.tag = 300+self.remoteArray.count;
    cButton.frame = CGRectMake(CGRectGetWidth(pullView.frame)-30,10, 20, 20);
    [cButton addTarget:self action:@selector(cButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [cButton setImage:[UIImage imageNamed:@"close_preview"] forState:UIControlStateNormal];
    [pullView addSubview:cButton];

    
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:pullView,publishID, nil];
    [self.remoteArray addObject:dict];
    return pullView;
}

- (UIView*)cameraView {
    if (!_cameraView) {
        _cameraView = [[UIView alloc] init];
        _cameraView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
        _cameraView.layer.borderColor = [UIColor grayColor].CGColor;
        _cameraView.layer.borderWidth = .5;
    }
    return _cameraView;
}
- (UIButton*)closeButton {
    if(!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"close_preview"] forState:UIControlStateNormal];
        [_closeButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closeButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        _closeButton.frame = CGRectMake(CGRectGetMaxX(self.view.frame)-60, 20,40,40);
    }
    return _closeButton;
}
- (UILabel*)stateRTMPLabel {
    if (!_stateRTMPLabel) {
        _stateRTMPLabel = [UILabel new];
        _stateRTMPLabel.textColor = [UIColor redColor];
        _stateRTMPLabel.font = [UIFont systemFontOfSize:12];
        _stateRTMPLabel.textAlignment = NSTextAlignmentRight;
        _stateRTMPLabel.frame = CGRectMake(CGRectGetMaxX(self.view.frame)/2-10, CGRectGetMaxY(self.closeButton.frame)+30, CGRectGetMaxX(self.view.frame)/2, 20);
        _stateRTMPLabel.text = @"未连接";
    }
    return _stateRTMPLabel;
}
- (UILabel*)stateRTCLabel {
    if (!_stateRTCLabel) {
        _stateRTCLabel = [UILabel new];
        _stateRTCLabel.textColor = [UIColor redColor];
        _stateRTCLabel.font = [UIFont systemFontOfSize:12];
        _stateRTCLabel.textAlignment = NSTextAlignmentRight;
        _stateRTCLabel.frame = CGRectMake(CGRectGetMaxX(self.view.frame)/2-10, CGRectGetMinY(self.stateRTMPLabel.frame)-30, CGRectGetMaxX(self.view.frame)/2, 20);
        _stateRTCLabel.text = @"未连接";
    }
    return _stateRTCLabel;
}
- (UIButton*)cameraButton {
    if (!_cameraButton) {
        _cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cameraButton setImage:[UIImage imageNamed:@"camra_preview"] forState:UIControlStateNormal];
        [_cameraButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_cameraButton addTarget:self action:@selector(cameraButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        _cameraButton.frame = CGRectMake(CGRectGetMinX(self.closeButton.frame)-60, 20,40,40);
    }
    return _cameraButton;
}
- (UIButton*)beautyButton {
    if (!_beautyButton) {
        _beautyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_beautyButton setImage:[UIImage imageNamed:@"camra_beauty"] forState:UIControlStateNormal];
        [_beautyButton setImage:[UIImage imageNamed:@"camra_beauty_close"] forState:UIControlStateSelected];
        [_beautyButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_beautyButton addTarget:self action:@selector(beautyButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        _beautyButton.frame = CGRectMake(CGRectGetMinX(self.cameraButton.frame)-60, 20,40,40);
    }
    return _beautyButton;
}
- (UIButton*)shearButton {
    if (!_shearButton) {
        _shearButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shearButton setImage:[UIImage imageNamed:@"btn_share_normal"] forState:UIControlStateNormal];
        [_shearButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_shearButton addTarget:self action:@selector(shearButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        _shearButton.frame = CGRectMake(CGRectGetMinX(self.beautyButton.frame)-60, 20,40,40);
    }
    return _shearButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end


