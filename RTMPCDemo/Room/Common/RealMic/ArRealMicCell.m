//
//  ArRealMicCell.m
//  RTMPCDemo
//
//  Created by 余生丶 on 2019/4/17.
//  Copyright © 2019 anyRTC. All rights reserved.
//

#import "ArRealMicCell.h"

@interface ArRealMicCell()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation ArRealMicCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [ArCommon getColor:@"#F6F8F9"];
}

- (void)setRealMicModel:(ArRealMicModel *)realMicModel {
    _realMicModel = realMicModel;
    self.nameLabel.text = [NSString stringWithFormat:@"%@  申请连麦",realMicModel.userName];
}

- (IBAction)doSomethingEvent:(UIButton *)sender {
    BOOL isAgree = false;
    (sender.tag == 50) ? (isAgree = YES) : 0;

    if ([self.delegate respondsToSelector:@selector(micResult:agree:)]) {
        [self.delegate micResult:self.realMicModel.peerId agree:isAgree];
    }
}

@end
