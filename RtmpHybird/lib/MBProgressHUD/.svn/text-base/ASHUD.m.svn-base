//
//  ASHUD.m
//  MyASASPD
//
//  Created by work on 15/1/14.
//  Copyright (c) 2015年 work. All rights reserved.
//

#import "ASHUD.h"

#define ASHUDInstance [ASHUD sharedInstance]

@interface ASHUD ()

@property (nonatomic, copy) void (^progressBlock)();

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *icon;

@end

@implementation ASHUD

- (void)setSwitchingProgressBlock:(void (^)())progress {
    self.progressBlock = progress;
}

+ (ASHUD *)showSwitchingHUDInView:(UIView *)view {
    return [[ASHUD sharedInstance] showSwitchingHUDInView:view];
}


- (ASHUD *)showSwitchingHUDInView:(UIView *)view {
    _HUD = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:_HUD];
    _HUD.delegate = self;
    [_HUD showWhileExecuting:@selector(processTask) onTarget:self withObject:nil animated:YES];
    return ASHUDInstance;
}

- (void)processTask {
    while (_HUD.mode == MBProgressHUDModeIndeterminate);
    
    while (_HUD.mode == MBProgressHUDModeAnnularDeterminate) {
        if (_progressBlock) {
            _progressBlock();
        }
    }
    sleep(1);
    __block UIImageView *imageView;
    dispatch_sync(dispatch_get_main_queue(), ^{
        UIImage *image = [UIImage imageNamed:_icon];
        imageView = [[UIImageView alloc] initWithImage:image];
    });
    _HUD.customView = imageView;
    _HUD.labelText = _content;
    _HUD.mode = MBProgressHUDModeCustomView;
    sleep(2);
}

- (void)setSwitchingCustomModeWithContent:(NSString *)content icon:(NSString *)icon {
    self.content = content;
    self.icon = icon;
    _HUD.mode = -1;
}


+ (ASHUD *)sharedInstance {
    static ASHUD *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[ASHUD alloc] init];
    });
    return _sharedInstance;
}



- (ASHUD *)showHUDWithLoadingStyleInView:(UIView *)view belowView:(UIView *)belowView content:(NSString *)content {
    [_HUD hide:YES];
    [ASHUD showHUDWithLoadingStyleInView:view belowView:belowView content:content];
    return ASHUDInstance;
}

- (void)removeProgressHUD {
    [_HUD removeFromSuperview];
}

+ (ASHUD *)showHUDWithLoadingStyleInView:(UIView *)view belowView:(UIView *)belowView content:(NSString *)content {
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    HUD.opacity = 0.7;
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = content;
    [HUD show:YES];
    ASHUDInstance.HUD = HUD;
    if (belowView) {
        [view insertSubview:HUD belowSubview:belowView];
    }else{
        [view addSubview:HUD];
        [view bringSubviewToFront:HUD];
    }
    
    return ASHUDInstance;
}

- (void)hideHUD {
    [_HUD hide:YES];
}


+ (void)showHUDWithCompleteStyleInView:(UIView *)view content:(NSString *)content icon:(NSString *)icon {
    __block MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:HUD];
    HUD.labelText = content;
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.opacity = 0.7;
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:icon]];
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(2);
    } completionBlock:^{
        [HUD removeFromSuperview];
        HUD = nil;
    }];
}

+ (ASHUD *)showHUDWithStayLoadingStyleInView:(UIView *)view belowView:(UIView *)belowView content:(NSString *)content {
    return [ASHUDInstance showHUDWithLoadingStyleInView:view belowView:belowView content:content];
}
+ (void)hideHUD {
    [ASHUDInstance hideHUD];
}

#pragma mark - MBProgressHUDDelegate

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [_HUD removeFromSuperview];
    _HUD = nil;
}


@end
