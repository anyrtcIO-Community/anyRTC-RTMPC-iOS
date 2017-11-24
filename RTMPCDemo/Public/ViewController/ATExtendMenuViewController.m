//
//  ATExtendMenuViewController.m
//  RTMPCDemo
//
//  Created by derek on 2017/9/23.
//  Copyright © 2017年 jh. All rights reserved.
//

#import "ATExtendMenuViewController.h"
#import "ATExtendMenuButton.h"


@interface ATExtendMenuViewController ()
@property (weak, nonatomic) IBOutlet ATExtendMenuButton *switchCameraButton;
@property (weak, nonatomic) IBOutlet ATExtendMenuButton *beautyButton;

@property (weak, nonatomic) IBOutlet ATExtendMenuButton *closeVideoButton;
@property (weak, nonatomic) IBOutlet ATExtendMenuButton *closeAudioButton;

@end

@implementation ATExtendMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    // Do any additional setup after loading the view from its nib.
    [self.switchCameraButton setImage:[UIImage imageNamed:@"Camera"] forState:UIControlStateNormal];
     [self.switchCameraButton setImage:[UIImage imageNamed:@"Camera_Click"] forState:UIControlStateSelected];
    [self.switchCameraButton setTitle:@"翻转摄像头" forState:UIControlStateNormal];

    [self.beautyButton setImage:[UIImage imageNamed:@"Beauty"] forState:UIControlStateNormal];
    [self.beautyButton setImage:[UIImage imageNamed:@"Beauty_click"] forState:UIControlStateSelected];
    [self.beautyButton setTitle:@"美颜" forState:UIControlStateNormal];
    self.beautyButton.selected = YES;
    
    [self.closeVideoButton setImage:[UIImage imageNamed:@"video"] forState:UIControlStateNormal];
    [self.closeVideoButton setImage:[UIImage imageNamed:@"video_click"] forState:UIControlStateSelected];
    [self.closeVideoButton setTitle:@"关闭视频" forState:UIControlStateNormal];
    
    
    [self.closeAudioButton setImage:[UIImage imageNamed:@"voice_other"] forState:UIControlStateNormal];
    [self.closeAudioButton setImage:[UIImage imageNamed:@"voice_other_click"] forState:UIControlStateSelected];
    [self.closeAudioButton setTitle:@"关闭音频" forState:UIControlStateNormal];
}
- (IBAction)tapEvent:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)doSameEvent:(id)sender {
    UIButton *button = (UIButton*)sender;
    switch (button.tag) {
        case 100:
        {
            self.switchCameraButton.selected = !self.switchCameraButton.selected;
            // 选择摄像头
            if (self.menuTapBlock) {
                self.menuTapBlock(ExtendMenuTypeSwitchCamera,button.selected);
            }
        }
            break;
        case 101:
        {
            self.beautyButton.selected = !self.beautyButton.selected;
            // 美颜
            if (self.menuTapBlock) {
                self.menuTapBlock(ExtendMenuTypeBeautyCamera,button.selected);
            }
        }
            break;
        case 102:
        {
            self.closeVideoButton.selected = !self.closeVideoButton.selected;
            // 关闭视频
            if (self.menuTapBlock) {
                self.menuTapBlock(ExtendMenuTypeCloseVideo,button.selected);
            }
        }
            break;
        case 103:
        {
            self.closeAudioButton.selected = !self.closeAudioButton.selected;
            // 关闭音频
            if (self.menuTapBlock) {
                self.menuTapBlock(ExtendMenuTypeCloseAudio,button.selected);
            }
        }
            break;
            
        default:
            break;
    }
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
