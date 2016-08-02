//
//  KeyBoardInputView.m
//  MessageLivingDemo
//
//  Created by jianqiangzhang on 16/5/12.
//  Copyright © 2016年 jianqiangzhang. All rights reserved.
//

#import "KeyBoardInputView.h"
#import "CustomSwitch.h"
#import "Masonry.h"
#import "UIColor+Category.h"
#define DownUpSpace 6
#define BetweenSpace 3

@implementation CTextField
-(CGRect)textRectForBounds:(CGRect)bounds{ return CGRectInset(bounds, 2, 0); }
-(CGRect)editingRectForBounds:(CGRect)bounds{ return CGRectInset(bounds, 2, 0); }
@end

@interface KeyBoardInputView()<CustomSwitchDelegate,UITextFieldDelegate>
{
    KeyBoardInputViewType Showtype;
}
@property (nonatomic, strong) CustomSwitch *customSwitch;
@property (nonatomic, strong) CTextField *textField;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, assign) BOOL danmu;
- (void)initLayout;
@end

@implementation KeyBoardInputView

- (id)initWityStyle:(KeyBoardInputViewType)type
{
    self = [super init];
    if (self) {
        Showtype = type;
        [self initLayout];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initLayout];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initLayout];
    }
    return self;
}
- (void)editBeginTextField
{
    if (self.textField.isFirstResponder) {
        return;
    }
    self.isEdit = YES;
    [self.textField becomeFirstResponder];
}

- (void)editEndTextField
{
    if (self.textField.isFirstResponder) {
         self.isEdit = NO;
        [self.textField resignFirstResponder];
    }
   
}

- (void)initLayout
{
    if (Showtype == KeyBoardInputViewTypeNomal) {
        _customSwitch = [CustomSwitch new];
        _customSwitch.delegate = self;
        [self addSubview:_customSwitch];
        
        _textField = [CTextField new];
        _textField.backgroundColor = [UIColor whiteColor];
        _textField.layer.cornerRadius = 4;
        _textField.delegate = self;
        _textField.returnKeyType = UIReturnKeySend;
        _textField.font = [UIFont systemFontOfSize:14];
        _textField.placeholder = @"和大家说点什么";
        [self addSubview:_textField];
        
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendButton.layer.cornerRadius = 4;
        _sendButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [_sendButton addTarget:self action:@selector(sendButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        _sendButton.backgroundColor = [UIColor colorWithHexString:@"2fcf6f"];
        [self addSubview:_sendButton];
        
        [_customSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(0);
            make.top.equalTo(self.mas_top).offset(DownUpSpace);
            make.bottom.equalTo(self.mas_bottom).offset(-DownUpSpace);
            make.width.equalTo(_customSwitch.mas_height).multipliedBy(1.65);
        }];
        
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_customSwitch.mas_right).offset(BetweenSpace);
            make.top.equalTo(self.mas_top).offset(DownUpSpace);
            make.bottom.equalTo(self.mas_bottom).offset(-DownUpSpace);
            make.right.equalTo(_sendButton.mas_left).offset(-BetweenSpace);
            
        }];
        [_sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(0);
            make.top.equalTo(self.mas_top).offset(DownUpSpace);
            make.bottom.equalTo(self.mas_bottom).offset(-DownUpSpace);
            make.width.equalTo(_customSwitch.mas_width);
        }];
    }else if(Showtype == KeyBoardInputViewTypeNoDanMu){
        
        _textField = [CTextField new];
        _textField.backgroundColor = [UIColor whiteColor];
        _textField.layer.cornerRadius = 4;
        _textField.delegate = self;
        _textField.returnKeyType = UIReturnKeySend;
        _textField.font = [UIFont systemFontOfSize:14];
        _textField.placeholder = @"和大家说点什么";
        [self addSubview:_textField];
        
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendButton.layer.cornerRadius = 4;
        _sendButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_sendButton addTarget:self action:@selector(sendButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        _sendButton.backgroundColor = [UIColor colorWithHexString:@"2fcf6f"];
        [self addSubview:_sendButton];
        
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(0);
            make.top.equalTo(self.mas_top).offset(DownUpSpace);
            make.bottom.equalTo(self.mas_bottom).offset(-DownUpSpace);
            make.right.equalTo(_sendButton.mas_left).offset(-BetweenSpace);
            
        }];
        [_sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(0);
            make.top.equalTo(self.mas_top).offset(DownUpSpace);
            make.bottom.equalTo(self.mas_bottom).offset(-DownUpSpace);
            make.width.equalTo(_customSwitch.mas_height).multipliedBy(1.65);
        }];
    }
}
- (void)sendButtonEvent:(UIButton*)sedner
{
    if (_delegate && [_delegate respondsToSelector:@selector(keyBoardSendMessage:withDanmu:)]) {
        [_delegate keyBoardSendMessage:_textField.text withDanmu:_danmu];
    }
    _textField.text = @"";
}

#pragma mark - 
- (void)customSwitchOn {
    _danmu = YES;
    if (_delegate && [_delegate respondsToSelector:@selector(keyBoardDanmuOpen)]) {
        [_delegate keyBoardDanmuOpen];
    }
}

- (void)customSwitchOff {
    _danmu = NO;
    if (_delegate && [_delegate respondsToSelector:@selector(keyBoardDanmuClose)]) {
        [_delegate keyBoardDanmuClose];
    }
}
#pragma mark -  UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (_delegate && [_delegate respondsToSelector:@selector(keyBoardSendMessage:withDanmu:)]) {
        [_delegate keyBoardSendMessage:_textField.text withDanmu:_danmu];
    }
    textField.text = @"";
    return YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
