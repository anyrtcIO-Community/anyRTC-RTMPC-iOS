//
//  AudioShowView.m
//  RTMPCDemo
//
//  Created by jianqiangzhang on 2016/11/23.
//  Copyright © 2016年 EricTao. All rights reserved.
//

#import "AudioShowView.h"
#import "UIImageView+WebCache.h"

@interface AudioShowView()

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) NSString *markID;

@property (nonatomic, strong) CAShapeLayer *pulseLayer;
@property (nonatomic, strong) CAAnimationGroup *groupAnima;

@property (nonatomic, assign) BOOL isAnimation;

@end

@implementation AudioShowView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.borderWidth = .5;
        self.layer.borderColor = [UIColor grayColor].CGColor;
        self.layer.cornerRadius = frame.size.width/2;
        
        [self addSubview:self.headImageView];
        [self addSubview:self.nameLabel];
        self.headImageView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        self.nameLabel.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        
    }
    return self;
}

- (void)headUrl:(NSString*)url withName:(NSString*)name withID:(NSString*)peerID {
    self.markID = peerID;
    if (self.headImageView) {
        __weak typeof(self)weakSelf = self;
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"icon_photo_2"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                weakSelf.headImageView.image = [weakSelf getYuan:image];
            }else{
                weakSelf.headImageView.image = [UIImage imageNamed:@"icon_photo_2"];
            }
        }];
    }
    if (self.nameLabel) {
        self.nameLabel.text = name;
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


#pragma mark - get
- (UIImageView*)headImageView {
    if (!_headImageView) {
        _headImageView = [UIImageView new];
    }
    return _headImageView;
}
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = [UIFont systemFontOfSize:13];
    }
    return _nameLabel;
}
- (UIImage *)getYuan:(UIImage*)image {
    
    //1.开启一个位图上下文(大小跟图片一样大)
    UIGraphicsBeginImageContext(image.size);
    
    //2.做裁剪.(对之前已经画上去的东西,不会有做用.)
    //2.1 bezierPathWithOvalInRect方法后面传的Rect,可以看作(x,y,width,height),前两个参数是裁剪的中心点,后面两个决定裁剪的区域是圆形还是椭圆.
    
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    
    //把路径设置为裁剪区域(超出裁剪区域以外的内容会自动裁剪掉.)
    
    [path addClip];
    //3.把图片绘制到上下文当中
    
    [image drawAtPoint:CGPointZero];
    
    //4.从上下文当中生成一张图片
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //5.关闭上下文
    UIGraphicsEndImageContext();
    
    return newImage;
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
