//
//  ArBaseViewController.m
//  RTMPCDemo
//
//  Created by 余生丶 on 2019/4/15.
//  Copyright © 2019 anyRTC. All rights reserved.
//

#import "ArBaseViewController.h"

@interface ArBaseViewController ()<UITextFieldDelegate>

@end

@implementation ArBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.logArr = [NSMutableArray array];
    [self addObserver:self forKeyPath:@"logArr" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    [self initializeUI];
    //监听键盘
    [self observeKeyBoard];
}

- (void)initializeUI {
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = RGBA(0, 0, 0, 0.5);
    bottomView.layer.masksToBounds = YES;
    bottomView.layer.cornerRadius = 3;
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(40));
        make.left.equalTo(@(10));
        make.height.equalTo(@(50));
    }];
    
    //房间名称
    self.roomIdLabel = [[UILabel alloc] init];
    self.roomIdLabel.textColor = [UIColor whiteColor];
    self.roomIdLabel.font = [UIFont systemFontOfSize:14];
    [bottomView addSubview:self.roomIdLabel];
    [self.roomIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView);
        make.left.equalTo(@(10));
        make.height.equalTo(@(25));
        make.right.equalTo(@(-10));
    }];
    
    //在线人数
    self.onlineLabel = [[UILabel alloc] init];
    self.onlineLabel.textColor = [UIColor whiteColor];
    self.onlineLabel.font = [UIFont systemFontOfSize:14];
    self.onlineLabel.text = @"在线人数：0";
    [bottomView addSubview:self.onlineLabel];
    [self.onlineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.roomIdLabel.mas_bottom);
        make.left.height.right.equalTo(self.roomIdLabel);
    }];
    
    //rtc连接状态
    self.rtcLabel = [[UILabel alloc] init];
    self.rtcLabel.font = [UIFont systemFontOfSize:14];
    self.rtcLabel.textColor = [ArCommon getColor:@"#46A9FE"];
    [self.view addSubview:self.rtcLabel];
    [self.rtcLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView.mas_bottom).offset(10);
        make.left.equalTo(bottomView);
        make.height.equalTo(@(20));
        make.right.equalTo(self.view).offset(-50);
    }];
    
    //rtmp连接状态
    self.rtmpLabel = [[UILabel alloc] init];
    self.rtmpLabel.font = [UIFont systemFontOfSize:14];
    self.rtmpLabel.textColor = [ArCommon getColor:@"#46A9FE"];
    [self.view addSubview:self.rtmpLabel];
    [self.rtmpLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rtcLabel.mas_bottom).offset(3);
        make.left.height.right.equalTo(self.rtcLabel);
    }];
    
    //聊天消息
    self.messageView = [[ArMessageView alloc] init];
    [self.view addSubview:self.messageView];
    [self.messageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-70);
        make.width.equalTo(self.view.mas_width).multipliedBy(0.64);
        make.height.equalTo(self.messageView.mas_width).multipliedBy(0.44);
    }];
}

- (void)observeKeyBoard {
    
    [self.view addSubview:self.messageTextField];
    
    //隐藏键盘
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoardTapClick)];
    [self.view addGestureRecognizer:tapGesture];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)hideKeyBoardTapClick{
    [self.messageTextField resignFirstResponder];
}

- (void)keyboardChange:(NSNotification *)notify {
    //时间
    NSTimeInterval duration;
    [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&duration];
    
    if (notify.name == UIKeyboardWillShowNotification ) {
        //键盘高度
        CGFloat keyboardY = [[notify.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue].size.height;
        CGFloat high = SCREEN_HEIGHT - 44 - keyboardY;
        
        [UIView animateWithDuration:duration animations:^{
            self.messageTextField.frame = CGRectMake(0, high, SCREEN_WIDTH, 44);
            [self.view layoutIfNeeded];
        }];
        
    } else if (notify.name == UIKeyboardWillHideNotification) {
        
        [UIView animateWithDuration:duration animations:^{
            self.messageTextField.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 44);
            [self.view layoutIfNeeded];
        }];
    }
}

//普通消息
- (ArMessageModel *)produceTextInfo:(NSString *)name content:(NSString *)content userId:(NSString *)userid audio:(BOOL)isAudio {
    ArMessageModel *messageModel = [[ArMessageModel alloc]init];
    messageModel.userName = name;
    messageModel.content = content;
    messageModel.userid = userid;
    messageModel.isAudio = isAudio;
    return messageModel;
}

//连麦数组
- (ArRealMicModel *)produceRealModel:(NSString *)peerId userId:(NSString *)userId userData:(NSString *)userData{
    ArRealMicModel *micModel = [[ArRealMicModel alloc] init];
    micModel.peerId = peerId;
    micModel.userId = userId;
    micModel.userData = userData;
    return micModel;
}

- (void)openLogView {
    ArLogView *logView = [[ArLogView alloc] initWithFrame:self.view.bounds];
    [logView refreshLogText:self.logArr];
    UIWindow *window = UIApplication.sharedApplication.delegate.window;
    [window addSubview:logView];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"logArr"]) {
        for (UIView *subView in UIApplication.sharedApplication.keyWindow.subviews) {
            if ([subView isKindOfClass:[ArLogView class]]) {
                ArLogView *logView = (ArLogView *)subView;
                [logView refreshLogText:self.logArr];
                break;
            }
        }
    }
}

//MARK: - 懒加载

- (UITextField *)messageTextField{
    if (!_messageTextField) {
        _messageTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame), 44)];
        _messageTextField.placeholder = @"说点什么...";
        _messageTextField.borderStyle = UITextBorderStyleNone;
        _messageTextField.backgroundColor = [UIColor whiteColor];
        _messageTextField.returnKeyType = UIReturnKeySend;
        _messageTextField.delegate = self;
    }
    return _messageTextField;
}

- (UIStackView *)videoStackView {
    if (!_videoStackView) {
        _videoStackView = [[UIStackView alloc] init];
        _videoStackView.axis = UILayoutConstraintAxisVertical;
        _videoStackView.distribution = UIStackViewDistributionEqualSpacing;
        _videoStackView.spacing = 1;
        [self.view addSubview:_videoStackView];
        [_videoStackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@(-10));
            make.bottom.equalTo(@(-20));
            make.width.equalTo(self.view.mas_width).multipliedBy(0.24);
        }];
    }
    return _videoStackView;
}

- (UIStackView *)audioStackView {
    if (!_audioStackView) {
        _audioStackView = [[UIStackView alloc] init];
        _audioStackView.axis = UILayoutConstraintAxisHorizontal;
        _audioStackView.alignment = UIStackViewAlignmentCenter;
        _audioStackView.spacing = 15;
        _audioStackView.distribution = UIStackViewDistributionEqualSpacing;
    }
    return _audioStackView;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeObserver:self forKeyPath:@"logArr"];
}

@end
