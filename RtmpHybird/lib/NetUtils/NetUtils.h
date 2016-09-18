//
//  NetUtils.h
//  RtmpHybird
//
//  Created by jianqiangzhang on 16/7/27.
//  Copyright © 2016年 jianqiangzhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewController.h"
#import "AppDelegate.h"


@interface NetUtils : NSObject

+ (NetUtils*)shead;

typedef void (^GetLivingListsBlock)(NSArray *array,NSError*error,int code);
/**
 *  获取直播列表
 *
 *  @param resultBlock 回调
 */
- (void)getLivingList:(GetLivingListsBlock)resultBlock;

/**
 *  请求服务录像
 *
 *  @param strRtmpUrl 推流的URL
 *  @param anyrtcID   anyrtcID
 *  @param resID      liveID
 */
typedef void (^GetRecordDictBlock)(NSDictionary *dict,NSError*error,int code);
- (void)recordRtmpSteam:(NSString *)strRtmpUrl withAnyrtcID:(NSString*)anyrtcID withResID:(NSString*)resID withResult:(GetRecordDictBlock)resultBlock;

/**
 *  关闭录像服务
 *
 *  @param strVodSvrId   录像成功时响应的VodSvrId
 *  @param strVodResTag  录像成功时响应的VodResTag
 *  @param resultBlock   结果回调
 */
typedef void (^CloseRecordBlock)(NSError*error,int code);
- (void)closerEecRtmpStream:(NSString*)strVodSvrId withVodResTag:(NSString*)strVodResTag withResult:(CloseRecordBlock)resultBlock;

@end
