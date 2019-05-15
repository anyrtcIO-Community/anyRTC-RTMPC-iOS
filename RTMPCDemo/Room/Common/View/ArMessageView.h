//
//  ArMessageView.h
//  RTMPCDemo
//
//  Created by 余生丶 on 2019/4/15.
//  Copyright © 2019 anyRTC. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ArMessageModel : NSObject
//昵称
@property (nonatomic ,copy) NSString *userName;
//消息内容
@property (nonatomic ,copy) NSString *content;
@property (nonatomic ,copy) NSString *userid;
@property (nonatomic ,assign) BOOL isAudio;

@end

@interface ArMessageView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *infoArr;

- (void)addMessage:(ArMessageModel *)model;

@end

NS_ASSUME_NONNULL_END
