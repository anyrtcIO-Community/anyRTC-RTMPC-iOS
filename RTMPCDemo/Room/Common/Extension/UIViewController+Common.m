//
//  UIViewController+Common.m
//  RTMPCDemo
//
//  Created by jh on 2018/4/11.
//  Copyright © 2018年 jh. All rights reserved.
//

#import "UIViewController+Common.h"

@implementation UIViewController (Common)

//将若干view等宽布局于容器containerView中(横向排列)
- (void)makeVideoEqualWidthViews:(NSMutableArray *)views containerView:(UIView *)containerView spacing:(CGFloat)spacing padding:(CGFloat)padding{
    
    __block UIView *lastView;
    
    [views enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIView class]]) {
            UIView *video = (UIView *)obj;
            [containerView insertSubview:video atIndex:0];
            [video mas_remakeConstraints:^(MASConstraintMaker *make) {
                //***清除旧约束***  同时注意使用约束方式，否则可能导致布局失效
            }];
            [self makeAllControlTop:video];
            
            if (idx == 0) {
                [video mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(containerView).offset(spacing);
                    make.top.bottom.equalTo(containerView);
                }];
            } else {
                [video mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.bottom.equalTo(containerView);
                    make.left.equalTo(lastView.mas_right).offset(padding);
                    make.width.equalTo(lastView);
                }];
            }
            lastView = video;
        }
    }];
    
    [lastView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(containerView).offset(-spacing);
    }];
}

//将若干view等高布局于容器containerView中(纵向排列)
- (void)makeVideoHeightViews:(NSMutableArray *)views containerView:(UIView *)containerView spacing:(CGFloat)spacing padding:(CGFloat)padding{
    
    __block UIView *lastView;
    
    [views enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIView class]]) {
            UIView *video = (UIView *)obj;
            [containerView insertSubview:video atIndex:0];
            [video mas_remakeConstraints:^(MASConstraintMaker *make) {
                //***清除旧约束***  同时注意使用约束方式，否则可能导致布局失效
            }];
            [self makeAllControlTop:video];
            
            if (idx == 0) {
                [video mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(containerView).offset(padding);
                    make.left.right.equalTo(containerView);
                }];
            } else {
                [video mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.equalTo(containerView);
                    make.top.equalTo(lastView.mas_bottom).offset(padding);
                    make.height.equalTo(lastView);
                }];
            }
            lastView = video;
        }
    }];
    
    [lastView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(containerView).offset(-padding);
    }];
}

//等分布局
- (void)makeVideoViews:(NSMutableArray *)views containerView:(UIView *)containerView itemWidth:(CGFloat)itemWidth itemHeight:(CGFloat)itemHeight warpCount:(NSInteger)warpCount{
    
    __block UIView *lastView;
    
    [views enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIView class]]) {
            UIView *video = (UIView *)obj;
            
            [video mas_remakeConstraints:^(MASConstraintMaker *make) {
                //***清除旧约束***  同时注意使用约束方式，否则可能导致布局失效
            }];
            [containerView insertSubview:video atIndex:0];
            [self makeAllControlTop:video];
            
            NSInteger rowCount = views.count % warpCount == 0 ? views.count / warpCount : views.count / warpCount + 1;
            
            // 当前行
            NSInteger currentRow = idx / warpCount;
            // 当前列
            NSInteger currentColumn = idx % warpCount;
            
            [video mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.width.equalTo(@(itemWidth));
                
                make.height.equalTo(@(itemHeight));
                
                // 第一行
                if (currentRow == 0) {
                    make.top.equalTo(containerView);
                }
                
                // 最后一行
                if (currentRow == rowCount - 1) {
                    make.bottom.equalTo(containerView);
                }
                
                // 中间的若干行
                if (currentRow != 0 && currentRow != rowCount - 1){
                    make.bottom.equalTo(lastView.mas_bottom);
                }
                
                // 第一列
                if (currentColumn == 0) {
                    make.left.equalTo(containerView);
                }
                // 最后一列
                if (currentColumn == warpCount - 1) {
                    make.right.equalTo(containerView);
                }
                // 中间若干列
                if (currentColumn != 0 && currentColumn != warpCount - 1) {
                    make.left.equalTo(lastView.mas_right);
                }
            }];
            lastView = video;
        }
    }];
}

// 根据分辨率显示，防止拉伸压缩
- (void)makeResolution:(NSMutableArray *)videoArr itemWidth:(CGFloat)itemWidth itemHeight:(CGFloat)itemHeight{
    
    [videoArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[ATVideoView class]]) {
            ATVideoView *video = (ATVideoView *)obj;
            
            CGFloat sizeW = video.videoSize.width;
            CGFloat sizeH = video.videoSize.height;
            
            CGFloat value0 = 0;
            CGFloat value1 = 0;
            
            if (sizeW != 0 && sizeH != 0) {
                
                //固定高填充宽
                if (itemHeight * sizeW/sizeH > itemWidth) {
                    value0 = (itemHeight * sizeW/sizeH) * itemHeight;
                }
                
                //固定宽填充高
                if (itemWidth * sizeH/sizeW > itemHeight) {
                    value1 = (itemWidth * sizeH/sizeW) * itemWidth;
                }
                
                [video addSubview:video.localView];
                
                //取面积小的进行扩充
                if ((value0 > value1 && value1 != 0) || value0 == 0){
                    //固定宽填充高
                    [video.localView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.width.equalTo(video);
                        make.height.equalTo(video.mas_width).multipliedBy(sizeH/sizeW);
                        make.center.equalTo(video);
                    }];
                } else {
                    //固定高填充宽
                    [video.localView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.height.equalTo(video);
                        make.width.equalTo(video.mas_height).multipliedBy(sizeW/sizeH);
                        make.center.equalTo(video);
                    }];
                }
                video.clipsToBounds = YES;
            }
        }
        if ([obj isKindOfClass: [UIView class]]) {
            UIView *video = (UIView *)obj;
            video.clipsToBounds = YES;
        }
    }];
}

//确保不遮挡其它子视图（如无可不调用）
- (void)makeAllControlTop:(UIView *)video {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (id obj in video.subviews) {
            if ([obj isKindOfClass:[UILabel class]] || [obj isKindOfClass:[UIButton class]]) {
                [video bringSubviewToFront:obj];
            }
        }
    });
}

//横屏  UIInterfaceOrientation.landscapeLeft    竖屏：UIInterfaceOrientation.portrait
- (void)orientationRotating:(UIInterfaceOrientation)direction{
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationUnknown] forKey:@"orientation"];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    (direction == UIInterfaceOrientationLandscapeLeft) ? (appDelegate.allowRotation = YES) : (appDelegate.allowRotation = NO);
    
    NSNumber *value = [NSNumber numberWithInt:direction];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
}

//MARK: - 自定义bar

- (void)customNavigationBar:(NSString *)title{
    UIView *navBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    navBar.backgroundColor = RGB(248, 248, 255);
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 100)/2, 25, 100, 30)];
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    label.tintColor = [UIColor blackColor];
    [navBar addSubview:label];
    [self.view addSubview:navBar];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(10, 25, 44, 30);
    [backButton setImage:[UIImage imageNamed:@"return_image"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
}

- (void)backButtonClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
