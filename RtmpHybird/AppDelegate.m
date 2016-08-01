//
//  AppDelegate.m
//  RtmpHybird
//
//  Created by jianqiangzhang on 16/7/27.
//  Copyright © 2016年 jianqiangzhang. All rights reserved.
//

#import "AppDelegate.h"
#import "WXApi.h"

#import <RTMPCHybirdEngine/RTMPCHybirdEngineKit.h>
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    /**
     *  配置SDK,相关参数请看集成文档
     */
    [RTMPCHybirdEngineKit InitEngineWithAnyrtcInfo:developerID andAppId:appID andKey:key andToke:token];
    /**
     *  私有云配置（默认走公网）
     */
//    [RTMPCHybirdEngineKit ConfigServerForPriCloud:@"192.168.7.207" andPort:9060];
    
//    //向微信注册
//    [WXApi registerApp:@"wxd930ea5d5a258f4f" withDescription:@"demo 2.0"];
//    
//    //向微信注册支持的文件类型
//    UInt64 typeFlag = MMAPP_SUPPORT_TEXT | MMAPP_SUPPORT_PICTURE | MMAPP_SUPPORT_VIDEO |MMAPP_SUPPORT_AUDIO | MMAPP_SUPPORT_WEBPAGE;
//    
//    [WXApi registerAppSupportContentFlag:typeFlag];
    
    return YES;
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
