//
//  HostViewController.m
//  RTMPCDemo
//
//  Created by jianqiangzhang on 16/7/21.
//  Copyright © 2016年 EricTao. All rights reserved.
//


#import "HostViewController.h"
#import "AppDelegate.h"

#import <RTMPCHybirdEngine/RTMPCHosterKit.h>
#import <RTMPCHybirdEngine/RTCCommon.h>
#import "WXApi.h"
#import "ASHUD.h"
#import "UIImageView+WebCache.h"
#import "UMSocial.h"

#import "KeyBoardInputView.h"
#import "MessageTableView.h"

#import "DanmuLaunchView.h"
#import "DanmuItemView.h"
#import "NetUtils.h"
#import "AudioShowView.h"   


@interface HostViewController ()<RTMPCHosterRtmpDelegate, RTMPCHosterRtcDelegate,UIAlertViewDelegate,KeyBoardInputViewDelegate>
{
    UITapGestureRecognizer *tapGesture;
    UIAlertView *alertView;
}
@property (nonatomic, strong) UIView *cameraView;  // 推流
@property (nonatomic, strong) UIButton *closeButton;

@property (nonatomic, strong) UILabel *stateRTMPLabel;
@property (nonatomic, strong) UILabel *stateRTCLabel;
@property (nonatomic, strong) UILabel *lineNumLabel;

@property (nonatomic, strong) UIButton *cameraButton;
@property (nonatomic, strong) UIButton *beautyButton;
@property (nonatomic, strong) UIButton *shearButton;

@property (nonatomic, strong) UIButton *chatButton; // 聊天的按钮
@property (nonatomic, strong) KeyBoardInputView *keyBoardView; // 聊天输入框
@property (nonatomic, strong) MessageTableView *messageTableView; // 聊天面板

@property (nonatomic, strong) DanmuLaunchView *danmuView;

@property (nonatomic, strong) RTMPCHosterKit *hosterKit;

@property (nonatomic, strong) NSMutableArray *remoteArray;

@property (nonatomic, strong) NSString *rtmpUrl;

@property (nonatomic, strong) NSString *hlsUrl;

@property (nonatomic, strong) NSString *requestId;

@property (nonatomic, strong) NSString *userID;

@property (nonatomic, strong) NSString *nickName;

@property (nonatomic, strong) NSString *userIcon;

@property (nonatomic, strong) NSString *randomStr;

@property (nonatomic, assign) int remoteViewTag;

// 用于关闭录像
@property (nonatomic, strong) NSString *vodSvrId;// 录制的服务ID;
@property (nonatomic, strong) NSString *vodResTag;// 录制的Tag

@end

