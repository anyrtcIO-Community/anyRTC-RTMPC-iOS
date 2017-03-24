//
//  GuestViewController.m
//  RTMPCDemo
//
//  Created by jianqiangzhang on 16/7/21.
//  Copyright © 2016年 EricTao. All rights reserved.
//

#import "GuestViewController.h"
#import <RTMPCHybirdEngine/RTMPCGuestKit.h>
#import "ASHUD.h"
#import "KeyBoardInputView.h"
#import "MessageTableView.h"

#import "DanmuItemView.h"
#import "DanmuLaunchView.h"

@interface GuestViewController ()<RTMPCGuestRtmpDelegate, RTMPCGuestRtcDelegate,KeyBoardInputViewDelegate> {
    bool use_cap_;
    UITapGestureRecognizer *tapGesture;
}
@property (nonatomic, strong) UIView *mainView;  // 主屏幕
@property (nonatomic, strong) UIButton *handupButton;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UILabel *lineNumLabel;

@property (nonatomic, strong) RTMPCGuestKit *guestKit;

@property (nonatomic, strong) NSMutableArray *remoteArray;


@property (nonatomic, strong) UIButton *chatButton; // 聊天的按钮
@property (nonatomic, strong) KeyBoardInputView *keyBoardView; // 聊天输入框
@property (nonatomic, strong) MessageTableView *messageTableView; // 聊天面板

@property (nonatomic, strong) DanmuLaunchView *danmuView;

@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *userIcon;

@end

