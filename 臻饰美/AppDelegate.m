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
#import <AlipaySDK/AlipaySDK.h>
#import "WxApi.h"

// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

#import "MessageHandlerViewController.h"

@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
//    RootWebViewController *mainVC = [[RootWebViewController alloc] init];
    MessageHandlerViewController *mainVC = [[MessageHandlerViewController alloc] init];
    
    self.window.rootViewController = mainVC;

    [self starNetWorkObservWithOptions:launchOptions];
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
            [WXApi registerApp:@"wx00f0bfcec76454ce"];

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
////MARK:处理APNs通知回调方法
//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
//    // Required, iOS 7 Support
//    [JPUSHService handleRemoteNotification:userInfo];
//    completionHandler(UIBackgroundFetchResultNewData);
//}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            NSString *resultStatus = [resultDic objectForKey:@"resultStatus"];
            //充值成功之后，需要重新获取一下积分信息才可以
            if ([resultStatus isEqualToString:@"9000"]) {
                //success
            }
            else{
                //FAILED
            }
        }];
    }
    else{
        return [WXApi handleOpenURL:url delegate:self];
    }
    return YES;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            NSString *resultStatus = [resultDic objectForKey:@"resultStatus"];
            if ([resultStatus isEqualToString:@"9000"]) {
                //success
            }
            else{
                //FAILED
            }
        }];
        return YES;
    }
    else{
        return [WXApi handleOpenURL:url delegate:self];
    }
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [WXApi handleOpenURL:url delegate:self];
}
#pragma -mark 微信支付回调
-(void)onResp:(BaseResp*)resp{
    NSLog(@"onResp :%@ %d",resp,resp.errCode);
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        switch (resp.errCode) {
            case WXSuccess:{
                [self.window makeToast:@"支付成功"];
            }
                break;
            case WXErrCodeUserCancel:{
                [self.window makeToast:@"支付取消"];
            }
            break;
            case WXErrCodeAuthDeny:{
                [self.window makeToast:@"授权失败"];
            }
            break;
                
            default:{
                [self.window makeToast:@"支付失败"];
            }
                break;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"payResp" object:resp];
    }
    else if ([resp isKindOfClass:[SendAuthResp class]]){
        switch (resp.errCode) {
            case WXSuccess:{
                [self.window makeToast:@"登录成功"];
            }
                break;
            case WXErrCodeUserCancel:{
                [self.window makeToast:@"登录取消"];
            }
                break;
            case WXErrCodeAuthDeny:{
                [self.window makeToast:@"授权失败"];
            }
                break;
                
            default:{
                [self.window makeToast:@"授权失败"];
            }
                break;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"authResp" object:resp];
    }
    
}
@end
