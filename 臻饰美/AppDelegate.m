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
#import <CoreTelephony/CTCellularData.h>

@interface AppDelegate ()<WXApiDelegate,JPUSHRegisterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"%@",[TTUserInfoManager deviceToken]);
    NSLog(@"%@",[TTUserInfoManager jPushRegistID]);
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    MessageHandlerViewController *mainVC = [[MessageHandlerViewController alloc] init];
    
    self.window.rootViewController = mainVC;
    [WXApi registerApp:WechatAppID];
//    [self prepareAPNs];
//    [self prepareJPushWithOptions:launchOptions];

    [self starNetWorkObservWithOptions:launchOptions];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    //启动基本SDK
    [[PgyManager sharedPgyManager] startManagerWithAppId:PGY_APP_ID];
    //启动更新检查SDK
    [[PgyUpdateManager sharedPgyManager] startManagerWithAppId:PGY_APP_ID];
    [[PgyManager sharedPgyManager] setEnableFeedback:NO];
    [[PgyUpdateManager sharedPgyManager] checkUpdate];

    return YES;
}
- (void)starNetWorkObservWithOptions:(NSDictionary *)launchOptions{
    AFNetworkReachabilityManager *netManager = [AFNetworkReachabilityManager sharedManager];
    [netManager startMonitoring];  //开始监听
    [netManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status){
        if (status == AFNetworkReachabilityStatusNotReachable){
            NSLog(@"网络链接错误,请检查网络链接");
//            [self checkNetWorkAuth];
            return;
        }else if (status == AFNetworkReachabilityStatusUnknown){
            NSLog(@"未知网络");
        }else if (status == AFNetworkReachabilityStatusReachableViaWWAN||status == AFNetworkReachabilityStatusReachableViaWiFi){
            NSLog(@"WAN WIFI");
            [WXApi registerApp:WechatAppID];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshWeb" object:nil];
            [self prepareAPNs];
            [self prepareJPushWithOptions:launchOptions];
        }
    }];
}
- (void)checkNetWorkAuth{
    if (@available(iOS 9.0, *)) {
        CTCellularData *cellularData = [[CTCellularData alloc]init];
        cellularData.cellularDataRestrictionDidUpdateNotifier = ^(CTCellularDataRestrictedState state){
            
            switch (state) {
                case kCTCellularDataRestricted:
                    // app网络权限受限
                    //各种操作
                {
                    NSLog(@"app网络权限受限");
                    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"网络设置已关闭" preferredStyle:UIAlertControllerStyleAlert];
                    [alertC addAction:[UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        NSURL * url = [NSURL URLWithString: UIApplicationOpenSettingsURLString];
                        if ( [[UIApplication sharedApplication] canOpenURL: url] ) {
                            [[UIApplication sharedApplication] openURL:url];
                        }
                    }]];
                    [self.window.rootViewController presentViewController:alertC animated:YES completion:nil];

                }
                    break;
                case kCTCellularDataRestrictedStateUnknown:
                    // app网络权限不确定
                    // 各种操作
                    NSLog(@"app网络权限不确定");
                    break;
                case kCTCellularDataNotRestricted:
                    // app网络权限不受限
                    // 各种操作
                    NSLog(@"app网络权限不确定");
                    break;
                    
                default:
                    break;
            }
        };

    }
}
//MARK:添加初始化APNs代码
- (void)prepareAPNs{
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionSound;
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
}
//MARK:初始化JPush代码
- (void)prepareJPushWithOptions:(NSDictionary *)launchOptions {
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:JGPushAppkey
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
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshWeb" object:nil];
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
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"didReceiveRemoteNotification :%@",userInfo);
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler  API_AVAILABLE(ios(10.0)){
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 前台收到远程通知:%@", userInfo);
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler  API_AVAILABLE(ios(10.0)){
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    NSLog(@"didReceiveRemoteNotification :%@",userInfo);
    [JPUSHService handleRemoteNotification:userInfo];
}
- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary * userInfo = [notification userInfo];
//    NSString *content = [userInfo valueForKey:@"content"];
//    NSString *messageID = [userInfo valueForKey:@"_j_msgid"];
//    NSDictionary *extras = [userInfo valueForKey:@"extras"];
//    NSString *customizeField1 = [extras valueForKey:@"customizeField1"]; //服务端传递的Extras附加字段，key是自己定义的
    NSLog(@"%@",userInfo);
    
}
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
- (void)applicationDidBecomeActive:(UIApplication *)application{
    application.applicationIconBadgeNumber = 0;
}
- (void)applicationWillResignActive:(UIApplication *)application{
    application.applicationIconBadgeNumber = 0;
}
@end
