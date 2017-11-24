//
//  ATLineListViewController.m
//  RTMPCDemo
//
//  Created by derek on 2017/9/23.
//  Copyright © 2017年 jh. All rights reserved.
//

#import "ATLineListViewController.h"
#import "ATLineCell.h"

static NSString *atLineCell = @"ATLineCell";
@interface ATLineListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *emptyView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation ATLineListViewController
- (void) dealloc {
      [[NSNotificationCenter  defaultCenter] removeObserver:self  name:@"LineNumChangeNotification" object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    // Do any additional setup after loading the view from its nib.
    [self.tableView registerNib:[UINib nibWithNibName:@"ATLineCell" bundle:nil] forCellReuseIdentifier:atLineCell];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 60;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChnage:) name:@"LineNumChangeNotification" object:nil];
    
}
- (void)setLineData:(NSMutableArray*)array {
    self.dataArray = [array mutableCopy];
    [self.tableView reloadData];
    if (self.dataArray.count == 0) {
        self.emptyView.hidden = NO;
    }else{
        self.emptyView.hidden = YES;
    }
}

- (void)dataChnage:(NSNotification*)notify {
     self.dataArray = [[notify object] mutableCopy];//通过这个获取到传递的对象
    [self.tableView reloadData];
    if (self.dataArray.count == 0) {
        self.emptyView.hidden = NO;
    }else{
        self.emptyView.hidden = YES;
    }
}

- (IBAction)tapEvent:(id)sender {
    if (self.dismissBlock) {
        self.dismissBlock();
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDelegate UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ATLineCell *cell = (ATLineCell*)[tableView dequeueReusableCellWithIdentifier:atLineCell];
    if (cell == nil) {
        cell = [[ATLineCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:atLineCell];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    __weak typeof(self)weakSelf = self;
    cell.requestBlock = ^(ATLineItem *lineItem, BOOL isAgain) {
        if (weakSelf.requestBlock) {
            weakSelf.requestBlock(lineItem.strPeerId, isAgain);
        }
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    };
    cell.lineItem = [self.dataArray objectAtIndex:indexPath.row];
    
    return cell;
}


#pragma mark - Table View Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
