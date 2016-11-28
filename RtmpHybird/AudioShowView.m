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

- (void)headUrl:(NSString*)url withName:(NSString*)name withID:(NSString*)peerID{
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