@implementation HostViewController
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (self.hosterKit) {
        self.hosterKit = nil;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    self.view.backgroundColor = [UIColor whiteColor];
    self.remoteArray = [[NSMutableArray alloc] initWithCapacity:3];
    self.remoteViewTag = 300;
    [self.view addSubview:self.cameraView];
    [self.view addSubview:self.closeButton];
    [self.view addSubview:self.stateRTMPLabel];
    [self.view addSubview:self.stateRTCLabel];
    [self.view addSubview:self.lineNumLabel];
    [self.view addSubview:self.cameraButton];
    [self.view addSubview:self.beautyButton];
    [self.view addSubview:self.shearButton];
    // for chat
    [self.view addSubview:self.chatButton];
    [self.view addSubview:self.keyBoardView];
    [self.view addSubview:self.messageTableView];
    [self.view addSubview:self.danmuView];
    
    self.userID = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserID"];
    self.nickName = [[NSUserDefaults standardUserDefaults] valueForKey:@"NickName"];
    self.userIcon = [[NSUserDefaults standardUserDefaults] valueForKey:@"IconUrl"]?[[NSUserDefaults standardUserDefaults] valueForKey:@"IconUrl"]:@"";
    self.hosterKit = [[RTMPCHosterKit alloc] initWithDelegate:self withCaptureDevicePosition:RTMPC_SCRN_Portrait withLivingAudioOnly:NO withAudioDetect:NO];
    self.hosterKit.rtc_delegate = self;
    [self.hosterKit SetVideoMode:_rtmpVideoMode];
    [self.hosterKit SetVideoCapturer:self.cameraView andUseFront:YES];
    [self.hosterKit SetNetAdjustMode:RTMP_NA_Fast];
    self.randomStr = [self randomString:12];
    
    // 允许对焦(不调用此方法，自动对焦关闭)
    [self.hosterKit SetCamerafocusImage:[UIImage imageNamed:@"touch_focus_x"]];

    // 推流地址自己换掉自己的即可
    self.rtmpUrl = [NSString stringWithFormat:@"%@/%@",rtmpServer,self.randomStr];
    self.hlsUrl = [NSString stringWithFormat:@"%@/%@.m3u8",rtmpServer,self.randomStr];
    
    [self.hosterKit StartPushRtmpStream:self.rtmpUrl];
    /**
     *  加载相关数据(大厅列表解析数据对应即可)
     */
     NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:self.userID?self.userID:@"",@"hosterId",self.rtmpUrl,@"rtmp_url",self.hlsUrl,@"hls_url",self.livingName?self.livingName:[self getTopName],@"topic",self.randomStr,@"anyrtcId",[NSNumber numberWithBool:_isAudioLiving],@"isAudioOnly",self.nickName?self.nickName:@"",@"NickName",self.userIcon?self.userIcon:@"",@"IconUrl",[NSNumber numberWithBool:_isVideoAudioLiving],@"isVideoAudioLiving", nil];
    
    
    NSString *jsonString = [self JSONTOString:dict];
    if(![self.hosterKit OpenRTCLine:self.randomStr andCustomID:self.userID andUserData:jsonString]) {
        NSLog(@"!!! Cann't open rtc line function, maybe you aren't set RTMPCHosterRtcDelegate");
    }

    [self registerForKeyboardNotifications];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.hosterKit clear];
}
#pragma mark - private method
- (void) registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEvent:)];
    [self.view addGestureRecognizer:tapGesture];
}


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
- (id)JSONValue:(NSString*)jsonStrong
{
    if ([jsonStrong isKindOfClass:[NSDictionary class]]) {
        return jsonStrong;
    }
    NSData* data = [jsonStrong dataUsingEncoding:NSUTF8StringEncoding];
    __autoreleasing NSError* error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error != nil) return nil;
    return result;
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
// 获取错误信息
- (NSString*)getErrorInfoForRtc:(int)code {
    switch (code) {
        case AnyRTC_OK:
            return @"RTC:链接成功";
            break;
        case AnyRTC_UNKNOW:
            return @"RTC:未知错误";
            break;
        case AnyRTC_EXCEPTION:
            return @"RTC:SDK调用异常";
            break;
        case AnyRTC_NET_ERR:
            return @"RTC:网络错误";
            break;
        case AnyRTC_LIVE_ERR:
            return @"RTC:直播出错";
            break;
        case AnyRTC_BAD_REQ:
            return @"RTC:服务不支持的错误请求";
            break;
        case AnyRTC_AUTH_FAIL:
            return @"RTC:认证失败";
            break;
        case AnyRTC_NO_USER:
            return @"RTC:此开发者信息不存在";
            break;
        case AnyRTC_SQL_ERR:
            return @"RTC: 服务器内部数据库错误";
            break;
        case AnyRTC_ARREARS:
            return @"RTC:账号欠费";
            break;
        case AnyRTC_LOCKED:
            return @"RTC:账号被锁定";
            break;
        case AnyRTC_FORCE_EXIT:
            return @"RTC:强制离开";
            break;
        default:
            break;
    }
    return @"未知错误";
}


