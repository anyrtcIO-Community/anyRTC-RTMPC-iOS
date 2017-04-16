//
//  ViewController.m
//  RTMPCDemo
//
//  Created by EricTao on 16/7/20.
//  Copyright © 2016年 EricTao. All rights reserved.
//

#import "ViewController.h"
#import "HostViewController.h"
#import "GuestViewController.h"
#import "GuestAudioOnlyController.h"
#import "GuestVideoAudioController.h"
#import "AppDelegate.h"
#import <CommonCrypto/CommonDigest.h>
#import "HostSettingViewController.h"
#import "NetUtils.h"
#import "WXApi.h"
#import "UMSocial.h"

#import "UIButton+WebCache.h"

@implementation LivingItem

@end

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,NSURLSessionDataDelegate,NSURLConnectionDelegate,NSURLConnectionDataDelegate>

@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UILabel *mainLabel;
@property (nonatomic, strong) UILabel *subMainLabel;
@property (nonatomic, strong) UIButton *headButton;
@property (nonatomic, strong) UILabel *nickLabel;
@property (nonatomic, strong) NSMutableArray *livingDataArray;
@property (nonatomic, strong) UITableView *livingTableView;
@property (nonatomic, strong) UIButton *livingButton;
@property (nonatomic, strong) UILabel *versionLabel;

@property (nonatomic, strong) UIRefreshControl *refreshControl;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    [self.view addSubview:self.bgImageView];
    [self.view addSubview:self.mainLabel];
    [self.view addSubview:self.subMainLabel];
    [self.view addSubview:self.headButton];
    
    [self.view addSubview:self.nickLabel];
    [self.view addSubview:self.versionLabel];
    [self.view addSubview:self.livingTableView];
    [self.view addSubview:self.livingButton];
    [self setupRefresh];
}
-(void)setupRefresh
{
    //1.添加刷新控件
    self.refreshControl=[[UIRefreshControl alloc]init];
    [self.refreshControl addTarget:self action:@selector(refreshStateChange:) forControlEvents:UIControlEventValueChanged];
    [self.livingTableView addSubview:self.refreshControl];
    
    //2.马上进入刷新状态，并不会触发UIControlEventValueChanged事件
    [self.refreshControl beginRefreshing];
    
    // 3.加载数据
    [self refreshStateChange:self.refreshControl];
}

-(void)refreshStateChange:(UIRefreshControl *)control {
    __weak typeof(self)weakSelf = self;
    [[NetUtils shead] getLivingList:^(NSArray *array, NSError *error, int code) {
        if (code == 200) {
            weakSelf.livingDataArray = [array mutableCopy];
            [weakSelf.livingTableView reloadData];
            [weakSelf.refreshControl endRefreshing];
        }else{
            [weakSelf.refreshControl endRefreshing];
        }
    }];
}

#pragma mark - UITableViewDelegate UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.livingDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.livingTableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    }
    LivingItem *item = [self.livingDataArray objectAtIndex:indexPath.row];
    cell.textLabel.text = item.topic;
    if ([item.isAudioOnly boolValue]) {
        cell.imageView.image = [UIImage imageNamed:@"audiong"];
    }else{
        cell.imageView.image = [UIImage imageNamed:@"videoing"];
    }
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@人在线",item.LiveMembers];
    cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    LivingItem *item = [self.livingDataArray objectAtIndex:indexPath.row];
    if ([item.isAudioOnly boolValue]) {
        GuestAudioOnlyController *guest = [GuestAudioOnlyController new];
        guest.livingItem = item;
        [self.navigationController pushViewController:guest animated:YES];
    }else{
        if ([item.isVideoAudioLiving boolValue]) {
            GuestVideoAudioController *guest = [GuestVideoAudioController new];
            guest.livingItem = item;
            [self.navigationController pushViewController:guest animated:YES];
        }else{
            GuestViewController*guest = [GuestViewController new];
            guest.livingItem = item;
            [self.navigationController pushViewController:guest animated:YES];
        }
       
 
    }
 }

