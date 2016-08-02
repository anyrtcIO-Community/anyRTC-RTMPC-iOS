//
//  CustomSwitch.m
//  MessageLivingDemo
//
//  Created by jianqiangzhang on 16/5/12.
//  Copyright © 2016年 jianqiangzhang. All rights reserved.
//

#import "CustomSwitch.h"
#import "UIColor+Category.h"
#define Beishuo 0.45

@interface CustomSwitch()
{
    CGPoint beginPoint;
    NSLayoutConstraint *leftConstranint;
}
@property (strong, nonatomic)UIImageView *bgImageV;
@property (strong, nonatomic)UIImageView *onOffBtn;
@property (assign)BOOL isShowListViewRight;
@property (nonatomic, strong) UISwitch *switchView;
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation CustomSwitch
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setFrame:frame];
        [self initCtrl];
    }
    return self;
}
-(void)initCtrl{
    
    self.bgImageV = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.bgImageV.layer.cornerRadius = 6;
    [_bgImageV setBackgroundColor:[UIColor grayColor]];
   // [_bgImageV setImage:[UIImage imageNamed:@"onBtnBg"]];
    [self addSubview:self.bgImageV];
    self.bgImageV.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *one = [NSLayoutConstraint constraintWithItem:self.bgImageV attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0];
    NSLayoutConstraint *two = [NSLayoutConstraint constraintWithItem:self.bgImageV attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
    NSLayoutConstraint *three = [NSLayoutConstraint constraintWithItem:self.bgImageV attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0];
    NSLayoutConstraint *four = [NSLayoutConstraint constraintWithItem:self.bgImageV attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
    [self addConstraints:@[one,two,three,four]];
    
    _isShowListViewRight = NO;
    
    self.onOffBtn = [[UIImageView alloc] initWithFrame:CGRectZero];//CGRectMake(1, 12, 33, 27)
    [self.onOffBtn setBackgroundColor:[UIColor whiteColor]];
    self.onOffBtn.layer.cornerRadius = 3;
 //   [self.onOffBtn setImage:[UIImage imageNamed:@"offBtn"]];//SETIMAGE(@"offBtn.png")
    [self addSubview:self.onOffBtn];
    self.onOffBtn.translatesAutoresizingMaskIntoConstraints = NO;
    leftConstranint = [NSLayoutConstraint constraintWithItem:self.onOffBtn attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:2.0];
    NSLayoutConstraint *two1 = [NSLayoutConstraint constraintWithItem:self.onOffBtn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:2.0];
  
    NSLayoutConstraint *four1= [NSLayoutConstraint constraintWithItem:self.onOffBtn attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-2.0];
    
    NSLayoutConstraint *three1 = [NSLayoutConstraint constraintWithItem:self.onOffBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1-Beishuo constant:0];
    
    [self addConstraints:@[leftConstranint,two1,three1,four1]];
    
    self.titleLabel = [UILabel new];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.backgroundColor = [UIColor clearColor];
    [self.titleLabel setAdjustsFontSizeToFitWidth:YES];
     self.titleLabel.text = @"弹幕";
    self.titleLabel.textColor = [UIColor grayColor];
    [self.onOffBtn addSubview:self.titleLabel];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *one2 = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.onOffBtn attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0];
    NSLayoutConstraint *two2 = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.onOffBtn attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
    NSLayoutConstraint *three2 = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.onOffBtn attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0];
    NSLayoutConstraint *four2 = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.onOffBtn attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
    [self.onOffBtn addConstraints:@[one2,two2,three2,four2]];
   
}

- (void)setOn:(BOOL)on animated:(BOOL)animated
{
    _isShowListViewRight = on;
    if (_isShowListViewRight)
        [self swipeRightView:animated];
    else
        [self swipeLeftView:animated];
    
    
}
-(void)swipeLeftView:(BOOL)animation{
//    [self.bgImageV setImage:[UIImage imageNamed:@"offBtnBg"]];
    self.bgImageV.backgroundColor = [UIColor grayColor];
//    [self.onOffBtn setImage:[UIImage imageNamed:@"offBtn"]];
//    self.onOffBtn.backgroundColor = [UIColor whiteColor];
    self.titleLabel.textColor = [UIColor grayColor];
    
    leftConstranint.constant = 2;
    
    if (animation) {
       
        [UIView animateWithDuration:0.1 animations:^{
            [self layoutIfNeeded];
        }];
    }else{
        [self layoutIfNeeded];
    }
}


-(void)swipeRightView:(BOOL)animation{
//    [self.bgImageV setImage:[UIImage imageNamed:@"onBtnBg"]];
    self.bgImageV.backgroundColor = [UIColor colorWithHexString:@"2fcf6f"];
//    [self.onOffBtn setImage:[UIImage imageNamed:@"onBtn"]];
     self.titleLabel.textColor = [UIColor colorWithHexString:@"2fcf6f"];
   leftConstranint.constant = self.frame.size.width*Beishuo-2;
    
    if (animation) {
        
        [UIView animateWithDuration:0.1 animations:^{
            [self layoutIfNeeded];
        }];
    }else{
        [self layoutIfNeeded];
    }
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    beginPoint = [touch locationInView:self];
    if(_isShowListViewRight == NO)
    {
        [self swipeRightView:YES];
        _isShowListViewRight = YES;
        if ([_delegate respondsToSelector:@selector(customSwitchOn)]) {
            [_delegate customSwitchOn];
        }
    }else
    {
        [self swipeLeftView:YES];
        _isShowListViewRight = NO;
        if ([_delegate respondsToSelector:@selector(customSwitchOff)]) {
            [_delegate customSwitchOff];
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = [touches anyObject];
    
    CGPoint nowPoint = [touch locationInView:self];
    
    CGRect frame = self.frame;
    
    frame.origin.x += nowPoint.x - beginPoint.x;
    if(frame.origin.x < self.frame.origin.x)
    {
        [self swipeLeftView:YES];
        _isShowListViewRight = NO;
        if ([_delegate respondsToSelector:@selector(customSwitchOff)]) {
             [_delegate customSwitchOff];
        }
       
    }
    else if(frame.origin.x > frame.size.width)
    {
        [self swipeRightView:YES];
        _isShowListViewRight = YES;
        if ([_delegate respondsToSelector:@selector(customSwitchOn)]) {
            [_delegate customSwitchOn];
        }
    }
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