@implementation GuestViewController
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (self.guestKit) {
        self.guestKit = nil;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    self.view.backgroundColor = [UIColor whiteColor];
    self.remoteArray = [[NSMutableArray alloc] initWithCapacity:3];
    
    [self.view addSubview:self.mainView];
    [self.view addSubview:self.handupButton];
    [self.view addSubview:self.closeButton];
    [self.view addSubview:self.lineNumLabel];
    
    [self.view addSubview:self.chatButton];
    [self.view addSubview:self.keyBoardView];
    [self.view addSubview:self.messageTableView];
    
    [self.view addSubview:self.danmuView];
    
    self.guestKit = [[RTMPCGuestKit alloc] initWithDelegate:self withCaptureDevicePosition:RTMPC_SCRN_Portrait withLivingAudioOnly:NO withAudioDetect:NO];
    self.guestKit.rtc_delegate = self;
   // [self.guestKit StartRtmpPlay:@"rtmp://strtmpplay.cdn.suicam.com/sclive/58232" andRender:self.mainView];
    [self.guestKit StartRtmpPlay:self.livingItem.rtmp_url andRender:self.mainView];
    [self.guestKit setVideoContentMode:VideoShowModeScaleAspectFill];
    self.mainView.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary* views = NSDictionaryOfVariableBindings(_mainView);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_mainView]-0-|" options:0 metrics:nil views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_mainView]-0-|" options:0 metrics:nil views:views]];
    
    self.nickName = [[NSUserDefaults standardUserDefaults] valueForKey:@"NickName"];
    self.userID = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserID"];
    //andUserData 参数根据平台相关，然后在进会人员中会有该人员信息的接受（用户人员上下线）
    self.userIcon = [[NSUserDefaults standardUserDefaults] valueForKey:@"IconUrl"]?[[NSUserDefaults standardUserDefaults] valueForKey:@"IconUrl"]:@"";
    NSDictionary *customDict = [NSDictionary dictionaryWithObjectsAndKeys:self.nickName,@"nickName", self.userIcon,@"headUrl" ,nil];
    NSString *customStr = [self JSONTOString:customDict];
    
    [self.guestKit JoinRTCLine:self.livingItem.andyrtcId andCustomID:self.userID andUserData:customStr ];
    
    [self registerForKeyboardNotifications];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.guestKit clear];
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
- (NSString*)getTopName {
    NSArray *array = @[@"测试Anyrtc",@"Anyrtc真心效果好",@"欢迎用Anyrtc",@"视频云提供商DYNC"];
    return [array objectAtIndex:(int)arc4random()%(array.count-1)];
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
            item.u_userID = @"three id";
            item.u_nickName = self.nickName;
            item.thumUrl = self.userIcon;
            item.content = message;
            [self.danmuView setModel:item];
            if (self.guestKit) {
                [self.guestKit SendBarrage:self.nickName andCustomHeader:self.userIcon andContent:message];
            }
        }
    }else{
        // 发送普通消息
        MessageModel *model = [[MessageModel alloc] init];
        [model setModel:@"guestID" withName:self.nickName withIcon:self.userIcon withType:CellNewChatMessageType withMessage:message];
        [self.messageTableView sendMessage:model];
        
        if (self.guestKit) {
            [self.guestKit SendUserMsg:self.nickName andCustomHeader:self.userIcon andContent:message];
        }
        
    }
}
#pragma mark -  RTMPCGuestRtmpDelegate
// rtmp 连接成功
- (void)OnRtmplayerOK
{
    NSLog(@"OnRtmplayerOK");
}
// rtmp 播放状态  cacheTime:当前延迟时间 curBitrate:当期码率大小
- (void)OnRtmplayerStatus:(int) cacheTime withBitrate:(int) curBitrate
{
    
}
- (void)OnRtmplayerStart
{
    NSLog(@"OnRtmplayerStart");
}
// rtmp 播放器缓存时间
- (void)OnRtmplayerCache:(int) time
{
    NSLog(@"OnRtmplayerCache:%d",time);
}
// rtmp 播放器关闭
- (void)OnRtmplayerClosed:(int) errcode
{
    
}
// 音频监测
- (void)OnRtmpAudioLevel:(NSString *)nsCustomID withLevel:(int)Level
{
    
}
#pragma mark - RTMPCGuestRtcDelegate
// 加入RTC
- (void)OnRTCJoinLineResult:(int) code/*0:OK */ withReason:(NSString*)strReason
{
    NSLog(@"OnRTCJoinLineResult: %d", code);
    if (code != 0) {
        if (code == 101) {
            [ASHUD showHUDWithCompleteStyleInView:self.view content:@"主播还未开启直播" icon:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    }
}
// 自己请求主播连麦得到的回复回调
- (void)OnRTCApplyLineResult:(int) code/*0:OK */
{
    if(code == 0) {
        if(!use_cap_) {
            use_cap_ = true;
            // 找一个view
            UIView *videoView = [self getVideoViewWithStrID:@"MEVIDEOVIEW"];
            UIButton *cButton = [UIButton buttonWithType:UIButtonTypeCustom];
            cButton.frame = CGRectMake(CGRectGetWidth(videoView.frame)-30,10, 20, 20);
            [cButton addTarget:self action:@selector(cButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
            [cButton setImage:[UIImage imageNamed:@"close_preview"] forState:UIControlStateNormal];
            [videoView addSubview:cButton];
            
            [self.view addSubview:videoView];
            // 加一个tap
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeCamera)];
            [videoView addGestureRecognizer:tap];
            // 参照点~
            [self.view insertSubview:videoView belowSubview:self.chatButton];
            [self.guestKit SetVideoCapturer:videoView andUseFront:YES];
        }
    }else{
        [ASHUD showHUDWithCompleteStyleInView:self.view content:@"主播拒绝了你的连麦请求" icon:nil];
        self.handupButton.hidden = NO;
    }
}

// 主播关闭了你的连线（通->关）
- (void)OnRTCHangupLine
{
    // 主播挂断你的连线
    use_cap_ = NO;
    self.handupButton.hidden = NO;
    for (int i=0;i<self.remoteArray.count;i++) {
        NSDictionary *dict = [self.remoteArray objectAtIndex:i];
        if ([[dict.allKeys firstObject] isEqualToString:@"MEVIDEOVIEW"]) {
            UIView *videoView = [dict objectForKey:@"MEVIDEOVIEW"];
            [videoView removeFromSuperview];
            [self.remoteArray removeObjectAtIndex:i];
            [self layout:i];
            break;
        }
    }
    // 清空自己摄像头~
    [self.guestKit HangupRTCLine];
    
}
// RTC 关闭
- (void)OnRTCLineLeave:(int) code/*0:OK */ withReason:(NSString*)strReason
{
    // 主播离开了
    [ASHUD showHUDWithCompleteStyleInView:self.view content:@"主播关闭了直播" icon:nil];
    if (self.guestKit) {
        [self.guestKit clear];
        self.guestKit = nil;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.navigationController popViewControllerAnimated:YES];
    });
}

