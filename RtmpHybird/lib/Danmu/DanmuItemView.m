//
//  DanmuItemView.m
//  MessageLivingDemo
//
//  Created by jianqiangzhang on 16/8/2.
//  Copyright © 2016年 jianqiangzhang. All rights reserved.
//

#import "DanmuItemView.h"
#import "UIImageView+WebCache.h"

@interface DanmuItemView()
{
    UILabel * titleLabel;
    UIImageView * headImage;
    UILabel * nameLabel;
    float viewWidth;
}
@end
@implementation DanmuItemView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = ItemHeight/2;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.6];
        
        titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [self addSubview:titleLabel];
        
        nameLabel = [[UILabel alloc] init];
        nameLabel.textColor = [UIColor colorWithRed:4.0/255.0 green:175.0/200 blue:200.0/255.0 alpha:1.0];
        nameLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:nameLabel];
        
        headImage = [[UIImageView alloc] init];
        headImage.clipsToBounds = YES;
        headImage.frame = CGRectMake(0, 0, ItemHeight, ItemHeight);
        headImage.layer.cornerRadius = ItemHeight/2;
        headImage.layer.borderWidth = 0.5;
        headImage.layer.borderColor = [UIColor whiteColor].CGColor;
        [self addSubview:headImage];
    }
    return self;
}

- (void)setContent:(DanmuItem*)model{
    
    nameLabel.text = model.u_nickName;
    nameLabel.frame = CGRectMake(ItemHeight+5, 0, [DanmuItemView calculateMsgWidth:nameLabel.text andWithLabelFont:[UIFont systemFontOfSize:12] andWithHeight:10], ItemHeight/2);
    
    // 头像
    [headImage sd_setImageWithURL:[NSURL URLWithString:model.thumUrl] placeholderImage:[UIImage imageNamed:@"icon_photo_2"]];
    
    titleLabel.text = model.content;
    titleLabel.frame = CGRectMake(ItemHeight+5, ItemHeight/2, [DanmuItemView calculateMsgWidth:titleLabel.text andWithLabelFont:[UIFont boldSystemFontOfSize:12] andWithHeight:18], ItemHeight/2);
    
    viewWidth = titleLabel.frame.size.width + ItemHeight*1.5;
    if (nameLabel.frame.size.width > titleLabel.frame.size.width) {
        viewWidth = nameLabel.frame.size.width + ItemHeight*1.5;
    }
    self.frame = CGRectMake(kScreenWidth + 20, self.selfYposition, viewWidth, ItemHeight);
    
}

- (void)grounderAnimation:(id)model{
    float second = 0.0;
    if (titleLabel.text.length < 30){
        second = 8.0f;
    }else{
        second = titleLabel.text.length/3;
    }
    
    [UIView animateWithDuration:second animations:^{
        self.frame = CGRectMake( - viewWidth - 20, self.frame.origin.y, viewWidth, ItemHeight);
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
        self.isShow = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"nextView" object:nil];
    }];
}

+ (CGFloat)calculateMsgWidth:(NSString *)msg andWithLabelFont:(UIFont*)font andWithHeight:(NSInteger)height {
    if ([msg isEqualToString:@""]) {
        return 0;
    }
    CGFloat messageLableWidth = [msg boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName:font}
                                                  context:nil].size.width;
    return messageLableWidth + 1;
}

@end
