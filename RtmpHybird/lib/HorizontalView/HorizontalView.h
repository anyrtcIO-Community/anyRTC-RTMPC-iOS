//
//  HorizontalView.h
//  HorizontalCollectionView
//
//  Created by jianqiangzhang on 16/6/21.
//  Copyright © 2016年 jianqiangzhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HorizontalView : UIView

@property (nonatomic, copy)void(^DidSelectedItemBlock)(id item);

- (void)setMumberArray:(NSArray*)array;

@end
