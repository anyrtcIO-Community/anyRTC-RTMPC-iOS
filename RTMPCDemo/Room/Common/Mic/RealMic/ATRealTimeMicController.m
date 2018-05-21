//
//  ATRealTimeMicController.m
//  RTMPCDemo
//
//  Created by jh on 2018/4/12.
//  Copyright © 2018年 jh. All rights reserved.
//

#import "ATRealTimeMicController.h"

@interface ATRealTimeMicController ()<UITableViewDelegate,UITableViewDataSource,MicResultDelegate>

@property (weak, nonatomic) IBOutlet UITableView *micTableView;

@property (weak, nonatomic) IBOutlet UITableView *emptyView;

@end

@implementation ATRealTimeMicController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.micTableView.tableFooterView = [UIView new];
    (self.micArr.count == 0) ? (self.emptyView.hidden = NO) : (self.emptyView.hidden = YES);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(micRefresh:) name:@"LineNumChangeNotification" object:nil];
}

- (void)micRefresh:(NSNotification*)notify {
    [self.micTableView reloadData];
    (self.micArr.count == 0) ? (self.emptyView.hidden = NO) : (self.emptyView.hidden = YES);
}

#pragma mark - MicResultDelegate

- (void)micResult:(NSString *)peerId agree:(BOOL)isAgree{
    
    if (self.mHosterKit) {
        isAgree ? ([self.mHosterKit acceptRTCLine:peerId]) : ([self.mHosterKit hangupRTCLine:peerId]);
    }
    
    if (self.mHosterAudioKit) {
        isAgree ? ([self.mHosterAudioKit acceptRTCLine:peerId]) : ([self.mHosterAudioKit hangupRTCLine:peerId]);
    }
    
    [self.micArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[ATRealMicModel class]]) {
            ATRealMicModel *micModel = (ATRealMicModel *)obj;
            if ([micModel.peerId isEqualToString:peerId]) {
                [self.micArr removeObjectAtIndex:idx];
                [self.micTableView reloadData];
                *stop = YES;
            }
        }
    }];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ATRealMicCell *cell = (ATRealMicCell *) [tableView dequeueReusableCellWithIdentifier:@"RTMPC_Mic_CellID"];
    cell.realMicModel = self.micArr[indexPath.row];
    cell.delegate = self;
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.micArr.count;
}

#pragma mark - Touch

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSSet *allTouches = [event allTouches];
    UITouch *touch = [allTouches anyObject];
    CGPoint point = [touch locationInView:self.view];
    
    if (point.y <  SCREEN_HEIGHT * 4/7) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)dealloc{
      [[NSNotificationCenter  defaultCenter] removeObserver:self  name:@"LineNumChangeNotification" object:nil];
}

@end
