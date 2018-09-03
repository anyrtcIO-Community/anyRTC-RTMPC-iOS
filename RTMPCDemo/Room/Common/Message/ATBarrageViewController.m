//
//  ATBarrageViewController.m
//  RTMPCDemo
//
//  Created by jh on 2018/4/11.
//  Copyright © 2018年 jh. All rights reserved.
//

#import "ATBarrageViewController.h"

@interface ATBarrageViewController ()

@end

@implementation ATBarrageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.listVc = [[ATListViewController alloc]init];
    //监听键盘
    [self observeKeyBoard];
}

//弹幕生成器
- (BarrageDescriptor *)produceTextBarrage:(BarrageWalkDirection)direction message:(NSString *)message{
    BarrageDescriptor * descriptor = [[BarrageDescriptor alloc]init];
    descriptor.spriteName = NSStringFromClass([BarrageWalkTextSprite class]);
    descriptor.params[@"text"] = message;
    descriptor.params[@"textColor"] = [UIColor purpleColor];
    descriptor.params[@"speed"] = @(100 * (double)random()/RAND_MAX+80);
    descriptor.params[@"direction"] = @(direction);
    return descriptor;
}

//普通消息
- (ATBarragesModel *)produceTextInfo:(NSString *)name content:(NSString *)content userId:(NSString *)userId{
    ATBarragesModel *barrageModel = [[ATBarragesModel alloc]init];
    barrageModel.userName = name;
    barrageModel.content = content;
    if ([userId isEqualToString:@"hosterUserId"]) {
        barrageModel.isHost = YES;
    }
    return barrageModel;
}

//连麦模型
- (ATRealMicModel *)produceRealModel:(NSString *)peerId userId:(NSString *)userId userData:(NSString *)userData{
    ATRealMicModel *micModel = [[ATRealMicModel alloc] init];
    micModel.peerId = peerId;
    micModel.userId = userId;
    micModel.userData = userData;
    return micModel;
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

- (void)keyboardChange:(NSNotification *)notify{
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

//获取在线人员列表
- (void)getMemberList{
    if (self.listVc.anyrtcId != nil && self.listVc.roomId != nil && self.listVc.serverId != nil) {
        [self presentViewController:self.listVc animated:YES completion:nil];
    }
}

//视频连麦窗口布局
- (void)layoutVideoView:(UIView *)localView containerView:(UIView *)containerView landscape:(NSInteger)landscape{
    
    //当前video的宽高
    CGFloat itemWidth = 0;
    CGFloat itemHeight = 0;
    
    [containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    switch (self.videoArr.count) {
        case 1:
        {
            [localView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(containerView);
            }];
        }
            break;
        case 2:
        {
            if (landscape == 0) {
                //竖屏
                itemWidth = SCREEN_WIDTH/2;
                itemHeight = itemWidth * 16/9;
            } else {
                //横屏
                itemWidth = SCREEN_WIDTH/2;
                itemHeight = itemWidth * 3/4;
            }
            
            [containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(self.view);
                make.height.equalTo(@(itemHeight));
                make.center.equalTo(self.view);
            }];
            
            [self makeVideoEqualWidthViews:self.videoArr containerView:containerView spacing:0 padding:0];
            
        }
            break;
        case 3:
        case 4:
            
            itemWidth = SCREEN_WIDTH/2;
            itemHeight = SCREEN_HEIGHT/2;
            [self makeVideoViews:self.videoArr containerView:containerView itemWidth:itemWidth itemHeight:itemHeight warpCount:2];
            break;
        default:
            break;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [localView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[UIView class]]) {
                UIView *subView = (UIView *)obj;
                subView.frame = localView.frame;
            }
        }];
    });
}

//音频连麦窗口布局
- (void)layoutAudioView:(UIButton *)hosterButton containerView:(UIView *)containerView landscape:(NSInteger)landscape{
    if (self.audioArr.count == 0) {
        [hosterButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@90);
            make.center.equalTo(self.view);
        }];
        return;
    }
    
    //子视图
    CGFloat itemWidth;
    CGFloat itemHeight;
    
    if (landscape == 0) {
        //竖屏
        itemWidth = SCREEN_WIDTH/3;
        itemHeight = itemWidth * 16/9;
        [containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(self.audioArr.count * itemWidth));
            make.height.equalTo(@(itemHeight));
            make.centerX.equalTo(self.view.mas_centerX);
            make.centerY.equalTo(self.view.mas_centerY).offset(100);
        }];
        
        [hosterButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@90);
            make.centerX.equalTo(self.view);
            make.bottom.equalTo(containerView.mas_top).offset(-80);
        }];
        
    } else {
        //横屏
        itemWidth = SCREEN_HEIGHT/3;
        itemHeight = itemWidth * 16/9;
        
        [containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(self.audioArr.count * itemWidth));
            make.height.equalTo(@(itemHeight));
            make.centerY.equalTo(self.view.mas_centerY);
            make.centerX.equalTo(self.view.mas_centerX).offset(80);
        }];
        
        [hosterButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@(90));
            make.centerY.equalTo(self.view.mas_centerY);
            make.right.equalTo(containerView.mas_left).offset(-60);
        }];
    }
    
    [self makeVideoEqualWidthViews:self.audioArr containerView:containerView spacing:0 padding:0];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark - 懒加载
- (UITextField *)messageTextField{
    if (!_messageTextField) {
        _messageTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 44)];
        _messageTextField.placeholder = @"说点什么...";
        _messageTextField.borderStyle = UITextBorderStyleNone;
        _messageTextField.backgroundColor = [UIColor whiteColor];
        _messageTextField.returnKeyType = UIReturnKeySend;
        _messageTextField.delegate = self;
    }
    return _messageTextField;
}

//竖屏消息
- (ATBarragesView *)infoView{
    if (!_infoView) {
        _infoView = [[ATBarragesView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT * 0.6 - 30, SCREEN_WIDTH, SCREEN_HEIGHT * 0.4)];
    }
    return _infoView;
}

//横屏弹幕
- (BarrageRenderer *)renderer{
    if (!_renderer) {
        _renderer = [[BarrageRenderer alloc]init];
        _renderer.canvasMargin = UIEdgeInsetsMake(30, 30, 30, 30);
        [_renderer start];
    }
    return _renderer;
}

//视频连麦窗口数组
- (NSMutableArray *)videoArr{
    if (!_videoArr) {
        _videoArr = [NSMutableArray arrayWithCapacity:3];
    }
    return _videoArr;
}

//音频连麦窗口数组
- (NSMutableArray *)audioArr{
    if (!_audioArr) {
        _audioArr = [NSMutableArray arrayWithCapacity:3];
    }
    return _audioArr;
}

- (void)dealloc{
    if (self.renderer) {
        [self.renderer stop];
        [self.renderer.view removeFromSuperview];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