#pragma mark - KeyBoardInputViewDelegate
// 发送消息
- (void)keyBoardSendMessage:(NSString*)message withDanmu:(BOOL)danmu {
    if (message.length == 0) {
        return;
    }
    if (danmu) {
        // 发送弹幕消息
        if (self.danmuView) {
            DanmuItem *item = [[DanmuItem alloc] init];
            item.u_userID = self.userID;
            item.u_nickName = self.nickName;
            item.thumUrl = self.userIcon;
            item.content = message;
            [self.danmuView setModel:item];
        }
        if (self.hosterKit) {
            [self.hosterKit SendBarrage:self.nickName andCustomHeader:self.userIcon andContent:message];
        }
    }else{
        
        // 发送普通消息
        MessageModel *model = [[MessageModel alloc] init];
        
        [model setModel:self.userID withName:self.nickName withIcon:self.userIcon withType:CellNewChatMessageType withMessage:message];
        [self.messageTableView sendMessage:model];
        
        if (self.hosterKit) {
            [self.hosterKit SendUserMsg:self.nickName andCustomHeader:self.userIcon andContent:message];
        }
        
    }
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        if (self.hosterKit && self.requestId) {
            BOOL isScuess = [self.hosterKit AcceptRTCLine:self.requestId];
            if (!isScuess) {
                [ASHUD showHUDWithCompleteStyleInView:self.view content:@"连麦人数已慢" icon:nil];
                [self.hosterKit RejectRTCLine:self.requestId andBanToApply:YES];
            }else{
                 [self.hosterKit AcceptRTCLine:self.requestId];
            }
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
    __weak typeof(self)weakSelf = self;
    // 请求录像
    [[NetUtils shead] recordRtmpSteam:self.rtmpUrl withAnyrtcID:self.randomStr withResID:self.randomStr withResult:^(NSDictionary *dict, NSError *error, int code) {
        if (code == 200) {
            weakSelf.vodSvrId = [dict objectForKey:@"VodSvrId"];
            weakSelf.vodResTag = [dict objectForKey:@"VodResTag"];
        }
        NSLog(@"");
    }];
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
- (void)OnRtmpAudioLevel:(NSString *)nsCustomID withLevel:(int)Level {
    NSLog(@"OnRtmpAudioLevel:%@ withLevel:%d",nsCustomID,Level);
}

#pragma mark -  RTMPCHosterRtcDelegate
// 加入RTC成功
- (void)OnRTCOpenLineResult:(int) code/*0:OK */ withReason:(NSString*)strReason {
    NSLog(@"OnRTCOpenLineResult:%d withReason:%@",code,strReason);
    self.stateRTCLabel.text = [self getErrorInfoForRtc:code];
    if (code == 0) {
        self.stateRTCLabel.text = @"RTC连接成功";
    }
}
// 接收别人连线的请求
- (void)OnRTCApplyToLine:(NSString*)strLivePeerID withCustomID:(NSString*)strCustomID withUserData:(NSString*)strUserData {
    NSLog(@"OnRTCApplyToLine:%@ withCustomID:%@ withUserData:%@",strLivePeerID,strCustomID,strUserData);
    if (self.requestId!=nil) {
        [self.hosterKit HangupRTCLine:self.requestId];
        if (alertView) {
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
            alertView = nil;
        }
    }
    self.requestId = strLivePeerID;
    
    alertView = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"%@请求连线",strCustomID] delegate:self cancelButtonTitle:@"拒绝" otherButtonTitles:@"同意", nil];
    [alertView show];
}
// 游客挂断连线
- (void)OnRTCCancelLine:(NSString*)strLivePeerID {
    NSLog(@"OnRTCCancelLine:%@",strLivePeerID);
    if (self.isVideoAudioLiving) {
        // 游客自己挂断
        for (int i=0; i<self.remoteArray.count; i++) {
            NSDictionary *dict = [self.remoteArray objectAtIndex:i];
            if ([[dict objectForKey:@"PeerID"] isEqualToString:strLivePeerID]) {
                UIView *videoView = [dict objectForKey:@"View"];
                [videoView removeFromSuperview];
                [self.remoteArray removeObjectAtIndex:i];
                [self layoutAudio:i];
                break;
            }
        }
        if ([self.requestId isEqualToString:strLivePeerID]) {
            self.requestId = nil;
        }

    }else{
        // 游客自己挂断
        BOOL find = NO;
        for (int i=0; i<self.remoteArray.count; i++) {
            NSDictionary *dict = [self.remoteArray objectAtIndex:i];
            NSArray *keyArray = dict.allKeys;
            for (NSString *peerID in keyArray) {
                if ([peerID isEqualToString:strLivePeerID]) {
                    UIView *videoView = [dict objectForKey:strLivePeerID];
                    [videoView removeFromSuperview];
                    [self.remoteArray removeObjectAtIndex:i];
                    [self layoutVideo:i];
                    find = YES;
                    break;
                }
            }
            if (find) {
                break;
            }
        }

    }
}

