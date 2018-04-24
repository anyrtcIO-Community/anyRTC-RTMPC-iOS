//
//  ATMenuViewController.m
//  RTMPCDemo
//
//  Created by jh on 2018/4/13.
//  Copyright © 2018年 jh. All rights reserved.
//

#import "ATMenuViewController.h"

@interface ATMenuViewController ()

@property (weak, nonatomic) IBOutlet UIView *menuView;
@end

@implementation ATMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.menuView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)obj;
            (button.tag == 101) ? (button.selected = YES) : 0;
            [button layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:10];
        }
    }];
}

- (IBAction)doSomethingEvent:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    switch (sender.tag) {
        case 100:
            //摄像头
            [self.mHosterKit switchCamera];
            break;
        case 101:
            //美颜
            [self.mHosterKit setBeautyEnable:sender.selected];
            break;
        case 102:
            //视频
            [self.mHosterKit setLocalVideoEnable:!sender.selected];
            break;
        case 103:
            //音频
            [self.mHosterKit setLocalAudioEnable:!sender.selected];
            break;
        default:
            break;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
