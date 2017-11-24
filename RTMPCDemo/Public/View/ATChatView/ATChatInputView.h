//
//  ATChatInputView.h
//  RTMPCDemo
//
//  Created by derek on 2017/9/22.
//  Copyright © 2017年 jh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ATChatInputView : UIView

@property (strong, nonatomic)  UITextField *atTextField;

typedef void(^SendMessageBlock)(NSString*message);
@property (nonatomic, copy) SendMessageBlock sendBlock;

@property (nonatomic, assign) BOOL isEditing;
- (void)beginEditTextField;
- (void)editEndTextField;

@end
