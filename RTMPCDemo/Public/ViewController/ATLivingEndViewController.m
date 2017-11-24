//
//  ATLivingEndViewController.m
//  RTMPCDemo
//
//  Created by jh on 2017/9/25.
//  Copyright © 2017年 jh. All rights reserved.
//

#import "ATLivingEndViewController.h"

@implementation ATLivingEndViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.nameLabel.text = self.userName;
    self.liveTimeButton.titleLabel.numberOfLines = 0;
    self.liveTimeButton.userInteractionEnabled = NO;
    self.liveTimeButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    NSString *liveStr = [NSString stringWithFormat:@"%@\n直播时间",[ATCommon getMMSSFromSS:[NSString stringWithFormat:@"%zd",self.livTime]]];
    
    NSMutableParagraphStyle*paragraph = [[NSMutableParagraphStyle alloc]init];
    paragraph.lineSpacing = 13;
    paragraph.alignment = NSTextAlignmentCenter;
    NSDictionary*attributes4 = @{NSParagraphStyleAttributeName: paragraph};
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:liveStr attributes:attributes4];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:ATBlueColor range:NSMakeRange(0, 5)];
    [self.liveTimeButton setAttributedTitle:attributeStr forState:UIControlStateNormal];
}

- (IBAction)doSomethingEvents:(UIButton *)sender {
    
    switch (sender.tag) {
        case 100:
            [self joinGroup];
            break;
        case 101:
        {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
            break;
        case 102:
            [ATCommon callPhone:@"021-65650071" control:sender];
            break;
        default:
            break;
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelegate.allowRotation = NO;
        [self toOrientation:UIInterfaceOrientationPortrait];
        [self.goBackButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:3];
        [self.feedbackButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:3];
        [self.qqButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:0];
    });
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
       self.headImageView.layer.cornerRadius = SCREEN_WIDTH * 0.1;
    }];
}

-(void)toOrientation:(UIInterfaceOrientation)orientation{
    
    [UIView beginAnimations:nil context:nil];
    
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
    // 旋转屏幕
    NSNumber *value = [NSNumber numberWithInt:orientation];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    
    [UIView setAnimationDelegate:self];
    //开始旋转
    [UIView commitAnimations];
    [self.view layoutIfNeeded];
}

//加入QQ群
- (BOOL)joinGroup{
    NSString *urlStr = [NSString stringWithFormat:@"mqqapi://card/show_pslcard?src_type=internal&version=1&uin=%@&key=%@&card_type=group&source=external", @"604873374",@"afa76c03081cd06e5ab99825bb58ea2ddfd4229d1df4e93576f78da6660e4279"];
    NSURL *url = [NSURL URLWithString:urlStr];
    if([[UIApplication sharedApplication] canOpenURL:url]){
        [[UIApplication sharedApplication] openURL:url];
        return YES;
    }
    else return NO;
}

@end
