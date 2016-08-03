//
//  DanmuLaunchView.m
//  MessageLivingDemo
//
//  Created by jianqiangzhang on 16/8/2.
//  Copyright © 2016年 jianqiangzhang. All rights reserved.
//

#import "DanmuLaunchView.h"
#import "DanmuItemView.h"

@interface DanmuLaunchView()
{
    NSMutableArray *grounderArray;
    NSMutableArray *modelArray;
    NSInteger grounderCount;
}
@end

@implementation DanmuLaunchView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        grounderArray = [[NSMutableArray alloc] init];
        modelArray = [[NSMutableArray alloc] init];
        grounderCount = 0;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nextView:) name:@"nextView" object:nil];
        // 默认三条通道
        for (int i = 0; i < 3; i++) {
            DanmuItemView *grounder = [[DanmuItemView alloc] init];
            grounder.isShow = NO;
            grounder.index = i;
            [grounderArray addObject:grounder];
        }
    }
    return self;
}

- (void)setModel:(DanmuItem*)model{
    [modelArray addObject:model];
    [self checkView];
}

- (void)nextView:(NSNotification *)notification{
    [self checkView];
}

- (void)checkView{
    if (modelArray.count == 0) {
        return;
    }
    __weak DanmuLaunchView *this = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        for (DanmuItemView *view in grounderArray) {
            if (view.isShow == NO) {
                switch (view.index) {
                    case 0:
                        view.selfYposition = CGRectGetHeight(self.frame)-ItemHeight - ItemSpace;
                        break;
                    case 1:
                        view.selfYposition = CGRectGetHeight(self.frame)-2*ItemHeight-2*ItemSpace;
                        break;
                    case 2:
                        view.selfYposition = CGRectGetHeight(self.frame)-3*ItemHeight-3*ItemSpace;
                        break;
                    default:
                        break;
                }
                view.isShow = YES;
                [view setContent:modelArray[0]];
                [this addSubview:view];
                [view grounderAnimation:modelArray[0]];
                [modelArray removeObjectAtIndex:0];
                break;
            }
        }
    });
}
@end