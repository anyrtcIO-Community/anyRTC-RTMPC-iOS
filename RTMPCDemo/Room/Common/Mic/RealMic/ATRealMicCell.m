//
//  ATRealMicCell.m
//  RTMPCDemo
//
//  Created by jh on 2018/4/12.
//  Copyright © 2018年 jh. All rights reserved.
//

#import "ATRealMicCell.h"

@interface ATRealMicCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIButton *rejectButton;

@end

@implementation ATRealMicCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setRealMicModel:(ATRealMicModel *)realMicModel{
    _realMicModel = realMicModel;
    NSMutableAttributedString *nameMuStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@:",realMicModel.userName?realMicModel.userName:realMicModel.peerId]];
    
    NSMutableAttributedString *messageMuStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" 申请连麦"]];
    
    [nameMuStr addAttribute:NSForegroundColorAttributeName value:ATBlueColor range:NSMakeRange(0, nameMuStr.length)];
    [nameMuStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, nameMuStr.length)];
    
    [messageMuStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, messageMuStr.length)];
    [messageMuStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, messageMuStr.length)];
    
    NSMutableAttributedString *mutableStr = [[NSMutableAttributedString alloc] initWithAttributedString:nameMuStr];
    [mutableStr appendAttributedString:messageMuStr];
    
    self.nameLabel.attributedText = mutableStr;
}

- (IBAction)doSomethingEvents:(UIButton *)sender {
    BOOL isAgree = false;
    (sender.tag == 50) ? (isAgree = YES) : 0;

    if ([self.delegate respondsToSelector:@selector(micResult:agree:)]) {
        [self.delegate micResult:self.realMicModel.peerId agree:isAgree];
    }
}

@end
