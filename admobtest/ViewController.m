//
//  ViewController.m
//  admobtest
//
//  Created by mafaming on 2020/9/7.
//  Copyright © 2020 mafaming. All rights reserved.
//

#import "ViewController.h"
#import "MPGoogleAds.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <GoogleMobileAdsMediationTestSuite/GoogleMobileAdsMediationTestSuite.h>

@interface ViewController ()
@property (nonatomic, strong) UIButton *rewardButton;
@property (nonatomic, strong) UIButton *testButton;
@property (nonatomic, strong) MPGADRewardVideoServer *rewardVideoServer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.rewardButton];
    [self.view addSubview:self.testButton];
    
    GADMobileAds.sharedInstance.requestConfiguration.testDeviceIdentifiers = @[ @"7921e2051c1a0fc49c9a1c2b30353bff" ];
}

- (void)rewardAction
{
    __weak __typeof(&*self)weakSelf = self;
    [self.rewardVideoServer showWithBlock:^(GAD_ActionType type) {
        if (type == GAD_ActionType_Reward) {
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        } else if (type == GAD_ActionType_Error) {
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        } else if (type == GAD_ActionType_Requesting) {
            [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
        } else if (type == GAD_ActionType_Ready) {
            [weakSelf rewardAction];
        } else if (type == GAD_ActionType_Close) {
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        }
    }];
}

- (void)testAction
{
    [GoogleMobileAdsMediationTestSuite presentOnViewController:self delegate:nil];
}

#pragma mark - Get
- (UIButton *)rewardButton
{
    if (!_rewardButton) {
        _rewardButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 100, self.view.frame.size.width-20*2, 40)];
        [_rewardButton setTitle:@"Reward Ad" forState:UIControlStateNormal];
        [_rewardButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _rewardButton.backgroundColor = [UIColor redColor];
        [_rewardButton addTarget:self action:@selector(rewardAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rewardButton;
}

- (UIButton *)testButton
{
    if (!_testButton) {
        _testButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 160, self.view.frame.size.width-20*2, 40)];
        [_testButton setTitle:@"Admob Test" forState:UIControlStateNormal];
        [_testButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _testButton.backgroundColor = [UIColor redColor];
        [_testButton addTarget:self action:@selector(testAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _testButton;
}

- (MPGADRewardVideoServer *)rewardVideoServer
{
    if (!_rewardVideoServer) {
        _rewardVideoServer = [[MPGADRewardVideoServer alloc] initWithAdId:kGoogleAds_rewarded viewController:self];
    }
    return _rewardVideoServer;
}

@end
