//
//  ASHUD.h
//  MyASASPD
//
//  Created by work on 15/1/14.
//  Copyright (c) 2015年 work. All rights reserved.
//

//#import "ASObject.h"
#import "MBProgressHUD.h"

@interface ASHUD : NSObject<MBProgressHUDDelegate>

@property (nonatomic, strong) MBProgressHUD *HUD;

+ (ASHUD *)showHUDWithStayLoadingStyleInView:(UIView *)view belowView:(UIView *)belowView content:(NSString *)content;

+ (void)hideHUD;
- (void)removeProgressHUD;

+ (ASHUD *)showHUDWithLoadingStyleInView:(UIView *)view belowView:(UIView *)belowView content:(NSString *)content;
+ (void)showHUDWithCompleteStyleInView:(UIView *)view content:(NSString *)content icon:(NSString *)icon;




+ (ASHUD *)showSwitchingHUDInView:(UIView *)view;

- (void)setSwitchingProgressBlock:(void (^)())progress;

- (void)setSwitchingCustomModeWithContent:(NSString *)content icon:(NSString *)icon;


@end
