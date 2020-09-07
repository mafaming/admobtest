//
//  AppDelegate.m
//  admobtest
//
//  Created by mafaming on 2020/9/7.
//  Copyright © 2020 mafaming. All rights reserved.
//

#import "AppDelegate.h"
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "ViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[GADMobileAds sharedInstance] startWithCompletionHandler:nil];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [UIApplication sharedApplication].delegate.window = self.window;
    
    ViewController *agreementVC = [[ViewController alloc] init];
    self.window.rootViewController = agreementVC;
    return YES;
}
@end
