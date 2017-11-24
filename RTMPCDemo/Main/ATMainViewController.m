//
//  ATMainViewController.m
//  RTMPCDemo
//
//  Created by jh on 2017/9/22.
//  Copyright © 2017年 jh. All rights reserved.
//首页

#import "ATMainViewController.h"
#import "ATHallViewController.h"
#import "ATStartViewController.h"

@interface ATMainViewController ()

//观众
@property (weak, nonatomic) IBOutlet UIButton *audienceButton;

@end

@implementation ATMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.audienceButton.layer.borderColor = ATBordColor.CGColor;
    [self.navigationController setNavigationBarHidden:YES];
}

- (IBAction)doSomethingEvents:(UIButton *)sender {
    
    switch (sender.tag) {
        case 100:
        {
            //创建直播
            ATStartViewController *startVc = [[ATStartViewController alloc]init];
            [self.navigationController pushViewController:startVc animated:YES];
        }
            break;
        case 101:
        {
            //大厅列表
            ATHallViewController *hallVc = [[ATHallViewController alloc]init];
            [self.navigationController pushViewController:hallVc animated:YES];
        }
            break;
        case 102:
            //技术支持
            [ATCommon callPhone:@"021-65650071" control:sender];
        default:
            break;
    }
}


@end
