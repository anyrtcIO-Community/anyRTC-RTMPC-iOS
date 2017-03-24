//
//  HostSettingViewController.m
//  RTMPCDemo
//
//  Created by jianqiangzhang on 16/7/27.
//  Copyright © 2016年 EricTao. All rights reserved.
//

#import "HostSettingViewController.h"
#import "HostViewController.h"
#import "ASHUD.h"
#import <RTMPCHybirdEngine/RTMPCCommon.h>
#import "HostAudioOnlyController.h"

@interface TextFieldEnterView()
@property (nonatomic, strong) UITextField *roomTextField;
@property (nonatomic, strong) UIButton *okButton;
@end

@implementation TextFieldEnterView
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubview:self.roomTextField];
        [self addSubview:self.okButton];
        
        self.roomTextField.translatesAutoresizingMaskIntoConstraints = NO;
        self.okButton.translatesAutoresizingMaskIntoConstraints = NO;
        //roomTextField
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.roomTextField attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:.6 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.roomTextField attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.roomTextField attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.roomTextField attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
        
        //okButton
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.okButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.okButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.okButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:-20]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.okButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
        
        
    }
    return self;
}
- (void)okButtonEvent:(UIButton*)sender {
    if (self.TapEventBlock) {
        self.TapEventBlock(self.roomTextField.text);
    }
}

- (UITextField*)roomTextField {
    if (!_roomTextField) {
        _roomTextField = [UITextField new];
        _roomTextField.textAlignment = NSTextAlignmentCenter;
        _roomTextField.placeholder = @"输入直播主题";
    }
    return _roomTextField;
}
- (UIButton*)okButton {
    if (!_okButton) {
        _okButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_okButton setImage:[UIImage imageNamed:@"go"] forState:UIControlStateNormal];
        [_okButton addTarget:self action:@selector(okButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _okButton;
}

@end

@interface HostSettingViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    
}
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) TextFieldEnterView *bgView;
@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSArray *modelDataArray;

@property (nonatomic, assign) RTMPCVideoMode rtmpVideoMode;
@property (nonatomic, assign) BOOL isVideoLiving;
@property (nonatomic, assign) BOOL isVideoLivingAudioModel;

@end

@implementation HostSettingViewController
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.backButton];
    [self.view addSubview:self.titleLabel];
    
    [self.view addSubview:self.pickerView];
    
    [self.pickerView selectRow:2 inComponent:0 animated:YES];
    _rtmpVideoMode = 2;
    _isVideoLiving = YES;
    _isVideoLivingAudioModel = NO;
    [self registerForKeyboardNotifications];
    [self.view addSubview:self.bgView];
    [_bgView.roomTextField becomeFirstResponder];
    
}
- (void) registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardWillHideNotification object:nil];
}

// 键盘弹起
- (void)keyboardWasShown:(NSNotification*)notification {
    NSDictionary *info = [notification userInfo];
    CGRect keyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSLog(@"%f %f",keyboardRect.size.width,keyboardRect.size.height);
    _bgView.frame = CGRectMake(0, CGRectGetHeight(self.view.frame)-keyboardRect.size.height-_bgView.bounds.size.height, _bgView.bounds.size.width, _bgView.bounds.size.height);
}
// 键盘隐藏
- (void)keyboardWasHidden:(NSNotification*)notification {
    
    _bgView.frame = CGRectMake(0, CGRectGetHeight(self.view.frame)-_bgView.bounds.size.height, _bgView.bounds.size.width, _bgView.bounds.size.height);
}
#pragma mark - UIPickerViewDelegate UIPickerViewDataSource

// pickerView 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return [_dataArray count];
    }
    
    return [_modelDataArray count];
}
//指定每行如何展示数据（此处和tableview类似）
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
        return [_dataArray objectAtIndex:row];
    } else {
        return [_modelDataArray objectAtIndex:row];
    }
}
// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    if (component == 1) {
        return (self.view.bounds.size.width)/2;
    }
    return (self.view.bounds.size.width-100)/2;
}

// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
       _rtmpVideoMode = row - 1;
        if (row == 0) {
             [pickerView selectRow:1 inComponent:1 animated:YES];
             _isVideoLiving = NO;
            _isVideoLivingAudioModel = NO;
        }else{
          
            if (!_isVideoLiving) {
                _isVideoLiving = YES;
                [pickerView selectRow:0 inComponent:1 animated:YES];
            }else{
                
            }
            
        }
       
    } else {
        if (row == 0 || row == 2) {
            _isVideoLiving = YES;
            if (row == 2) {
                 _isVideoLivingAudioModel = YES;
            }else{
                 _isVideoLivingAudioModel = NO;
            }
            if (_rtmpVideoMode == -1) {
                 [pickerView selectRow:3 inComponent:0 animated:YES];
            }
        }else{
            _isVideoLiving = NO;
             [pickerView selectRow:0 inComponent:0 animated:YES];
            _rtmpVideoMode = -1;
        }
        
    }
    NSLog(@"ISVideo:%d isVideoAudio:%d",_isVideoLiving,_isVideoLivingAudioModel);
    
}

#pragma mark - button events
- (void)backButtonEvent:(UIButton*)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
- (UIButton*)backButton {
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.frame = CGRectMake(20, 30, 28, 28);
        [_backButton setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}
- (UILabel*)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.frame = CGRectMake(CGRectGetMaxX(_backButton.frame)+20, 30, CGRectGetWidth(self.view.frame)-2*(CGRectGetMaxX(_backButton.frame)+20), 28);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.text = @"请创建一个直播标题";
    }
    return _titleLabel;
}
- (UIPickerView*)pickerView {
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 84, CGRectGetWidth(self.view.frame), 200)];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.showsSelectionIndicator=YES;
        _dataArray = @[@"48K",@"超高清",@"顺畅",@"标清",@"高清"];
        _modelDataArray = @[@"视频直播",@"音频直播",@"视频直播音频连麦"];
    }
    return _pickerView;
}

- (TextFieldEnterView *)bgView {
    if (!_bgView) {
        _bgView = [TextFieldEnterView new];
        __weak typeof(self)weakSelf = self;
        [_bgView setTapEventBlock:^(NSString * text) {
            if (text.length == 0) {
                [ASHUD showHUDWithCompleteStyleInView:weakSelf.view content:@"请输入主题" icon:nil];
                return;
            }
            if (weakSelf.isVideoLiving) {
                if (weakSelf.isVideoLivingAudioModel) {
                    HostViewController *hostController = [HostViewController new];
                    hostController.livingName = text;
                    hostController.isVideoAudioLiving = YES;
                    hostController.rtmpVideoMode = weakSelf.rtmpVideoMode;
                    [weakSelf.navigationController pushViewController:hostController animated:YES];
                }else{
                    HostViewController *hostController = [HostViewController new];
                    hostController.livingName = text;
                    hostController.isVideoAudioLiving = NO;
                    hostController.rtmpVideoMode = weakSelf.rtmpVideoMode;
                    [weakSelf.navigationController pushViewController:hostController animated:YES];
                }
              
            }else {
                HostAudioOnlyController *hostController = [HostAudioOnlyController new];
                hostController.livingName = text;
                hostController.isAudioLiving = !weakSelf.isVideoLiving;
                [weakSelf.navigationController pushViewController:hostController animated:YES];
                
            }
           
        }];
        _bgView.backgroundColor = [UIColor grayColor];
        _bgView.frame = CGRectMake(0, CGRectGetMidY(self.view.frame), CGRectGetWidth(self.view.frame), 50);
    }
    return _bgView;
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
