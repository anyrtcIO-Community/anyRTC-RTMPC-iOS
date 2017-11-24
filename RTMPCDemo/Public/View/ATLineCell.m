//
//  ATLineCell.m
//  RTMPCDemo
//
//  Created by derek on 2017/9/23.
//  Copyright © 2017年 jh. All rights reserved.
//

#import "ATLineCell.h"

@implementation ATLineCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.againButton.layer.shadowColor = ATBlueColor.CGColor;
    self.againButton.layer.shadowOffset = CGSizeMake(0.0, 3.0);
    self.againButton.layer.shadowOpacity = YES;
}
- (void)setLineItem:(ATLineItem *)lineItem {
    _lineItem = lineItem;
    NSMutableAttributedString *nameMuStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@:",lineItem.strUserName?lineItem.strUserName:lineItem.strPeerId]];
    
    NSMutableAttributedString *messageMuStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" 申请连麦"]];
    
    [nameMuStr addAttribute:NSForegroundColorAttributeName value:ATBlueColor range:NSMakeRange(0, nameMuStr.length)];
    [nameMuStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, nameMuStr.length)];
    
    [messageMuStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, messageMuStr.length)];
    [messageMuStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, messageMuStr.length)];
    
    NSMutableAttributedString *mutableStr = [[NSMutableAttributedString alloc] initWithAttributedString:nameMuStr];
    [mutableStr appendAttributedString:messageMuStr];
    
    self.atTitleLabel.attributedText = mutableStr;
}
- (IBAction)doSameEvent:(id)sender {
    UIButton *button = (UIButton*)sender;
    switch (button.tag) {
        case 100:
        {
            //　同意连麦
            if (self.requestBlock) {
                self.requestBlock(self.lineItem, YES);
            }
        }
            break;
        case 101:
        {
            //　取消连麦
            if (self.requestBlock) {
                self.requestBlock(self.lineItem, NO);
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