// 视频显示
- (void)OnRTCOpenVideoRender:(NSString*)strLivePeerID withCustomID:(NSString *)nsCustomID{
    NSLog(@"OnRTCOpenVideoRender:%@",strLivePeerID);
    UIView *video = [self getVideoViewWithStrID:strLivePeerID];
    [self.view addSubview:video];
    // 参照点~
    [self.view insertSubview:video belowSubview:self.chatButton];
    [self.guestKit SetRTCVideoRender:strLivePeerID andRender:video];
}
// 视频离开
- (void)OnRTCCloseVideoRender:(NSString*)strLivePeerID withCustomID:(NSString *)nsCustomID{
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
// 音频直播连麦回调
- (void)OnRTCOpenAudioLine:(NSString*)strLivePeerID withCustomID:(NSString *)nsCustomID {
    
}
// 音频直播取消连麦回调
- (void)OnRTCCloseAudioLine:(NSString*)strLivePeerID withCustomID:(NSString *)nsCustomID {
    
}
// 普通消息
- (void)OnRTCUserMessage:(NSString *)nsCustomId withCustomName:(NSString *)nsCustomName withCustomHeader:(NSString *)nsCustomHeader withContent:(NSString *)nsContent {
    // 发送普通消息
    MessageModel *model = [[MessageModel alloc] init];
    [model setModel:@"guestID" withName:self.nickName withIcon:@"游客头像" withType:CellNewChatMessageType withMessage:nsContent];
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
    
}

- (void)OnRTCMemberListUpdateDone {
    
}

// 开始直播
- (void)OnRTCLiveStart:(NSString*)nsLiveInfo {
    
}
// 直播停止
- (void)OnRTCLiveStop {
    
}

#pragma mark - button events
- (void)changeCamera {
    if (self.guestKit) {
        [self.guestKit SwitchCamera];
    }
}
- (void)pullButtonEvent:(UIButton*)sender {
    sender.selected = !sender.selected;
    // 开始拉流
    use_cap_ = false;
    [self.guestKit ApplyRTCLine:@"Hello"];
    self.handupButton.hidden = YES;
}
- (void)closeButtonEvent:(UIButton*)sender {
    if (self.guestKit != nil) {
        [self.guestKit clear];
        self.guestKit = nil;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
    
}
- (void)cButtonEvent:(UIButton*)sender {
    if (self.guestKit) {
        [self.guestKit HangupRTCLine];
        use_cap_ = NO;
        self.handupButton.hidden = NO;
        for (int i=0;i<self.remoteArray.count;i++) {
            NSDictionary *dict = [self.remoteArray objectAtIndex:i];
            if ([[dict.allKeys firstObject] isEqualToString:@"MEVIDEOVIEW"]) {
                UIView *videoView = [dict objectForKey:@"MEVIDEOVIEW"];
                [videoView removeFromSuperview];
                [self.remoteArray removeObjectAtIndex:i];
                [self layout:i];
                break;
            }
        }
    }
}
// 聊天button
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
        case 2:
            
            break;
            
        default:
            break;
    }
}

#pragma mark - get
- (UIView*)mainView {
    if (!_mainView) {
        _mainView = [[UIView alloc] init];
        _mainView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    }
    return _mainView;
}

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
    
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:pullView,publishID, nil];
    [self.remoteArray addObject:dict];
    return pullView;
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
- (UILabel*)lineNumLabel {
    if (!_lineNumLabel) {
        _lineNumLabel = [UILabel new];
        _lineNumLabel.textColor = [UIColor blueColor];
        _lineNumLabel.font = [UIFont systemFontOfSize:12];
        _lineNumLabel.textAlignment = NSTextAlignmentRight;
        _lineNumLabel.frame = CGRectMake(CGRectGetMaxX(self.view.frame)/2-10, CGRectGetMaxY(self.closeButton.frame)+20, CGRectGetMaxX(self.view.frame)/2, 25);
        _lineNumLabel.text = @"";
    }
    return _lineNumLabel;
}

- (UIButton*)handupButton {
    if (!_handupButton) {
        _handupButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_handupButton setImage:[UIImage imageNamed:@"btn_hands_normal"] forState:UIControlStateNormal];
        [_handupButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_handupButton addTarget:self action:@selector(pullButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        _handupButton.frame = CGRectMake(CGRectGetMinX(self.closeButton.frame)-60, 20, 40,40);
    }
    return _handupButton;
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
#pragma mark -
//支持横向
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator
{
    if (self.guestKit) {
        [self.guestKit videoFreamUpdate];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