//RTC 通道关闭
- (void)OnRTCLineClosed:(int) code/*0:OK */ withReason:(NSString*)strReason {
    NSLog(@"OnRTCLineClosed:%d withReason:%@",code,strReason);
    // 主播离开了
    if (code == 207) {
        [ASHUD showHUDWithCompleteStyleInView:self.view content:@"测试账号限制三分钟" icon:nil];
    }
    
    if (self.hosterKit) {
        [self.hosterKit clear];
        self.hosterKit = nil;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.navigationController popViewControllerAnimated:YES];
    });

}
// 视频显示
- (void)OnRTCOpenVideoRender:(NSString*)strLivePeerID withCustomID:(NSString *)nsCustomID{
    NSLog(@"OnRTCOpenVideoRender:%@",strLivePeerID);
    UIView *videoView = [self getVideoViewWithStrID:strLivePeerID];
    [self.view addSubview:videoView];
    // 参照点~
    [self.view insertSubview:videoView belowSubview:self.chatButton];
    
    [self.hosterKit SetRTCVideoRender:strLivePeerID andRender:videoView];
}
// 视频离开
- (void)OnRTCCloseVideoRender:(NSString*)strLivePeerID withCustomID:(NSString *)nsCustomID{
    NSLog(@"OnRTCCloseVideoRender:%@",strLivePeerID);
    for (int i=0; i<self.remoteArray.count; i++) {
        NSDictionary *dict = [self.remoteArray objectAtIndex:i];
        if ([[dict objectForKey:@"PeerID"] isEqualToString:strLivePeerID]) {
            UIView *videoView = [dict objectForKey:@"View"];
            [videoView removeFromSuperview];
            [self.remoteArray removeObjectAtIndex:i];
            [self layoutVideo:i];
            break;
        }
    }
    
}
// 音频直播连麦回调
- (void)OnRTCOpenAudioLine:(NSString*)strLivePeerID withCustomID:(NSString *)nsCustomID {
    UIView *videoView = [self getAudioViewWithStrID:strLivePeerID];
    if (videoView) {
        [self.view addSubview:videoView];
        // 参照点~
        [self.view insertSubview:videoView belowSubview:self.chatButton];
    }
   
}
// 音频直播取消连麦回调
- (void)OnRTCCloseAudioLine:(NSString*)strLivePeerID withCustomID:(NSString *)nsCustomID {
    for (int i=0; i<self.remoteArray.count; i++) {
        NSDictionary *dict = [self.remoteArray objectAtIndex:i];
        if ([[dict objectForKey:@"PeerID"] isEqualToString:strLivePeerID]) {
            UIView *videoView = [dict objectForKey:@"View"];
            [videoView removeFromSuperview];
            [self.remoteArray removeObjectAtIndex:i];
            [self layoutAudio:i];
            break;
        }
    }

}
// 普通消息
- (void)OnRTCUserMessage:(NSString *)nsCustomId withCustomName:(NSString *)nsCustomName withCustomHeader:(NSString *)nsCustomHeader withContent:(NSString *)nsContent {
    // 发送普通消息
    MessageModel *model = [[MessageModel alloc] init];
    [model setModel:nsCustomId withName:nsCustomName withIcon:@"游客头像" withType:CellNewChatMessageType withMessage:nsContent];
    [self.messageTableView sendMessage:model];
}
// 弹幕
- (void)OnRTCUserBarrage:(NSString *)nsCustomId withCustomName:(NSString *)nsCustomName withCustomHeader:(NSString *)nsCustomHeader withContent:(NSString *)nsContent {
    if (self.danmuView) {
        DanmuItem *item = [[DanmuItem alloc] init];
        item.u_userID = nsCustomId;
        item.u_nickName = nsCustomName;
        item.thumUrl = nsCustomHeader;
        item.content = nsContent;
        [self.danmuView setModel:item];
    }
}
// 在线人数
- (void)OnRTCMemberListWillUpdate:(int)nTotalMember {
    @autoreleasepool {
        self.lineNumLabel.text = [NSString stringWithFormat:@"在线观看人数:%d",nTotalMember];
    }
}
// 人员信息
- (void)OnRTCMember:(NSString*)nsCustomId withUserData:(NSString*)nsUserData {
    NSDictionary *customData = [self JSONValue:nsUserData];
    if (customData) {
        NSString *userName = [customData objectForKey:@"nickName"];
        // 人员进会信息
        MessageModel *model = [[MessageModel alloc] init];
        [model setModel:nsCustomId withName:userName withIcon:@"头像" withType:CellNewChatMessageType withMessage:@"来了，欢迎~"];
        [self.messageTableView sendMessage:model];
    }
}

- (void)OnRTCMemberListUpdateDone {
    
}

