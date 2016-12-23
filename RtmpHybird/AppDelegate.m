//
//  AppDelegate.m
//  RtmpHybird
//
//  Created by jianqiangzhang on 16/7/27.
//  Copyright © 2016年 jianqiangzhang. All rights reserved.
//

#import "AppDelegate.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "WXApi.h"
#import <Bugly/Bugly.h>
#import <RTMPCHybirdEngine/RTMPCHybirdEngineKit.h>
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

#warning Error 这里填写自己在平台下自己的账户，如果欠费，请联系客服，进行优惠充值
    /**
     *  配置SDK,相关参数请看集成文档
     */
    [RTMPCHybirdEngineKit InitEngineWithAnyrtcInfo:developerID andAppId:appID andKey:key andToke:token];
    /**
     *  私有云配置（默认走公网）
     */
 //   [RTMPCHybirdEngineKit ConfigServerForPriCloud:@"192.168.7.207" andPort:9060];
    // 异常上报
    [Bugly startWithAppId:@"1a89110a7b"];
    //向微信注册
    [WXApi registerApp:@"wxb25fbdbe18554735" withDescription:@"demo 2.0"];
    // 尚未完成
    [UMSocialData setAppKey:@"577b16fb67e58e19500018ff"];
    //设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:@"wxb25fbdbe18554735" appSecret:@"83a01dea70b6e81ab63927f9d68fd32f" url:@"http://www.umeng.com/social"];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url  {
   
    BOOL result = [UMSocialSnsService handleOpenURL:url];

    return result;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options {
  
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    
    return result;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
