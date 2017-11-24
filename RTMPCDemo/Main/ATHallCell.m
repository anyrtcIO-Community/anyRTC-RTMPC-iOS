//
//  ATHallCell.m
//  RTMPCDemo
//
//  Created by jh on 2017/9/23.
//  Copyright © 2017年 jh. All rights reserved.
//

#import "ATHallCell.h"

@implementation ATHallCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)updateCell:(LiveList *)listModel withOnLine:(NSString *)online{
    if (listModel.isAudioLive) {
        //音频
        self.audioImageView.image = [UIImage imageNamed:@"voice_image"];
    } else {
        //视频
        self.audioImageView.image = [UIImage imageNamed:@"video_image"];
    }
    
    self.topicLabel.text = listModel.liveTopic;
    
    self.userNameLabel.attributedText = [ATCommon getAttributedString:[NSString stringWithFormat:@" %@",listModel.hosterName] imageSize:CGRectMake(0, 0, 15, 15) image:[UIImage imageNamed:@"name"] index:0];
    
    self.roomIdLabel.attributedText = [ATCommon getAttributedString:[NSString stringWithFormat:@" %@",listModel.anyrtcId] imageSize:CGRectMake(0, 0, 15, 15) image:[UIImage imageNamed:@"ID"] index:0];
    
    self.onlineLabel.attributedText = [ATCommon getAttributedString:[NSString stringWithFormat:@" %@",online] imageSize:CGRectMake(0, 0, 15, 15) image:[UIImage imageNamed:@"people"] index:0];
}


@end
