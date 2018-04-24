//
//  ATLivingEndController.m
//  RTMPCDemo
//
//  Created by jh on 2018/4/16.
//  Copyright © 2018年 jh. All rights reserved.
//

#import "ATLivingEndController.h"

@interface ATLivingEndController ()

@end

@implementation ATLivingEndController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.nameLabel.text = self.userName;
    self.liveTimeButton.titleLabel.numberOfLines = 0;
    self.liveTimeButton.userInteractionEnabled = NO;
    self.liveTimeButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    NSString *liveStr = [NSString stringWithFormat:@"%@\n直播时间",[ATCommon getMMSSFromSS:[NSString stringWithFormat:@"%zd",self.livTime]]];
    
    NSMutableParagraphStyle*paragraph = [[NSMutableParagraphStyle alloc]init];
    paragraph.lineSpacing = 15;
    paragraph.alignment = NSTextAlignmentCenter;
    NSDictionary*attributes = @{NSParagraphStyleAttributeName: paragraph};
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:liveStr attributes:attributes];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 5)];
    [self.liveTimeButton setAttributedTitle:attributeStr forState:UIControlStateNormal];
    
    [self.containerView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)obj;
            [button layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:10];
        }
    }];
    self.headImageView.layer.cornerRadius = SCREEN_WIDTH * 0.1;
}

- (IBAction)doSomethingEvents:(UIButton *)sender {
    switch (sender.tag) {
        case 100:
        {
            NSString *urlStr = [NSString stringWithFormat:@"mqqapi://card/show_pslcard?src_type=internal&version=1&uin=%@&card_type=group&source=external", @"580477436"];
            NSURL *url = [NSURL URLWithString:urlStr];
            if([[UIApplication sharedApplication] canOpenURL:url]){
                [[UIApplication sharedApplication] openURL:url];
            }
        }
            break;
        case 101:
            [self.navigationController popToRootViewControllerAnimated:YES];
            break;
        case 102:
            [ATCommon callPhone:@"021-65650071" control:sender];
            break;
        default:
            break;
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
