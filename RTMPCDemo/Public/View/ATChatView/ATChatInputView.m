//
//  ATChatInputView.m
//  RTMPCDemo
//
//  Created by derek on 2017/9/22.
//  Copyright © 2017年 jh. All rights reserved.
//

#import "ATChatInputView.h"
#import <Masonry.h>
@interface ATChatInputView ()<UITextFieldDelegate>
@end

@implementation ATChatInputView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.atTextField];
        [self.atTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(10);
            make.right.equalTo(self.mas_right).offset(-10);
            make.centerY.equalTo(self.mas_centerY);
            make.height.equalTo(self.mas_height).multipliedBy(.8);
        }];
    }
    return self;
}


- (void)beginEditTextField {
    [self.atTextField becomeFirstResponder];
    self.isEditing = YES;
}

- (void)editEndTextField {
    [self.atTextField resignFirstResponder];
    self.isEditing = NO;
}

- (UITextField*)atTextField {
    if (!_atTextField) {
        _atTextField = [[UITextField alloc] init];
        _atTextField.returnKeyType = UIReturnKeySend;
        _atTextField.delegate = self;
        _atTextField.placeholder = @"说点什么";
    }
    return _atTextField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    if (self.sendBlock) {
        self.sendBlock(textField.text);
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
