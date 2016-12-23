//
//  HeadCollectionViewCell.m
//  HorizontalCollectionView
//
//  Created by jianqiangzhang on 16/6/21.
//  Copyright © 2016年 jianqiangzhang. All rights reserved.
//

#import "HeadCollectionViewCell.h"
#import "Masonry.h"
#import "PersonItem.h"
#import "UIImageView+WebCache.h"

#define HeadItemHeight 36
@interface HeadImageView:UIView

- (void)show;
- (void)dismiss;

- (void)setItem:(id)item;

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) CAShapeLayer *pulseLayer;
@property (nonatomic, strong) CAAnimationGroup *groupAnima;

@property (nonatomic, assign) BOOL isAnimation;

@end

@implementation HeadImageView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.headImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.headImageView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.headImageView];
        
        [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY);
            make.width.height.equalTo(@[@(HeadItemHeight)]);
        }];
        
        self.headImageView.layer.cornerRadius = HeadItemHeight/2;
        self.headImageView.layer.masksToBounds = YES;
        self.headImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        self.headImageView.layer.borderWidth = 0.2;
        
    }
    return self;
}
- (void)layoutSubviews {
    NSLog(@"");
}
- (CAShapeLayer*)pulseLayer {
    if (!_pulseLayer) {
        _pulseLayer = [CAShapeLayer layer];
        _pulseLayer.frame = self.layer.bounds;
        _pulseLayer.path = [UIBezierPath bezierPathWithOvalInRect:_pulseLayer.bounds].CGPath;
        _pulseLayer.fillColor = [UIColor clearColor].CGColor;//填充色
        _pulseLayer.borderColor = [UIColor redColor].CGColor;
        _pulseLayer.borderWidth = 1;
        _pulseLayer.cornerRadius = self.frame.size.height / 2;
        _pulseLayer.opacity = 0.0;
    }
    return _pulseLayer;
}

- (CAAnimationGroup*)groupAnima {
    if (!_groupAnima) {
        //可以复制layer
        CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
        replicatorLayer.frame = self.bounds;
        replicatorLayer.instanceCount = 4;//创建副本的数量,包括源对象。
        replicatorLayer.instanceDelay = .5;//复制副本之间的延迟
        [replicatorLayer addSublayer:_pulseLayer];
        [self.layer addSublayer:replicatorLayer];
        
        CABasicAnimation *opacityAnima = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacityAnima.fromValue = @(1.0);
        opacityAnima.toValue = @(0.0);
        
        CABasicAnimation *scaleAnima = [CABasicAnimation animationWithKeyPath:@"transform"];
        scaleAnima.fromValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 0.9, 0.9, 0.0)];
        scaleAnima.toValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 1.3, 1.3, 0.0)];
        
        _groupAnima = [CAAnimationGroup animation];
        _groupAnima.animations = @[opacityAnima, scaleAnima];
        _groupAnima.duration = 2.0;
        _groupAnima.autoreverses = NO;
        _groupAnima.repeatCount = HUGE;

    }
    return _groupAnima;
}

- (void)setItem:(id)item {
 
    PersonItem *perItem = item;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:perItem.headURl] placeholderImage:[UIImage imageNamed:@"icon_photo_2"]];
    
    if (perItem.isSpeak) {
        [self show];
    }
}
- (void)show {
    if (!self.isAnimation) {
        [self.pulseLayer addAnimation:self.groupAnima forKey:@"groupAnimation"];
        self.isAnimation = YES;
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismiss) object:nil];
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:1];
}

- (void)dismiss {
    if (self.isAnimation) {
        [self.pulseLayer removeAllAnimations];
        self.isAnimation = NO;
    }
}


@end

@interface HeadCollectionViewCell()
@property (nonatomic, strong) HeadImageView *headImageView;
@end

@implementation HeadCollectionViewCell

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.headImageView = [[HeadImageView alloc] init];
        [self addSubview:self.headImageView];
        [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    NSLog(@"");
}
- (void)setItem:(id)item {
    [self.headImageView setItem:item];
    
}
@end