- (void)layoutVideo:(int)index {
    switch (index) {
        case 0:
            for (int i=0; i<self.remoteArray.count; i++) {
                NSDictionary *dict = [self.remoteArray objectAtIndex:i];
                UIView *videoView = [dict valueForKey:@"View"];
                videoView.frame = CGRectMake(videoView.frame.origin.x, CGRectGetHeight(self.view.frame)-(i+1)*videoView.frame.size.height, videoView.frame.size.width, videoView.frame.size.height);
            }
            break;
        case 1:
            if (self.remoteArray.count==2) {
                NSDictionary *dict = [self.remoteArray objectAtIndex:1];
                UIView *videoView = [dict valueForKey:@"View"];
                videoView.frame = CGRectMake(videoView.frame.origin.x, CGRectGetHeight(self.view.frame)-(2)*videoView.frame.size.height, videoView.frame.size.width, videoView.frame.size.height);
            }
            break;
            
        default:
            break;
    }
}
- (void)layoutAudio:(int)index {
    switch (index) {
        case 0:
            for (int i=0; i<self.remoteArray.count; i++) {
                NSDictionary *dict = [self.remoteArray objectAtIndex:i];
                UIView *videoView = [dict valueForKey:@"View"];
                videoView.frame = CGRectMake(videoView.frame.origin.x, CGRectGetHeight(self.view.frame)-(i+1)*videoView.frame.size.height, videoView.frame.size.width, videoView.frame.size.height);
            }
            break;
        case 1:
            if (self.remoteArray.count==2) {
                NSDictionary *dict = [self.remoteArray objectAtIndex:1];
                UIView *videoView = [dict valueForKey:@"View"];
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
        [self.hosterKit clear];
        self.hosterKit = nil;
    }
    [[NetUtils shead] closerEecRtmpStream:self.vodSvrId withVodResTag:self.vodResTag withResult:^(NSError *error, int code) {
        NSLog(@"");
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
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
#warning 根据你们平台需要给与响应的分享链接（HLS）
    // 判断是否安装微信
    if ([WXApi isWXAppInstalled]) {
        NSString *shareText = [NSString stringWithFormat:@"%@ 视频互动直播正在进行,快来围观...",self.livingName];
        // 微信好友
        [UMSocialData defaultData].extConfig.wechatSessionData.title = @"RTMPC连麦";
        [UMSocialData defaultData].extConfig.wechatSessionData.wxMessageType = UMSocialWXMessageTypeWeb;
        NSString *urlStr =  [NSString stringWithFormat:@"http://www.huilive.cc/rtmpc-demo/?%@",self.randomStr];
        
        UMSocialUrlResource *resource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeWeb url:urlStr];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:shareText image:nil location:nil urlResource:resource presentedController:nil completion:^(UMSocialResponseEntity *shareResponse){
            if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
            }
        }];
        
    }else{
        UIPasteboard *pboard = [UIPasteboard generalPasteboard];
        pboard.string =  [NSString stringWithFormat:@"http://www.huilive.cc/rtmpc-demo/?%@",self.randomStr];//self.hlsUrl;
        [ASHUD showHUDWithCompleteStyleInView:self.view content:@"直播连接复制成功！" icon:nil];
    }
    
}
- (void)cButtonEvent:(UIButton*)button {
    if (self.isVideoAudioLiving) {
        for (int i=0; i<self.remoteArray.count; i++) {
            NSDictionary *dict = [self.remoteArray objectAtIndex:i];
            if ([[dict objectForKey:@"buttonTag"] isEqualToString:[NSString stringWithFormat:@"%ld",(long)button.tag]]) {
                if (self.hosterKit) {
                    [self.hosterKit HangupRTCLine:[dict objectForKey:@"PeerID"]];
                }
                if ( [[dict objectForKey:@"PeerID"] isEqualToString:self.requestId]) {
                    self.requestId = nil;
                }
                UIView *videoView = [dict objectForKey:@"View"];
                [videoView removeFromSuperview];
                [self.remoteArray removeObjectAtIndex:i];
                [self layoutAudio:i];
                break;
            }
        }

    }else{
        for (NSDictionary *dict in self.remoteArray) {
            if ([[dict objectForKey:@"buttonTag"] isEqualToString:[NSString stringWithFormat:@"%ld",(long)button.tag]]) {
                if (self.hosterKit) {
                    NSLog(@"%@",[dict objectForKey:@"PeerID"]);
                    [self.hosterKit HangupRTCLine:[dict objectForKey:@"PeerID"]];
                    break;
                }
            }
        }

    }
    
}
- (void)chatButtonEvent:(UIButton*)sender {
    if (self.keyBoardView) {
        [self.keyBoardView editBeginTextField];
    }
}
// 键盘弹起
- (void)keyboardWasShown:(NSNotification*)notification {
    NSDictionary *info = [notification userInfo];
    CGRect keyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if (self.keyBoardView) {
        self.keyBoardView.frame = CGRectMake(self.keyBoardView.frame.origin.x, CGRectGetMaxY(self.view.frame)-CGRectGetHeight(self.keyBoardView.frame)-keyboardRect.size.height, CGRectGetWidth(self.keyBoardView.frame), CGRectGetHeight(self.keyBoardView.frame));
    }
    
    if (self.messageTableView) {
        self.messageTableView.frame = CGRectMake(0, CGRectGetMaxY(self.view.frame)-CGRectGetHeight(self.keyBoardView.frame)-keyboardRect.size.height - CGRectGetHeight(self.messageTableView.frame) -10, CGRectGetWidth(self.messageTableView.frame), 120);
    }
    if (self.danmuView) {
        self.danmuView.frame = CGRectMake(self.danmuView.frame.origin.x, CGRectGetMinY(self.messageTableView.frame)-CGRectGetHeight(self.danmuView.frame), CGRectGetWidth(self.danmuView.frame), CGRectGetHeight(self.danmuView.frame));
    }
}
// 键盘隐藏
- (void)keyboardWasHidden:(NSNotification*)notification {
    if (self.keyBoardView) {
        self.keyBoardView.frame = CGRectMake(0, CGRectGetMaxY(self.view.frame), self.view.bounds.size.width, 44);
    }
    if (self.messageTableView) {
        self.messageTableView.frame = CGRectMake(0, CGRectGetMaxY(self.view.frame)-180, CGRectGetWidth(self.view.frame)/3*2, 120);
    }
    if (self.danmuView) {
        self.danmuView.frame = CGRectMake(self.danmuView.frame.origin.x, CGRectGetMinY(self.messageTableView.frame)-CGRectGetHeight(self.danmuView.frame), CGRectGetWidth(self.danmuView.frame), CGRectGetHeight(self.danmuView.frame));
    }
}
- (void)tapEvent:(UITapGestureRecognizer*)recognizer {
    CGPoint point = [recognizer locationInView:self.view];
    CGRect rect = [self.view convertRect:self.keyBoardView.frame toView:self.view];
    if (CGRectContainsPoint(rect, point)) {
        
    }else{
        if (self.keyBoardView.isEdit) {
            [self.keyBoardView editEndTextField];
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
    cButton.tag = self.remoteViewTag;
    cButton.frame = CGRectMake(CGRectGetWidth(pullView.frame)-30,10, 20, 20);
    [cButton addTarget:self action:@selector(cButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [cButton setImage:[UIImage imageNamed:@"close_preview"] forState:UIControlStateNormal];
    [pullView addSubview:cButton];
    
    
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:pullView,@"View",publishID,@"PeerID", [NSString stringWithFormat:@"%d",self.remoteViewTag],@"buttonTag",nil];
    [self.remoteArray addObject:dict];
    self.remoteViewTag++;
    return pullView;
}

- (AudioShowView*)getAudioViewWithStrID:(NSString*)publishID {
   
    BOOL isFind = NO;
    for (NSDictionary *dict in self.remoteArray) {
        if ([[dict objectForKey:@"PeerID"] isEqualToString:publishID]) {
            isFind = YES;
            break;
        }
    }
    if (isFind) {
        return nil;
    }
    NSInteger num = self.remoteArray.count;
    CGFloat videoHeight = CGRectGetHeight(self.view.frame)/8;
    CGFloat videoWidth = videoHeight;
    
    AudioShowView *pullView;
    switch (num) {
        case 0:
            pullView = [[AudioShowView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)-videoWidth, 7*videoHeight, videoWidth, videoHeight)];
            break;
        case 1:
            pullView = [[AudioShowView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)-videoWidth, 6*videoHeight, videoWidth, videoHeight)];
            break;
        case 2:
            pullView = [[AudioShowView alloc] initWithFrame: CGRectMake(CGRectGetWidth(self.view.frame)-videoWidth, 5*videoHeight, videoWidth, videoHeight)];
            break;
            
        default:
            break;
    }
   
    [pullView headUrl:@"" withName:@"" withID:publishID];
    
    UIButton *cButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cButton.tag = self.remoteViewTag;
    cButton.frame = CGRectMake(CGRectGetWidth(pullView.frame)-30,10, 20, 20);
    [cButton addTarget:self action:@selector(cButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [cButton setImage:[UIImage imageNamed:@"close_preview"] forState:UIControlStateNormal];
    [pullView addSubview:cButton];
    
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:pullView,@"View",publishID,@"PeerID", [NSString stringWithFormat:@"%d",self.remoteViewTag],@"buttonTag",nil];
    [self.remoteArray addObject:dict];
    self.remoteViewTag++;
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

- (UILabel*)stateRTCLabel {
    if (!_stateRTCLabel) {
        _stateRTCLabel = [UILabel new];
        _stateRTCLabel.textColor = [UIColor redColor];
        _stateRTCLabel.font = [UIFont systemFontOfSize:12];
        _stateRTCLabel.textAlignment = NSTextAlignmentRight;
        _stateRTCLabel.frame = CGRectMake(CGRectGetMaxX(self.view.frame)/2-10, CGRectGetMaxY(self.closeButton.frame), CGRectGetMaxX(self.view.frame)/2, 25);
        _stateRTCLabel.text = @"未连接";
    }
    return _stateRTCLabel;
}
- (UILabel*)stateRTMPLabel {
    if (!_stateRTMPLabel) {
        _stateRTMPLabel = [UILabel new];
        _stateRTMPLabel.textColor = [UIColor redColor];
        _stateRTMPLabel.font = [UIFont systemFontOfSize:12];
        _stateRTMPLabel.textAlignment = NSTextAlignmentRight;
        _stateRTMPLabel.frame = CGRectMake(CGRectGetMaxX(self.view.frame)/2-10, CGRectGetMaxY(self.stateRTCLabel.frame), CGRectGetMaxX(self.view.frame)/2, 25);
        _stateRTMPLabel.text = @"未连接";
    }
    return _stateRTMPLabel;
}
- (UILabel*)lineNumLabel {
    if (!_lineNumLabel) {
        _lineNumLabel = [UILabel new];
        _lineNumLabel.textColor = [UIColor blueColor];
        _lineNumLabel.font = [UIFont systemFontOfSize:12];
        _lineNumLabel.textAlignment = NSTextAlignmentRight;
        _lineNumLabel.frame = CGRectMake(CGRectGetMaxX(self.view.frame)/2-10, CGRectGetMaxY(self.stateRTMPLabel.frame), CGRectGetMaxX(self.view.frame)/2, 25);
        _lineNumLabel.text = @"";
    }
    return _lineNumLabel;
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

- (UIButton*)chatButton {
    if (!_chatButton) {
        _chatButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_chatButton setImage:[UIImage imageNamed:@"btn_chat_normal"] forState:UIControlStateNormal];
        [_chatButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_chatButton addTarget:self action:@selector(chatButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        _chatButton.frame = CGRectMake(10, CGRectGetMaxY(self.view.frame)-50,40,40);
    }
    return _chatButton;
}
- (KeyBoardInputView*)keyBoardView {
    if (!_keyBoardView) {
        _keyBoardView = [[KeyBoardInputView alloc] initWityStyle:KeyBoardInputViewTypeNomal];
        _keyBoardView.backgroundColor = [UIColor clearColor];
        _keyBoardView.frame = CGRectMake(0, CGRectGetMaxY(self.view.frame), self.view.bounds.size.width, 44);
        _keyBoardView.delegate = self;
    }
    return _keyBoardView;
}
- (MessageTableView*)messageTableView {
    if (!_messageTableView) {
        _messageTableView = [[MessageTableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.view.frame)-180, CGRectGetWidth(self.view.frame)/3*2, 120)];
    }
    return _messageTableView;
}

- (DanmuLaunchView*)danmuView {
    if (!_danmuView) {
        _danmuView = [[DanmuLaunchView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(self.messageTableView.frame)-(ItemHeight*3+ItemSpace*2), self.view.frame.size.width, ItemHeight*3+ItemSpace*2)];
    }
    return _danmuView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end


