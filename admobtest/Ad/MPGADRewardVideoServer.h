//
//  AMGADRewardVideo.h
//  MojiPop
//
//  Created by bshn on 2017/12/27.
//  Copyright © 2017年 manboker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GAD_ActionType) {
    GAD_ActionType_Close = 0,       // 广告未完成用户点击close
    GAD_ActionType_Reward,          // 广告结束，点击close
    GAD_ActionType_Requesting,
    GAD_ActionType_Ready,
    GAD_ActionType_Error            // Error
};

@interface MPGADRewardVideoServer : NSObject

- (id)initWithAdId:(NSString *)adId viewController:(UIViewController *)viewController;

- (void)showWithBlock:(void(^)(GAD_ActionType type))block;

@end