#pragma mark - button
- (void)headButtonEvent:(UIButton*)sender {
    
//    [[NetUtils shead] getRTMPAddress:@"test001" withAppName:@"huilive" withType:1 withStreamId:nil withSecretKey:nil withReturn:^(NSDictionary *dict, int code) {
//        
//    }];
//    
//    return;
    //微信登录
    if ([WXApi isWXAppInstalled]) {
        __weak typeof(self) weakSelf = self;
        
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
        
        snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
            
            if (response.responseCode == UMSResponseCodeSuccess) {
                
                // NSDictionary *dict = [UMSocialAccountManager socialAccountDictionary];
                UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:snsPlatform.platformName];
                
                [[NSUserDefaults standardUserDefaults] setObject:snsAccount.userName forKey:@"NickName"];
                [[NSUserDefaults standardUserDefaults] setObject:snsAccount.usid forKey:@"UserID"];
                [[NSUserDefaults standardUserDefaults] setObject:snsAccount.iconURL forKey:@"IconUrl"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                weakSelf.nickLabel.text = snsAccount.userName;
                [weakSelf.headButton sd_setImageWithURL:[NSURL URLWithString:snsAccount.iconURL] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"icon_photo_2"]];
                
                NSLog(@"\nusername = %@,\n usid = %@,\n token = %@ iconUrl = %@,\n unionId = %@,\n thirdPlatformUserProfile = %@,\n thirdPlatformResponse = %@ \n, message = %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL, snsAccount.unionId, response.thirdPlatformUserProfile, response.thirdPlatformResponse, response.message);
                
            }
            
        });
        
        
    }
}
- (void)livingButtonEvent:(UIButton*)sender {
    HostSettingViewController *hostSettingController = [HostSettingViewController new];
    [self.navigationController pushViewController:hostSettingController animated:YES];
//    GuestViewController*guest = [GuestViewController new];
//    [self.navigationController pushViewController:guest animated:YES];
}
#pragma mark - get
- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [UIImageView new];
        _bgImageView.image = [UIImage imageNamed:@""];
        _bgImageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    }
    return _bgImageView;
}
- (UILabel *)mainLabel {
    if (!_mainLabel) {
        _mainLabel = [UILabel new];
        _mainLabel.textAlignment = NSTextAlignmentCenter;
        _mainLabel.textColor = [UIColor blackColor];
        _mainLabel.font = [UIFont systemFontOfSize:16];
        _mainLabel.frame = CGRectMake(20, 40, CGRectGetWidth(self.view.frame)-40, 20);
        _mainLabel.text = @"RTMPC Hybird Engine";
    }
    return _mainLabel;
}
- (UILabel *)subMainLabel {
    if (!_subMainLabel) {
        _subMainLabel = [UILabel new];
        _subMainLabel.textAlignment = NSTextAlignmentCenter;
        _subMainLabel.textColor = [UIColor blackColor];
        _subMainLabel.font = [UIFont systemFontOfSize:14];
        _subMainLabel.frame = CGRectMake(20, CGRectGetMaxY(_mainLabel.frame), CGRectGetWidth(self.view.frame)-40, 20);
        _subMainLabel.text = @"多人连麦直播";
    }
    return _subMainLabel;
}
- (UIButton*)headButton {
    if (!_headButton) {
        _headButton = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *imageIcon = [[NSUserDefaults standardUserDefaults] valueForKey:@"IconUrl"];
        imageIcon = imageIcon?imageIcon:@"";
        [_headButton sd_setImageWithURL:[NSURL URLWithString:imageIcon] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"icon_photo_2"]];
        //        [_headButton setImage:[UIImage imageNamed:@"icon_photo_2"] forState:UIControlStateNormal];
        [_headButton addTarget:self action:@selector(headButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        _headButton.frame = CGRectMake(CGRectGetMaxX(self.view.frame)/2-30, CGRectGetMaxY(_subMainLabel.frame)+ 20, 60, 60);
        _headButton.layer.cornerRadius = 30;
        _headButton.layer.masksToBounds = YES;
    }
    return _headButton;
}
- (UILabel*)nickLabel {
    if (!_nickLabel) {
        _nickLabel = [UILabel new];
        _nickLabel.textAlignment = NSTextAlignmentCenter;
        _nickLabel.textColor = [UIColor blackColor];
        _nickLabel.font = [UIFont systemFontOfSize:14];
        _nickLabel.frame = CGRectMake(20, CGRectGetMaxY(_headButton.frame), CGRectGetWidth(self.view.frame)-40, 20);
        NSString *nikeName = [[NSUserDefaults standardUserDefaults] valueForKey:@"NickName"];
        if (nikeName) {
            _nickLabel.text = nikeName;
        }else{
            NSString *name = [self getNickName];
            [[NSUserDefaults standardUserDefaults] setObject:name forKey:@"NickName"];
            [[NSUserDefaults standardUserDefaults] setObject:[self randomString:12] forKey:@"UserID"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            _nickLabel.text = name;
        }
        
    }
    return _nickLabel;
}
- (UILabel *)versionLabel {
    if (!_versionLabel) {
        _versionLabel = [UILabel new];
        _versionLabel.textAlignment = NSTextAlignmentCenter;
        _versionLabel.textColor = [UIColor blackColor];
        _versionLabel.font = [UIFont systemFontOfSize:14];
        _versionLabel.frame = CGRectMake(20, CGRectGetMaxY(self.view.frame)-30, CGRectGetWidth(self.view.frame)-40, 20);
        _versionLabel.text = @"Anyrtc.io V 1.1.28, 2017.04.12";
    }
    return _versionLabel;
}
- (UITableView*)livingTableView {
    if (!_livingTableView) {
        _livingTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.nickLabel.frame)+20, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-CGRectGetMaxY(self.nickLabel.frame)-20-30) style:UITableViewStylePlain];
        _livingTableView.backgroundColor = [UIColor clearColor];
        _livingTableView.dataSource = self;
        _livingTableView.delegate = self;
        _livingTableView.tableFooterView = [UIView new];
    }
    return _livingTableView;
}
- (UIButton*)livingButton {
    if (!_livingButton) {
        _livingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_livingButton setImage:[UIImage imageNamed:@"btn_startbc_normal"] forState:UIControlStateNormal];
        [_livingButton addTarget:self action:@selector(livingButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        _livingButton.frame = CGRectMake(CGRectGetMaxX(self.view.frame)/2-30, CGRectGetMinY(self.versionLabel.frame)-80, 60, 60);
    }
    return _livingButton;
}
- (NSString*)getNickName {
    NSArray *array  = @[@"Derek",@"Jason",@"Eric",@"Ming",@"Dawei",@"Esacpe",@"Cantarella",@"Betray",@"LonElY",@"Haggard",@"Proditio",@"Birdy-sea",@"Abyss",@"Frank",@"Catnip",@"Slag male",@"Unfair",@"Pretty boy",@"Rangers",@"Awesome",@"Hatsukoi",@"Belief",@"Energy",@"Amanda",@"Allen",@"Ann",@"Ava",@"Alger",@"Betty",@"Barbara",@"Brooke",@"Benjamin",@"Baird",@"Christina",@"Carol",@"Caroline",@"Cedric",@"Claude",@"Colin",@"Caesar",@"Chester",@"Corey",@"Hilary",@"Hunter",@"Harvey",@"Hardy",@"Isaac",@"Isidore",@"Ivan",@"Ives",@"Ulysses",@"Upton",@"Uriah",@"Tracy",@"Taylor",@"Teresa",@"Tyrone",@"Tobias",@"Sophia",@"Shirley",@"Sally",@"Shelly",@"Samantha"
];
    
    return array[arc4random()%(array.count-1)];
}
- (NSString*) randomString:(int)len {
    
    char* charSet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
    
    char* temp = malloc(len + 1);
    
    for (int i = 0; i < len; i++) {
        
        int randomPoz = arc4random()%strlen(charSet);
        
        temp[i] = charSet[randomPoz];
        
    }
    
    temp[len] = '\0';
    
    NSMutableString* randomString = [[NSMutableString alloc] initWithUTF8String:temp];
    
    free(temp);
    
    return randomString;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

