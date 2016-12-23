//
//  HosterView.m
//  RTMPCDemo
//
//  Created by jianqiangzhang on 2016/12/19.
//  Copyright © 2016年 EricTao. All rights reserved.
//

#import "HosterView.h"
#import "Masonry.h"
#import "PersonItem.h"
#import "UIImageView+WebCache.h"

#define HeadItemHeight 36

@interface HosterView()

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *nickLabel;

@property (nonatomic, strong) CAShapeLayer *pulseLayer;
@property (nonatomic, strong) CAAnimationGroup *groupAnima;

@property (nonatomic, assign) BOOL isAnimation;

@end

@implementation HosterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 6;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor colorWithRed:128.0/255.0 green:138.0/255.0 blue:135.0/255.0 alpha:1.0];
        
        [self addSubview:self.headImageView];
        [self addSubview:self.nickLabel];
//        [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.mas_left).offset(10);
//            make.height.equalTo(self.mas_height).multipliedBy(.8);
//            make.width.equalTo(self.headImageView.mas_height);
//            make.centerY.equalTo(self.mas_centerY);
//        }];
//        [self.nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.headImageView.mas_right).offset(5);
//            make.centerY.equalTo(self.mas_centerY);
//            make.right.equalTo(self.mas_right).offset(-10);
//            
//        }];
    }
    return self;
}
- (void)setItem:(id)item {
    
    PersonItem *perItem = item;
    if (perItem.headURl.length == 0) {
        self.headImageView.image = [UIImage imageNamed:@"icon_photo_2"];
    }else{
         [self.headImageView sd_setImageWithURL:[NSURL URLWithString:perItem.headURl] placeholderImage:[UIImage imageNamed:@"icon_photo_2"]];
    }
  
    self.nickLabel.text = perItem.nickName;
    
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


- (UIImageView*)headImageView {
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 4.5, HeadItemHeight, HeadItemHeight)];
        _headImageView.layer.cornerRadius = HeadItemHeight/2;
        _headImageView.layer.masksToBounds = YES;
    }
    return _headImageView;
}
- (UILabel *)nickLabel {
    if (!_nickLabel) {
          _nickLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.headImageView.frame)+5, 0, CGRectGetWidth(self.frame)-CGRectGetMaxX(self.headImageView.frame)-5,self.frame.size.height) ];
        _nickLabel.adjustsFontSizeToFitWidth = YES;
//        _nickLabel.font = [UIFont systemFontOfSize:16];
        _nickLabel.textColor = [UIColor whiteColor];
    }
    return _nickLabel;
}
- (CAShapeLayer*)pulseLayer {
    if (!_pulseLayer) {
        _pulseLayer = [CAShapeLayer layer];
        _pulseLayer.frame = self.headImageView.frame;
        _pulseLayer.path = [UIBezierPath bezierPathWithOvalInRect:_headImageView.bounds].CGPath;
        _pulseLayer.fillColor = [UIColor clearColor].CGColor;//填充色
        _pulseLayer.borderColor = [UIColor redColor].CGColor;
        _pulseLayer.borderWidth = 1;
        _pulseLayer.cornerRadius = _headImageView.bounds.size.width / 2;
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
        scaleAnima.toValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 1.4, 1.4, 0.0)];
        
        _groupAnima = [CAAnimationGroup animation];
        _groupAnima.animations = @[opacityAnima, scaleAnima];
        _groupAnima.duration = 2.0;
        _groupAnima.autoreverses = NO;
        _groupAnima.repeatCount = HUGE;
        
    }
    return _groupAnima;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
