//
//  ATChatCell.m
//  RTMPCDemo
//
//  Created by derek on 2017/9/22.
//  Copyright © 2017年 jh. All rights reserved.
//

#import "ATChatCell.h"

@implementation ATChatCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.6];
    self.layer.cornerRadius = 4;
    
}
- (void)setMessageItem:(ATChatItem *)messageItem {
    _messageItem = messageItem;
    NSMutableAttributedString *nameMuStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@:",messageItem.strNickName]];
    
    NSMutableAttributedString *messageMuStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",messageItem.strContact]];
    if (messageItem.isHost) {
         [nameMuStr addAttribute:NSForegroundColorAttributeName value:[ATCommon getColor:@"#ff4b49"] range:NSMakeRange(0, nameMuStr.length)];
    }else{
         [nameMuStr addAttribute:NSForegroundColorAttributeName value:[ATCommon getColor:@"#457ff7"]  range:NSMakeRange(0, nameMuStr.length)];
    }
   
    [nameMuStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, nameMuStr.length)];
    
    [messageMuStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, messageMuStr.length)];
    [messageMuStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, messageMuStr.length)];
    
    NSMutableAttributedString *mutableStr = [[NSMutableAttributedString alloc] initWithAttributedString:nameMuStr];
    [mutableStr appendAttributedString:messageMuStr];
    
    self.atContactLabel.attributedText = mutableStr;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
