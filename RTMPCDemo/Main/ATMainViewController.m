//
//  ATMainViewController.m
//  RTMPCDemo
//
//  Created by jh on 2018/4/11.
//  Copyright © 2018年 jh. All rights reserved.
//

#import "ATMainViewController.h"

@interface ATMainViewController ()

@property (weak, nonatomic) IBOutlet UIButton *audienceButton;

@end

@implementation ATMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.audienceButton.layer.borderColor = ATBordColor.CGColor;
}

- (IBAction)doSomethingEvents:(id)sender {
    [ATCommon callPhone:@"021-65650071" control:sender];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
