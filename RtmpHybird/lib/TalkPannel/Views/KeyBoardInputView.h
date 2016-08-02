//
//  KeyBoardInputView.h
//  MessageLivingDemo
//
//  Created by jianqiangzhang on 16/5/12.
//  Copyright © 2016年 jianqiangzhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTextField:UITextField

@end
@protocol KeyBoardInputViewDelegate <NSObject>
@required
// 发送消息
- (void)keyBoardSendMessage:(NSString*)message withDanmu:(BOOL)danmu;
@optional
// 键盘打开弹幕
- (void)keyBoardDanmuOpen;
// 键盘关闭弹幕
- (void)keyBoardDanmuClose;


@end
typedef NS_ENUM(NSInteger,KeyBoardInputViewType){
    KeyBoardInputViewTypeNomal,
    KeyBoardInputViewTypeNoDanMu,
};
@interface KeyBoardInputView : UIView

- (id)initWityStyle:(KeyBoardInputViewType)type;

- (void)editBeginTextField;
- (void)editEndTextField;

@property (nonatomic,weak)id<KeyBoardInputViewDelegate>delegate;

@property (nonatomic, assign) BOOL isEdit;
@end
