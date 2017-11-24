//
//  FBWaterHeadView.m
//  咻一咻
//
//  Created by derek on 2017/8/22.
//  Copyright © 2017年 derek. All rights reserved.
//

#import "FBWaterHeadView.h"
#import <Masonry.h>

@interface FBWaterHeadView ()
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) CAAnimationGroup *groupAnima;
@property (nonatomic, strong) CAReplicatorLayer *replicatorLayer;
@property (nonatomic, assign) BOOL isAnimation;
@end

@implementation FBWaterHeadView
- (void)dealloc {
    
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initLayOut];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initLayOut];
    }
    return self;
}

- (void)layoutSubviews {
     [self tran];
}

- (void)dismiss {
    if (self.isAnimation) {
        [self.shapeLayer removeAllAnimations];
        self.isAnimation = NO;
    }
}

- (void)startAnimation:(int)time {
    if (time == 0) {
        NSLog(@"startAnimation:%d",time);
        return;
    }
    NSLog(@"time:%d",time);
    float animationTime = time/1000.00;
    
    if (!self.isAnimation) {
        self.groupAnima.duration = animationTime;
        self.shapeLayer.borderColor= [UIColor colorWithRed:arc4random() %254/255.0 green:arc4random() %254/255.0 blue:arc4random() %254/255.0 alpha:1.0].CGColor;
        [self.shapeLayer addAnimation:self.groupAnima forKey:@"groupAnimation"];
        self.isAnimation = YES;
    }
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismiss) object:nil];
    
    [self performSelector:@selector(dismiss)withObject:nil afterDelay:.5];
}

- (void)removeLayer:(CALayer*)layer{
    
    [layer removeFromSuperlayer];
}

- (void)initLayOut {
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.fbHeadImageView];
    [self.fbHeadImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(self.mas_width).multipliedBy(.6);
        make.height.equalTo(self.mas_height).multipliedBy(.6);
    }];
}

- (void)tran {
    if (self.groupAnima) {
        [self dismiss];
        self.fbHeadImageView.layer.cornerRadius = self.fbHeadImageView.bounds.size.width/2;
        _shapeLayer.frame = self.fbHeadImageView.frame;
        _shapeLayer.path = [UIBezierPath bezierPathWithOvalInRect:self.fbHeadImageView.bounds].CGPath;
        _shapeLayer.cornerRadius = self.fbHeadImageView.bounds.size.width / 2;
        _replicatorLayer.frame = self.bounds;
        [self startAnimation:360];
    }
}
#pragma mark - get
- (UIImageView *)fbHeadImageView {
    if (!_fbHeadImageView) {
        _fbHeadImageView = [[UIImageView alloc] init];
        _fbHeadImageView.layer.cornerRadius = 30;
        _fbHeadImageView.layer.masksToBounds = YES;
        _fbHeadImageView.image = [UIImage imageNamed:@"headurl"];
    }
    return _fbHeadImageView;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    NSLog(@"drawRect:%f",self.fbHeadImageView.bounds.size.width);
    if (self.fbHeadImageView.bounds.size.width!=0) {
        if (!self.shapeLayer) {
            _shapeLayer = [CAShapeLayer layer];
            _shapeLayer.frame = self.fbHeadImageView.frame;
            _shapeLayer.path = [UIBezierPath bezierPathWithOvalInRect:self.fbHeadImageView.bounds].CGPath;
            _shapeLayer.fillColor = [UIColor clearColor].CGColor;//填充色
            _shapeLayer.borderColor = [UIColor redColor].CGColor;
            _shapeLayer.borderWidth = 1;
            _shapeLayer.cornerRadius = self.fbHeadImageView.bounds.size.width / 2;
            _shapeLayer.opacity = 0.0;
        }
        if (!self.groupAnima) {
            //可以复制layer
            _replicatorLayer = [CAReplicatorLayer layer];
            _replicatorLayer.frame = self.bounds;
            _replicatorLayer.instanceCount = 4;//创建副本的数量,包括源对象。
            _replicatorLayer.instanceDelay = .5;//复制副本之间的延迟
            [_replicatorLayer addSublayer:_shapeLayer];
            
            [self.layer insertSublayer:_replicatorLayer below:self.fbHeadImageView.layer];
            
            CABasicAnimation *opacityAnima = [CABasicAnimation animationWithKeyPath:@"opacity"];
            opacityAnima.fromValue = @(1.0);
            opacityAnima.toValue = @(0.0);
            
            CABasicAnimation *scaleAnima = [CABasicAnimation animationWithKeyPath:@"transform"];
            scaleAnima.fromValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 1.1, 1.1, 0.0)];
            scaleAnima.toValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 1.6, 1.6, 0.0)];
            
            _groupAnima = [CAAnimationGroup animation];
            _groupAnima.animations = @[opacityAnima, scaleAnima];
            
            _groupAnima.autoreverses = NO;
            _groupAnima.repeatCount = HUGE;
        }
    }
    
}

@end

