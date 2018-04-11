//
//  AppDelegate.m
//  臻饰美
//
//  Created by 方子辰 on 2018/4/10.
//  Copyright © 2018年 方子辰. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "RootWebViewController.h"
// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    if ([TTUserInfoManager logined] == YES) {
        RootWebViewController *mainVC = [[RootWebViewController alloc] init];
        self.window.rootViewController = mainVC;
    }
    else{
        LoginViewController *mainVC = [[LoginViewController alloc] init];
        self.window.rootViewController = mainVC;
    }
//    [self starNetWorkObservWithOptions:launchOptions];
    return YES;
}
- (void)starNetWorkObservWithOptions:(NSDictionary *)launchOptions{
    AFNetworkReachabilityManager *netManager = [AFNetworkReachabilityManager sharedManager];
    [netManager startMonitoring];  //开始监听
    [netManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status){
        if (status == AFNetworkReachabilityStatusNotReachable){
            NSLog(@"网络链接错误,请检查网络链接");
            return;
        }else if (status == AFNetworkReachabilityStatusUnknown){
            NSLog(@"未知网络");
        }else if (status == AFNetworkReachabilityStatusReachableViaWWAN||status == AFNetworkReachabilityStatusReachableViaWiFi){
            NSLog(@"WAN WIFI");
//            [self prepareAPNs];
//            [self prepareJPushWithOptions:launchOptions];
        }
    }];
}
//MARK:添加初始化APNs代码
- (void)prepareAPNs{
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionSound;
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:nil];
}
//MARK:初始化JPush代码
- (void)prepareJPushWithOptions:(NSDictionary *)launchOptions {
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:@"ad4193fb8db76ad975194754"
                          channel:@"1"
                 apsForProduction:0
            advertisingIdentifier:nil];
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            NSLog(@"registrationID获取成功：%@",registrationID);
            [TTUserInfoManager setJPUSHRegistID:registrationID];
        }
        else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
    
}
//MARK:DeviceToken
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    /// Required - 注册 DeviceToken
    NSMutableString *deviceTokenStr = [NSMutableString string];
    const char *bytes = deviceToken.bytes;
    int iCount = (int)deviceToken.length;
    for (int i = 0; i < iCount; i++) {
        [deviceTokenStr appendFormat:@"%02x", bytes[i]&0x000000FF];
    }
    NSLog(@"方式1：%@", deviceTokenStr);
    [JPUSHService registerDeviceToken:deviceToken];
    if (deviceTokenStr) {
        [TTUserInfoManager setAPNsDeviceToken:deviceTokenStr];
    }
    
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}
//MARK:处理APNs通知回调方法
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

@end
