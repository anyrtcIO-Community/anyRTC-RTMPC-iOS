//
//  ArRealTimeMicController.m
//  RTMPCDemo
//
//  Created by 余生丶 on 2019/4/16.
//  Copyright © 2019 anyRTC. All rights reserved.
//

#import "ArRealTimeMicController.h"
#import "ArRealMicCell.h"

@interface ArRealTimeMicController ()<MicResultDelegate>

@property (weak, nonatomic) IBOutlet UITableView *micTableView;

@property (weak, nonatomic) IBOutlet UIButton *emptyButton;

@end

@implementation ArRealTimeMicController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.micTableView.tableFooterView = [UIView new];
    (self.micArr.count == 0) ? (self.emptyButton.hidden = NO) : (self.emptyButton.hidden = YES);
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(micRefresh:) name:@"LineNumChangeNotification" object:nil];
}

- (void)micRefresh:(NSNotification*)notify {
    [self.micTableView reloadData];
    self.emptyButton.hidden = self.micArr.count;
}

//MARK: - MicResultDelegate

- (void)micResult:(NSString *)peerId agree:(BOOL)isAgree {
    isAgree ? ([self.hosterKit acceptRTCLine:peerId]) : ([self.hosterKit rejectRTCLine:peerId]);
    [self.micArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[ArRealMicModel class]]) {
            ArRealMicModel *micModel = (ArRealMicModel *)obj;
            if ([micModel.peerId isEqualToString:peerId]) {
                [self.micArr removeObjectAtIndex:idx];
                [self.micTableView reloadData];
                *stop = YES;
            }
        }
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}

//MARK: - UITableViewDelegate,UITableViewDataSource

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ArRealMicCell *cell = (ArRealMicCell *) [tableView dequeueReusableCellWithIdentifier:@"RTMPC_Mic_CellID"];
    cell.realMicModel = self.micArr[indexPath.row];
    cell.delegate = self;
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.micArr.count;
}

//MARK: - Touch

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSSet *allTouches = [event allTouches];
    UITouch *touch = [allTouches anyObject];
    CGPoint point = [touch locationInView:self.view];
    
    if (point.y <  SCREEN_HEIGHT * 4/7) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)dealloc{
    [NSNotificationCenter.defaultCenter removeObserver:self name:@"LineNumChangeNotification" object:nil];
}

@end
