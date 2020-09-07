//
//  AMGADRewardVideo.m
//  MojiPop
//
//  Created by bshn on 2017/12/27.
//  Copyright © 2017年 manboker. All rights reserved.
//

#import "MPGADRewardVideoServer.h"
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "MPGoogleAds.h"

@interface MPGADRewardVideoServer () <GADRewardedAdDelegate>
{
    BOOL _isAdReward;
    BOOL _isRequest;
    BOOL _isDisplay;
}
@property (nonatomic, strong) GADRewardedAd *rewardedAd;
@property (nonatomic, copy) void (^adBlock)(GAD_ActionType type);
@property (nonatomic, copy) NSString *adId;
@property (nonatomic, strong) UIViewController *viewController;
@end

@implementation MPGADRewardVideoServer

- (id)initWithAdId:(NSString *)adId viewController:(UIViewController *)viewController
{
    if (self = [super init]) {
        self.adId = adId;

        self.viewController = viewController;
        _isAdReward = NO;
        self.rewardedAd = [self createAndLoadRewardedAd];
    }
    return self;
}

- (void)requestAds
{
    if (self.adBlock) {
        self.adBlock(GAD_ActionType_Requesting);
    }
    self.rewardedAd = [self createAndLoadRewardedAd];
}

- (void)showWithBlock:(void(^)(GAD_ActionType type))block
{
    if (block) {
        self.adBlock = block;
    }
    _isAdReward = NO;
    _isDisplay = YES;
    
    if (self.rewardedAd.isReady) {
        [self.rewardedAd presentFromRootViewController:self.viewController delegate:self];
    } else {
        NSLog(@"Ad wasn't ready");
        if (!_isRequest) {
            [self requestAds];
        } else {
            if (self.adBlock) {
                self.adBlock(GAD_ActionType_Requesting);
            }
        }
    }
}

/// Tells the delegate that the user earned a reward.
- (void)rewardedAd:(GADRewardedAd *)rewardedAd userDidEarnReward:(GADAdReward *)reward
{
    // TODO: Reward the user.
    NSLog(@"rewardedAd:userDidEarnReward:  -------- %@", rewardedAd.responseInfo.adNetworkClassName);
    _isAdReward = YES;
}

/// Tells the delegate that the rewarded ad was presented.
- (void)rewardedAdDidPresent:(GADRewardedAd *)rewardedAd
{
    NSLog(@"rewardedAdDidPresent:");
}

/// Tells the delegate that the rewarded ad failed to present.
- (void)rewardedAd:(GADRewardedAd *)rewardedAd didFailToPresentWithError:(NSError *)error
{
    NSLog(@"rewardedAd:didFailToPresentWithError:%@",error);
}

/// Tells the delegate that the rewarded ad was dismissed.
- (void)rewardedAdDidDismiss:(GADRewardedAd *)rewardedAd
{
    NSLog(@"rewardedAdDidDismiss:");
    if (self.adBlock) {
        if (_isAdReward) {
            self.adBlock(GAD_ActionType_Reward);
        } else {
            self.adBlock(GAD_ActionType_Close);
        }
    }
    _isDisplay = NO;
    self.rewardedAd = [self createAndLoadRewardedAd];
}

- (GADRewardedAd *)createAndLoadRewardedAd
{
    GADRewardedAd *rewardedAd = [[GADRewardedAd alloc]
                                 initWithAdUnitID:self.adId];
    GADRequest *request = [GADRequest request];
    _isRequest = YES;
    [rewardedAd loadRequest:request completionHandler:^(GADRequestError * _Nullable error) {
        _isRequest = NO;
#if DEBUG
        GADResponseInfo *responseInfo = error.userInfo[@"gad_response_info"];
        NSLog(@"adNetworkClassName : %@", responseInfo.adNetworkClassName);
#endif
        if (_isDisplay) {
            if (error) {
                NSLog(@"GADRewardedAd error : %@", error);
                // Handle ad failed to load case.
                if (self.adBlock) {
                    self.adBlock(GAD_ActionType_Error);
                }
            } else {
                // Ad successfully loaded.
                if (self.adBlock) {
                    self.adBlock(GAD_ActionType_Ready);
                }
            }
        }
    }];
    return rewardedAd;
}

@end
