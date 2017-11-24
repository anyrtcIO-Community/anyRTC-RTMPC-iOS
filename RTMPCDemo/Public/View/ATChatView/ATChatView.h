//
//  ATChatView.h
//  RTMPCDemo
//
//  Created by derek on 2017/9/22.
//  Copyright © 2017年 jh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATChatItem.h"

@interface ATChatView : UIView

//@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (void)sendMessage:(ATChatItem*)chatItem;

@end
