//
//  GuestAudioOnlyController.m
//  RTMPCDemo
//
//  Created by jianqiangzhang on 2016/11/23.
//  Copyright © 2016年 EricTao. All rights reserved.
//

#import "GuestVideoAudioController.h"

#import <RTMPCHybirdEngine/RTMPCGuestKit.h>
#import "ASHUD.h"
#import "KeyBoardInputView.h"
#import "MessageTableView.h"

#import "DanmuItemView.h"
#import "DanmuLaunchView.h"
#import "AudioShowView.h"
#import "HorizontalView.h"
#import "PersonItem.h"
#import "HosterView.h"


@interface GuestVideoAudioController ()<RTMPCGuestRtmpDelegate, RTMPCGuestRtcDelegate,KeyBoardInputViewDelegate> {
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

@property (nonatomic, strong) HosterView *hosterView;
@property (nonatomic, strong) HorizontalView *horizontalView;
@property (nonatomic ,strong) NSMutableArray *mWatchNumber;


@end

@implementation GuestVideoAudioController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (self.guestKit) {
        self.guestKit = nil;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    self.view.backgroundColor = [UIColor blackColor];
    self.remoteArray = [[NSMutableArray alloc] initWithCapacity:3];
    self.mWatchNumber = [[NSMutableArray alloc] initWithCapacity:3];
    
    [self.view addSubview:self.mainView];
    [self.view addSubview:self.hosterView];
    [self.view addSubview:self.horizontalView];
    [self.view addSubview:self.handupButton];
    [self.view addSubview:self.closeButton];
    [self.view addSubview:self.lineNumLabel];
    
    [self.view addSubview:self.chatButton];
    [self.view addSubview:self.keyBoardView];
    [self.view addSubview:self.messageTableView];
    
    [self.view addSubview:self.danmuView];
    
    self.guestKit = [[RTMPCGuestKit alloc] initWithDelegate:self withCaptureDevicePosition:RTMPC_SCRN_Portrait withLivingAudioOnly:YES withAudioDetect:YES];
    self.guestKit.rtc_delegate = self;
    [self.guestKit StartRtmpPlay:self.livingItem.rtmp_url andRender:self.mainView];
    [self.guestKit setVideoContentMode:VideoShowModeScaleAspectFill];
    
    self.userID = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserID"];
    self.nickName = [[NSUserDefaults standardUserDefaults] valueForKey:@"NickName"];
    //andUserData 参数根据平台相关，然后在进会人员中会有该人员信息的接受（用户人员上下线）
    self.userIcon = [[NSUserDefaults standardUserDefaults] valueForKey:@"IconUrl"]?[[NSUserDefaults standardUserDefaults] valueForKey:@"IconUrl"]:@"";
    NSDictionary *customDict = [NSDictionary dictionaryWithObjectsAndKeys:self.nickName,@"nickName", self.userIcon,@"headUrl" ,nil];
    NSString *customStr = [self JSONTOString:customDict];
    
    [self.guestKit JoinRTCLine:self.livingItem.andyrtcId andCustomID:self.userID andUserData:customStr];
    
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
            if (self.guestKit) {
                [self.guestKit SendBarrage:self.nickName andCustomHeader:self.userIcon andContent:message];
            }
        }
    }else{
        // 发送普通消息
        MessageModel *model = [[MessageModel alloc] init];
        [model setModel:self.userID withName:self.nickName withIcon:self.userIcon withType:CellNewChatMessageType withMessage:message];
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
- (void)OnRtmpAudioLevel:(NSString *)nsCustomID withLevel:(int)Level {
    NSLog(@"OnRtmpAudioLevel:%@withLevel:%d",nsCustomID,Level);
    if ([nsCustomID  isEqualToString:self.livingItem.hosterId]) {
        if (Level != 0) {
            [self.hosterView show];
        }
        return;
    }
    if (use_cap_) {
        // 如果连麦后
        for (NSDictionary *item in self.remoteArray) {
            AudioShowView *itemShow = [[item allValues] firstObject];
            if ([itemShow.userID isEqualToString:nsCustomID]) {
                if (Level != 0) {
                    [itemShow show];
                }
                break;
            }
        }
    }else{
        if ([nsCustomID isEqualToString:self.userID]) {
            return;
        }
        for (PersonItem *personItem  in self.mWatchNumber) {
            if ([personItem.userID isEqualToString:nsCustomID]) {
                if (Level!=0) {
                    personItem.isSpeak = YES;
                }
                break;
            }
        }
        [self.horizontalView setMumberArray:self.mWatchNumber];
    }
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
            UIView *videoView = [self getVideoViewWithStrID:@"MEVIDEOVIEW" withUserID:self.userID];
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
            //            [self.guestKit SetVideoCapturer:videoView andUseFront:YES];
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
    // 把自己的检测项关掉
    for (PersonItem *personItem  in self.mWatchNumber) {
        if ([personItem.userID isEqualToString:self.userID]) {
            personItem.isSpeak = NO;
            break;
        }
    }
    
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
    
}
// 视频离开
- (void)OnRTCCloseVideoRender:(NSString*)strLivePeerID withCustomID:(NSString *)nsCustomID{
    
}
// 音频直播连麦回调
- (void)OnRTCOpenAudioLine:(NSString*)strLivePeerID withCustomID:(NSString *)nsCustomID {
    NSLog(@"OnRTCOpenAudioLine:%@ withCustomID：%@",strLivePeerID,nsCustomID);
    // 自己的和主播的不在这处理了（自己的在收到同意后处理，主播的ID已经知道）；
    if ([nsCustomID isEqualToString:self.userID] || [nsCustomID isEqualToString:self.livingItem.hosterId]) {
        return;
    }
    UIView *video = [self getVideoViewWithStrID:strLivePeerID withUserID:nsCustomID];
    [self.view addSubview:video];
    // 参照点~
    [self.view insertSubview:video belowSubview:self.chatButton];
    //[self.guestKit SetRTCVideoRender:strLivePeerID andRender:video];
    
}
// 音频直播取消连麦回调
- (void)OnRTCCloseAudioLine:(NSString*)strLivePeerID withCustomID:(NSString *)nsCustomID {
    NSLog(@"OnRTCCloseAudioLine:%@ withCustomID：%@",strLivePeerID,nsCustomID);
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
- (void)OnRTCUserMessage:(NSString *)nsCustomId withCustomName:(NSString *)nsCustomName withCustomHeader:(NSString *)nsCustomHeader withContent:(NSString *)nsContent {
    // 发送普通消息
    MessageModel *model = [[MessageModel alloc] init];
    [model setModel:nsCustomId?nsCustomName:@"" withName:nsCustomName?nsCustomName:@"" withIcon:@"游客头像" withType:CellNewChatMessageType withMessage:nsContent];
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
    [self.mWatchNumber removeAllObjects];
}
// 人员信息
- (void)OnRTCMember:(NSString*)nsCustomId withUserData:(NSString*)nsUserData {
    NSDictionary *customData = [self JSONValue:nsUserData];
    if (customData) {
        PersonItem  *item = [[PersonItem alloc] init];
        item.userID = nsCustomId;
        item.nickName = [customData objectForKey:@"nickName"];
        item.headURl = [customData objectForKey:@"headUrl"];
        [self.mWatchNumber addObject:item];
    }
}

- (void)OnRTCMemberListUpdateDone {
    [self.horizontalView setMumberArray:self.mWatchNumber];
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
    NSDictionary *customDict = [NSDictionary dictionaryWithObjectsAndKeys:self.nickName,@"nickName", self.userIcon,@"headUrl" ,nil];
    NSString *customStr = [self JSONTOString:customDict];
    
    [self.guestKit ApplyRTCLine:customStr];
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
        
        // 把自己的监测项关掉
        for (PersonItem *personItem  in self.mWatchNumber) {
            if ([personItem.userID isEqualToString:self.userID]) {
                personItem.isSpeak = NO;
                break;
            }
        }
        
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
        _mainView.frame = self.view.frame;
    }
    return _mainView;
}

- (AudioShowView*)getVideoViewWithStrID:(NSString*)publishID withUserID:(NSString*)userID {
    
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
    if ([publishID isEqualToString:@"MEVIDEOVIEW"]) {
        [pullView headUrl:self.userIcon withName:self.nickName withID:@"MEVIDEOVIEW"];
        pullView.userID = userID;
    }else{
        PersonItem *findItem;
        BOOL isFind = NO;
        for (PersonItem *item in self.mWatchNumber) {
            if ([item.userID isEqualToString:userID]) {
                isFind = YES;
                findItem = item;
                break;
            }
        }
        if (isFind) {
            [pullView headUrl:findItem.headURl withName:findItem.nickName withID:publishID];
            pullView.userID = userID;
        }else{
            [pullView headUrl:@"" withName:@"" withID:publishID];
            pullView.userID = userID;
        }
        
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
- (HorizontalView*)horizontalView {
    if (!_horizontalView) {
        _horizontalView = [[HorizontalView alloc] initWithFrame:CGRectMake(10, 90, 200, 50)];
        _horizontalView.backgroundColor = [UIColor clearColor];
    }
    return _horizontalView;
}
- (HosterView*)hosterView {
    if (!_hosterView) {
        
        _hosterView = [[HosterView alloc] initWithFrame:CGRectMake(15, 20, 120, 45)];
        PersonItem *item = [[PersonItem alloc] init];
        item.userID = self.livingItem.hosterId;
        item.nickName = self.livingItem.hosterName;
        item.headURl = self.livingItem.hosterHeadUrl;
        [_hosterView setItem:item];
    }
    return _hosterView;
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
